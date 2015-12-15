//
//  ZBZeeba.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBZeeba.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZBCentralManagerDelegateProxy.h"
#import "CBCentralManager+ZBFactory.h"
#import "ZBBLEAvailabilityAdapter.h"
#import "ZBScanner.h"
#import "ZBConnectionPool.h"

NSTimeInterval const ZBTimeoutInfinity = -1;

@interface ZBZeeba ()

@property (strong, nonatomic) ZBBLEAvailabilityAdapter *availabilityAdapter;
@property (strong, nonatomic) ZBScanner *scanner;
@property (strong, nonatomic) ZBConnectionPool *connectionPool;
@property (strong, nonatomic) ZBCentralManagerDelegateProxy *centralManagerDelegateProxy;
@property (strong, nonatomic) CBCentralManager *centralManager;

@end

@implementation ZBZeeba

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManagerDelegateProxy = [[ZBCentralManagerDelegateProxy alloc] initWithStateDelegate:self.availabilityAdapter restorationDelegate:nil discoveryDelegate:self.scanner connectionDelegate:self.connectionPool];
    }
    return self;
}

#pragma mark - Public Interface

- (NSSet<id<ZBBLEAvailabilityObserver>> *)availabilityObservers {
    return self.availabilityAdapter.availabilityObservers;
}

- (ZBBLEAvailability)availability {
    return [self.availabilityAdapter availabilityForCentralManagerState:self.centralManager.state];
}

- (NSSet<id<ZBConnectivityObserver>> *)connectivityObservers {
    return self.connectionPool.connectivityObservers;
}

- (void)start {
    if (self.centralManager) {
        return;
    }
    self.centralManager = [CBCentralManager zeebaCentralManagerWithDelegate:self.centralManagerDelegateProxy];
    self.scanner.centralManager = self.centralManager;
    self.connectionPool.centralManager = self.centralManager;
}

- (void)stop {
    if (!self.centralManager) {
        return;
    }
    [self.scanner stopDiscovery];
    self.centralManager = nil;
    self.centralManagerDelegateProxy = nil;
}

- (void)addAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver {
    [self.availabilityAdapter addAvailabilityObserver:availabilityObserver];
}

- (void)removeAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver {
    [self.availabilityAdapter removeAvailabilityObserver:availabilityObserver];
}

- (void)addConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver {
    [self.connectionPool addConnectivityObserver:connectivityObserver];
}

- (void)removeConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver {
    [self.connectionPool removeConnectivityObserver:connectivityObserver];
}

- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discoveryHandler:(ZBDiscoveryHandler)discoveryHandler completionHandler:(ZBDiscoveryCompletionHandler)completionHandler {
    [self.scanner discoverStandsWithTimeout:timeout discoveryHandler:discoveryHandler completionHandler:completionHandler];
}

- (void)stopDiscovery {
    [self.scanner stopDiscovery];
}

- (void)connectStand:(ZBStand *)stand timeout:(NSTimeInterval)timeout completionHandler:(ZBConnectCompletionHandler)completionHandler {
    [self.connectionPool connectStand:stand timeout:timeout completionHandler:completionHandler];
}

- (void)disconnectStand:(ZBStand *)stand {
    [self.connectionPool disconnectStand:stand];
}

#pragma mark - Private Accessors

- (ZBBLEAvailabilityAdapter *)availabilityAdapter {
    if (!_availabilityAdapter) {
        _availabilityAdapter = [[ZBBLEAvailabilityAdapter alloc] initWithZeeba:self];
    }
    return _availabilityAdapter;
}

- (ZBScanner *)scanner {
    if (!_scanner) {
        _scanner = [ZBScanner new];
    }
    return _scanner;
}

- (ZBConnectionPool *)connectionPool {
    if (!_connectionPool) {
        _connectionPool = [[ZBConnectionPool alloc] initWithZeeba:self];
    }
    return _connectionPool;
}

@end
