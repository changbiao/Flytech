//
//  FTScanner.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 19/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTScanner.h"
#import "FTErrorDomain+Factory.h"
#import "CBPeripheral+Services.h"
#import "FTStand+Private.h"

@interface FTScanner ()

@property (assign, nonatomic) BOOL busy;
@property (copy, nonatomic) FTDiscoveryHandler discoveryHandler;
@property (copy, nonatomic) FTDiscoveryCompletionHandler completionHandler;
@property (strong, nonatomic) NSMutableArray *discoveries;
@property (strong, nonatomic) NSTimer *timeoutTimer;

@end

@implementation FTScanner

#pragma mark - Public Interface

- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discoveryHandler:(FTDiscoveryHandler)discoveryHandler completionHandler:(FTDiscoveryCompletionHandler)completionHandler {
    if (self.busy) {
        completionHandler(nil, [FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodeAlreadyDiscovering]);
        return;
    }
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        completionHandler(nil, [FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodeBLEAvailability]);
        return;
    }
    self.busy = YES;
    self.discoveryHandler = discoveryHandler;
    self.completionHandler = completionHandler;
    self.discoveries = [NSMutableArray array];
    self.timeoutTimer = timeout == FTTimeoutInfinity ? nil : [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timeoutTimerElapsed:) userInfo:nil repeats:NO];
    NSDictionary *options = @{ CBCentralManagerScanOptionAllowDuplicatesKey: @NO };
    [self.centralManager scanForPeripheralsWithServices:@[ [CBUUID UUIDWithString:FTServiceUUIDStringSerialPortOne] ] options:options];
}

- (void)stopDiscovery {
    if (self.busy) {
        [self complete];
    }
}

#pragma mark - Target Actions

- (void)timeoutTimerElapsed:(NSTimer *)timer {
    [self complete];
}

#pragma mark - FTCentralManagerDiscoveryDelegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_main_queue(), ^{
        FTStand *discoveredStand = [[FTStand alloc] initWithPeripheral:peripheral];
        [self.discoveries addObject:discoveredStand];
        if (self.discoveryHandler) {
            self.discoveryHandler(discoveredStand);
        }
    });
}

#pragma mark - Internals

- (void)complete {
    [self.centralManager stopScan];
    FTDiscoveryCompletionHandler completionHandler = self.completionHandler;
    NSArray *discoveries = self.discoveries;
    [self reset];
    self.busy = NO;
    completionHandler(discoveries, nil);
}

- (void)reset {
    [self invalidateTimeoutTimer];
    self.discoveryHandler = nil;
    self.completionHandler = nil;
    self.discoveries = nil;
}

- (void)invalidateTimeoutTimer {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
}

@end
