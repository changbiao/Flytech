//
//  ZBConnectionPool.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 19/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBConnectionPool.h"
#import "ZBStand+Private.h"
#import "ZBConnectionAttempt.h"
#import "ZBErrorDomain+Factory.h"
#import "CBPeripheral+ZBServices.h"

@interface ZBConnectionPool ()

@property (weak, nonatomic) ZBZeeba *zeeba;
@property (strong, nonatomic) NSHashTable *weakConnectivityObservers;
@property (strong, nonatomic) NSMutableSet *connectionAttempts;
@property (strong, nonatomic) NSMutableSet *internalConnectedStands;

@end

@implementation ZBConnectionPool

#pragma mark - Life Cycle

- (instancetype)init {
    [NSException raise:NSGenericException format:@"Disabled. Use +[[%@ alloc] %@] instead", NSStringFromClass([self class]), NSStringFromSelector(@selector(initWithZeeba:))];
    return nil;
}

- (instancetype)initWithZeeba:(ZBZeeba *)zeeba {
    self = [super init];
    if (self) {
        self.zeeba = zeeba;
    }
    return self;
}

#pragma mark - Public Interface

- (NSSet<id<ZBConnectivityObserver>> *)connectivityObservers {
    return self.weakConnectivityObservers.setRepresentation;
}

- (NSSet<ZBStand *> *)stands {
    return [[self.connectionAttempts valueForKey:NSStringFromSelector(@selector(stand))] setByAddingObjectsFromSet:self.internalConnectedStands];
}

- (NSSet<ZBStand *> *)connectedStands {
    return self.internalConnectedStands.copy;
}

- (void)addConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver {
    [self.weakConnectivityObservers addObject:connectivityObserver];
}

- (void)removeConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver {
    [self.weakConnectivityObservers removeObject:connectivityObserver];
}

- (void)connectStand:(ZBStand *)stand timeout:(NSTimeInterval)timeout completionHandler:(ZBConnectCompletionHandler)completionHandler {
    NSPredicate *connectionAttemptPredicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(stand)), stand];
    NSSet *existingConnectionAttempts = [self.connectionAttempts filteredSetUsingPredicate:connectionAttemptPredicate];
    if (existingConnectionAttempts.count) {
        completionHandler(stand, [ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeAlreadyConnecting]);
        return;
    }
    if ([self.internalConnectedStands containsObject:stand]) {
        NSPredicate *connectedStandPredicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(identifier)), stand.identifier];
        ZBStand *connectedStand = [[self.internalConnectedStands filteredSetUsingPredicate:connectedStandPredicate] anyObject];
        completionHandler(connectedStand, nil);
        return;
    }
    NSTimer *timeoutTimer = timeout == ZBTimeoutInfinity ? nil : [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timeoutTimerElapsed:) userInfo:nil repeats:NO];
    ZBConnectionAttempt *connectionAttempt = [[ZBConnectionAttempt alloc] initWithStand:stand timeoutTimer:timeoutTimer completionHandler:completionHandler];
    [self processConnectionAttempt:connectionAttempt];
}

- (void)disconnectStand:(ZBStand *)stand {
    if (stand.peripheral) {
        [self.centralManager cancelPeripheralConnection:stand.peripheral];
        return;
    }
    ZBConnectionAttempt *connectionAttempt = [self connectionAttemptForStand:stand];
    [self completeConnectionAttempt:connectionAttempt error:[ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeConnectionInterrupted]];
}

#pragma mark - Internals

- (void)processConnectionAttempt:(ZBConnectionAttempt *)connectionAttempt {
    [self.connectionAttempts addObject:connectionAttempt];
    NSMutableDictionary *connectionOptions = [NSMutableDictionary dictionaryWithDictionary:@{ CBConnectPeripheralOptionNotifyOnDisconnectionKey: @NO }];
    #if TARGET_OS_IPHONE
    connectionOptions[CBConnectPeripheralOptionNotifyOnConnectionKey] = @NO;
    connectionOptions[CBConnectPeripheralOptionNotifyOnNotificationKey] = @NO;
    #endif
    if (connectionAttempt.stand.peripheral) {
        [self.centralManager connectPeripheral:connectionAttempt.stand.peripheral options:connectionOptions];
        return;
    }
    NSArray *knownPeripherals = [self.centralManager retrievePeripheralsWithIdentifiers:@[ connectionAttempt.stand.identifier ]];
    if (knownPeripherals.count) {
        [self.centralManager connectPeripheral:knownPeripherals.firstObject options:connectionOptions];
        return;
    }
    NSArray *connectedPeripherals = [self.centralManager retrieveConnectedPeripheralsWithServices:@[ [CBUUID UUIDWithString:ZBServiceUUIDStringSerialPortOne] ]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(identifier)), connectionAttempt.stand.identifier];
    CBPeripheral *peripheral = [[connectedPeripherals filteredArrayUsingPredicate:predicate] firstObject];
    if (peripheral) {
        [self.centralManager connectPeripheral:peripheral options:connectionOptions];
        return;
    }
    [self completeConnectionAttempt:connectionAttempt error:[ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeUndefined]];
}

- (void)openCommunicationChannelForConnectionAttempt:(ZBConnectionAttempt *)connectionAttempt {
    [connectionAttempt.stand prepareForUseWithCompletion:^(NSError *error) {
        if (error) {
            [self completeConnectionAttempt:connectionAttempt error:[ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeConnectionFailed]];
            return;
        }
        [self completeConnectionAttempt:connectionAttempt error:nil];
    }];
}

- (void)completeConnectionAttempt:(ZBConnectionAttempt *)connectionAttempt error:(NSError *)error {
    [connectionAttempt.timeoutTimer invalidate];
    ZBStand *stand = connectionAttempt.stand;
    ZBConnectCompletionHandler completionHandler = connectionAttempt.completionHandler;
    [self.connectionAttempts removeObject:connectionAttempt];
    if (!error) {
        [self.internalConnectedStands addObject:stand];
    }
    completionHandler(stand, error);
}

- (ZBConnectionAttempt *)connectionAttemptForTimeoutTimer:(NSTimer *)timeoutTimer {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(timeoutTimer)), timeoutTimer];
    return [[self.connectionAttempts filteredSetUsingPredicate:predicate] anyObject];
}

- (ZBConnectionAttempt *)connectionAttemptForPeripheral:(CBPeripheral *)peripheral {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K.%K == %@", NSStringFromSelector(@selector(stand)), NSStringFromSelector(@selector(identifier)), peripheral.identifier];
    return [[self.connectionAttempts filteredSetUsingPredicate:predicate] anyObject];
}

- (ZBConnectionAttempt *)connectionAttemptForStand:(ZBStand *)stand {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(stand)), stand];
    return [[self.connectionAttempts filteredSetUsingPredicate:predicate] anyObject];
}

- (ZBStand *)connectedStandForPeripheral:(CBPeripheral *)peripheral {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(identifier)), peripheral.identifier];
    return [[self.internalConnectedStands filteredSetUsingPredicate:predicate] anyObject];
}

#pragma mark - Target Actions

- (void)timeoutTimerElapsed:(NSTimer *)timer {
    [self completeConnectionAttempt:[self connectionAttemptForTimeoutTimer:timer] error:[ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeConnectionTimedOut]];
}

#pragma mark - ZBCentralManagerDelegateProxy

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    dispatch_async(dispatch_get_main_queue(), ^{
        ZBConnectionAttempt *connectionAttempt = [self connectionAttemptForPeripheral:peripheral];
        [connectionAttempt.timeoutTimer invalidate];
        connectionAttempt.stand.peripheral = peripheral;
        [self openCommunicationChannelForConnectionAttempt:connectionAttempt];
    });
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        ZBConnectionAttempt *connectionAttempt = [self connectionAttemptForPeripheral:peripheral];
        connectionAttempt.stand.peripheral = peripheral;
        [self completeConnectionAttempt:connectionAttempt error:[ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeConnectionFailed userInfo:@{ NSUnderlyingErrorKey: error }]];
    });
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        ZBStand *correspondingStand = [self connectedStandForPeripheral:peripheral];
        if (correspondingStand) {
            [self.internalConnectedStands removeObject:correspondingStand];
            for (id<ZBConnectivityObserver> connectivityObserver in self.connectivityObservers) {
                [connectivityObserver zeeba:self.zeeba disconnectedStand:correspondingStand];
            }
            return;
        }
        ZBConnectionAttempt *correspondingConnetionAttempt = [self connectionAttemptForPeripheral:peripheral];
        if (correspondingConnetionAttempt) {
            NSDictionary *userInfo = error ? @{ NSUnderlyingErrorKey: error } : nil;
            [self completeConnectionAttempt:correspondingConnetionAttempt error:[ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeConnectionFailed userInfo:userInfo]];
        }
    });
}

#pragma mark - Accessor Overrides

- (NSHashTable *)weakConnectivityObservers {
    if (!_weakConnectivityObservers) {
        _weakConnectivityObservers = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    }
    return _weakConnectivityObservers;
}

- (NSMutableSet *)connectionAttempts {
    if (!_connectionAttempts) {
        _connectionAttempts = [NSMutableSet set];
    }
    return _connectionAttempts;
}

- (NSMutableSet *)internalConnectedStands {
    if (!_internalConnectedStands) {
        _internalConnectedStands = [NSMutableSet set];
    }
    return _internalConnectedStands;
}

@end
