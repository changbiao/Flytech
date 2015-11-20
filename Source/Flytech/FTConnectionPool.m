//
//  FTConnectionPool.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 19/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTConnectionPool.h"
#import "FTStand+Private.h"
#import "FTConnectionAttempt.h"
#import "FTErrorDomain+Factory.h"
#import "CBPeripheral+Services.h"

@interface FTConnectionPool ()

@property (weak, nonatomic) FTFlytech *flytech;
@property (strong, nonatomic) NSHashTable *weakConnectivityObservers;
@property (strong, nonatomic) NSMutableSet *connectionAttempts;
@property (strong, nonatomic) NSMutableSet *internalConnectedStands;

@end

@implementation FTConnectionPool

#pragma mark - Life Cycle

- (instancetype)init {
    [NSException raise:NSGenericException format:@"Disabled. Use +[[%@ alloc] %@] instead", NSStringFromClass([self class]), NSStringFromSelector(@selector(initWithFlytech:))];
    return nil;
}

- (instancetype)initWithFlytech:(FTFlytech *)flytech {
    self = [super init];
    if (self) {
        self.flytech = flytech;
    }
    return self;
}

#pragma mark - Public Interface

- (NSSet<id<FTConnectivityObserver>> *)connectivityObservers {
    return self.weakConnectivityObservers.setRepresentation;
}

- (NSSet<FTStand *> *)stands {
    return [[self.connectionAttempts valueForKey:NSStringFromSelector(@selector(stand))] setByAddingObjectsFromSet:self.internalConnectedStands];
}

- (NSSet<FTStand *> *)connectedStands {
    return self.internalConnectedStands.copy;
}

- (void)addConnectivityObserver:(id<FTConnectivityObserver>)connectivityObserver {
    [self.weakConnectivityObservers addObject:connectivityObserver];
}

- (void)removeConnectivityObserver:(id<FTConnectivityObserver>)connectivityObserver {
    [self.weakConnectivityObservers removeObject:connectivityObserver];
}

- (void)connectStand:(FTStand *)stand timeout:(NSTimeInterval)timeout completionHandler:(FTConnectCompletionHandler)completionHandler {
    NSPredicate *connectionAttemptPredicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(stand)), stand];
    NSSet *existingConnectionAttempts = [self.connectionAttempts filteredSetUsingPredicate:connectionAttemptPredicate];
    if (existingConnectionAttempts.count) {
        completionHandler(stand, [FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodeAlreadyConnecting]);
        return;
    }
    if ([self.internalConnectedStands containsObject:stand]) {
        NSPredicate *connectedStandPredicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(identifier)), stand.identifier];
        FTStand *connectedStand = [[self.internalConnectedStands filteredSetUsingPredicate:connectedStandPredicate] anyObject];
        completionHandler(connectedStand, nil);
        return;
    }
    NSTimer *timeoutTimer = timeout == FTTimeoutInfinity ? nil : [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timeoutTimerElapsed:) userInfo:nil repeats:NO];
    FTConnectionAttempt *connectionAttempt = [[FTConnectionAttempt alloc] initWithStand:stand timeoutTimer:timeoutTimer completionHandler:completionHandler];
    [self processConnectionAttempt:connectionAttempt];
}

- (void)disconnectStand:(FTStand *)stand {
    if (stand.peripheral) {
        [self.centralManager cancelPeripheralConnection:stand.peripheral];
        return;
    }
    FTConnectionAttempt *connectionAttempt = [self connectionAttemptForStand:stand];
    [self completeConnectionAttempt:connectionAttempt error:[FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodeConnectionInterrupted]];
}

#pragma mark - Internals

- (void)processConnectionAttempt:(FTConnectionAttempt *)connectionAttempt {
    [self.connectionAttempts addObject:connectionAttempt];
    NSDictionary *connectionOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey: @NO, CBConnectPeripheralOptionNotifyOnDisconnectionKey: @NO, CBConnectPeripheralOptionNotifyOnNotificationKey: @NO };
    if (connectionAttempt.stand.peripheral) {
        [self.centralManager connectPeripheral:connectionAttempt.stand.peripheral options:connectionOptions];
        return;
    }
    NSArray *knownPeripherals = [self.centralManager retrievePeripheralsWithIdentifiers:@[ connectionAttempt.stand.identifier ]];
    if (knownPeripherals.count) {
        [self.centralManager connectPeripheral:knownPeripherals.firstObject options:connectionOptions];
        return;
    }
    NSArray *connectedPeripherals = [self.centralManager retrieveConnectedPeripheralsWithServices:@[ [CBUUID UUIDWithString:FTServiceUUIDStringSerialPortOne] ]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(identifier)), connectionAttempt.stand.identifier];
    CBPeripheral *peripheral = [[connectedPeripherals filteredArrayUsingPredicate:predicate] firstObject];
    if (peripheral) {
        [self.centralManager connectPeripheral:peripheral options:connectionOptions];
        return;
    }
    [self completeConnectionAttempt:connectionAttempt error:[FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodeUndefined]];
}

- (void)openCommunicationChannelForConnectionAttempt:(FTConnectionAttempt *)connectionAttempt {
    [connectionAttempt.stand prepareForUseWithCompletion:^(NSError *error) {
        if (error) {
            [self completeConnectionAttempt:connectionAttempt error:[FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodeConnectionFailed]];
            return;
        }
        [self completeConnectionAttempt:connectionAttempt error:nil];
    }];
}

- (void)completeConnectionAttempt:(FTConnectionAttempt *)connectionAttempt error:(NSError *)error {
    [connectionAttempt.timeoutTimer invalidate];
    FTStand *stand = connectionAttempt.stand;
    FTConnectCompletionHandler completionHandler = connectionAttempt.completionHandler;
    [self.connectionAttempts removeObject:connectionAttempt];
    if (!error) {
        [self.internalConnectedStands addObject:stand];
    }
    completionHandler(stand, error);
}

- (FTConnectionAttempt *)connectionAttemptForTimeoutTimer:(NSTimer *)timeoutTimer {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(timeoutTimer)), timeoutTimer];
    return [[self.connectionAttempts filteredSetUsingPredicate:predicate] anyObject];
}

- (FTConnectionAttempt *)connectionAttemptForPeripheral:(CBPeripheral *)peripheral {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K.%K == %@", NSStringFromSelector(@selector(stand)), NSStringFromSelector(@selector(identifier)), peripheral.identifier];
    return [[self.connectionAttempts filteredSetUsingPredicate:predicate] anyObject];
}

- (FTConnectionAttempt *)connectionAttemptForStand:(FTStand *)stand {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(stand)), stand];
    return [[self.connectionAttempts filteredSetUsingPredicate:predicate] anyObject];
}

- (FTStand *)connectedStandForPeripheral:(CBPeripheral *)peripheral {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(identifier)), peripheral.identifier];
    return [[self.internalConnectedStands filteredSetUsingPredicate:predicate] anyObject];
}

#pragma mark - Target Actions

- (void)timeoutTimerElapsed:(NSTimer *)timer {
    [self completeConnectionAttempt:[self connectionAttemptForTimeoutTimer:timer] error:[FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodeConnectionTimedOut]];
}

#pragma mark - FTCentralManagerDelegateProxy

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    dispatch_async(dispatch_get_main_queue(), ^{
        FTConnectionAttempt *connectionAttempt = [self connectionAttemptForPeripheral:peripheral];
        [connectionAttempt.timeoutTimer invalidate];
        connectionAttempt.stand.peripheral = peripheral;
        [self openCommunicationChannelForConnectionAttempt:connectionAttempt];
    });
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        FTConnectionAttempt *connectionAttempt = [self connectionAttemptForPeripheral:peripheral];
        connectionAttempt.stand.peripheral = peripheral;
        [self completeConnectionAttempt:connectionAttempt error:[FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodeConnectionFailed userInfo:@{ NSUnderlyingErrorKey: error }]];
    });
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        FTStand *correspondingStand = [self connectedStandForPeripheral:peripheral];
        if (correspondingStand) {
            [self.internalConnectedStands removeObject:correspondingStand];
            for (id<FTConnectivityObserver> connectivityObserver in self.connectivityObservers) {
                [connectivityObserver flytech:self.flytech disconnectedStand:correspondingStand];
            }
            return;
        }
        FTConnectionAttempt *correspondingConnetionAttempt = [self connectionAttemptForPeripheral:peripheral];
        if (correspondingConnetionAttempt) {
            NSDictionary *userInfo = error ? @{ NSUnderlyingErrorKey: error } : nil;
            [self completeConnectionAttempt:correspondingConnetionAttempt error:[FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodeConnectionFailed userInfo:userInfo]];
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
