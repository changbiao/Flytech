//
//  ZBScanner.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 19/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBScanner.h"
#import "ZBErrorDomain+Factory.h"
#import "CBPeripheral+ZBServices.h"
#import "ZBStand+Private.h"

@interface ZBScanner ()

@property (assign, nonatomic) BOOL busy;
@property (copy, nonatomic) ZBDiscoveryHandler discoveryHandler;
@property (copy, nonatomic) ZBDiscoveryCompletionHandler completionHandler;
@property (strong, nonatomic) NSMutableArray *discoveries;
@property (strong, nonatomic) NSTimer *timeoutTimer;

@end

@implementation ZBScanner

#pragma mark - Public Interface

- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discoveryHandler:(ZBDiscoveryHandler)discoveryHandler completionHandler:(ZBDiscoveryCompletionHandler)completionHandler {
    if (self.busy) {
        completionHandler(nil, [ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeAlreadyDiscovering]);
        return;
    }
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        completionHandler(nil, [ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeBLEAvailability]);
        return;
    }
    self.busy = YES;
    self.discoveryHandler = discoveryHandler;
    self.completionHandler = completionHandler;
    self.discoveries = [NSMutableArray array];
    self.timeoutTimer = timeout == ZBTimeoutInfinity ? nil : [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timeoutTimerElapsed:) userInfo:nil repeats:NO];
    NSDictionary *options = @{ CBCentralManagerScanOptionAllowDuplicatesKey: @NO };
    [self.centralManager scanForPeripheralsWithServices:@[ [CBUUID UUIDWithString:ZBServiceUUIDStringSerialPortOne] ] options:options];
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

#pragma mark - ZBCentralManagerDiscoveryDelegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_main_queue(), ^{
        ZBStand *discoveredStand = [[ZBStand alloc] initWithPeripheral:peripheral];
        [self.discoveries addObject:discoveredStand];
        if (self.discoveryHandler) {
            self.discoveryHandler(discoveredStand);
        }
    });
}

#pragma mark - Internals

- (void)complete {
    [self.centralManager stopScan];
    ZBDiscoveryCompletionHandler completionHandler = self.completionHandler;
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
