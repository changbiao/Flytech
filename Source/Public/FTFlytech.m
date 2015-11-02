//
//  FTFlytech.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTFlytech.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "FTCentralManagerDelegateProxy.h"
#import "CBCentralManager+Factory.h"
#import "FTBLEAvailabilityAdapter.h"
#import "FTScanner.h"
#import "FTConnectionPool.h"

NSTimeInterval const FTTimeoutInfinity = -1;

@interface FTFlytech ()

@property (strong, nonatomic) FTBLEAvailabilityAdapter *availabilityAdapter;
@property (strong, nonatomic) FTScanner *scanner;
@property (strong, nonatomic) FTConnectionPool *connectionPool;
@property (strong, nonatomic) FTCentralManagerDelegateProxy *centralManagerDelegateProxy;
@property (strong, nonatomic) CBCentralManager *centralManager;

@end

@implementation FTFlytech

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManagerDelegateProxy = [[FTCentralManagerDelegateProxy alloc] initWithStateDelegate:self.availabilityAdapter restorationDelegate:nil discoveryDelegate:self.scanner connectionDelegate:self.connectionPool];
    }
    return self;
}

#pragma mark - Public Interface

- (NSSet<id<FTBLEAvailabilityObserver>> *)availabilityObservers {
    return self.availabilityAdapter.availabilityObservers;
}

- (FTBLEAvailability)availability {
    return [self.availabilityAdapter availabilityForCentralManagerState:self.centralManager.state];
}

- (NSSet<id<FTConnectivityObserver>> *)connectivityObservers {
    return self.connectionPool.connectivityObservers;
}

- (void)start {
    if (self.centralManager) {
        return;
    }
    self.centralManager = [CBCentralManager flytechCentralManagerWithDelegate:self.centralManagerDelegateProxy];
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

- (void)addAvailabilityObserver:(id<FTBLEAvailabilityObserver>)availabilityObserver {
    [self.availabilityAdapter addAvailabilityObserver:availabilityObserver];
}

- (void)removeAvailabilityObserver:(id<FTBLEAvailabilityObserver>)availabilityObserver {
    [self.availabilityAdapter removeAvailabilityObserver:availabilityObserver];
}

- (void)addConnectivityObserver:(id<FTConnectivityObserver>)connectivityObserver {
    [self.connectionPool addConnectivityObserver:connectivityObserver];
}

- (void)removeConnectivityObserver:(id<FTConnectivityObserver>)connectivityObserver {
    [self.connectionPool removeConnectivityObserver:connectivityObserver];
}

- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discoveryHandler:(FTDiscoveryHandler)discoveryHandler completionHandler:(FTDiscoveryCompletionHandler)completionHandler {
    [self.scanner discoverStandsWithTimeout:timeout discoveryHandler:discoveryHandler completionHandler:completionHandler];
}

- (void)stopDiscovery {
    [self.scanner stopDiscovery];
}

- (void)connectStand:(FTStand *)stand timeout:(NSTimeInterval)timeout completionHandler:(FTConnectCompletionHandler)completionHandler {
    [self.connectionPool connectStand:stand timeout:timeout completionHandler:completionHandler];
}

- (void)disconnectStand:(FTStand *)stand {
    [self.connectionPool disconnectStand:stand];
}

#pragma mark - Private Accessors

- (FTBLEAvailabilityAdapter *)availabilityAdapter {
    if (!_availabilityAdapter) {
        _availabilityAdapter = [[FTBLEAvailabilityAdapter alloc] initWithFlytech:self];
    }
    return _availabilityAdapter;
}

- (FTScanner *)scanner {
    if (!_scanner) {
        _scanner = [FTScanner new];
    }
    return _scanner;
}

- (FTConnectionPool *)connectionPool {
    if (!_connectionPool) {
        _connectionPool = [[FTConnectionPool alloc] initWithFlytech:self];
    }
    return _connectionPool;
}

@end
