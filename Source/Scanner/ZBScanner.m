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
@property (copy, nonatomic) ZBDiscoveryHandler discovery;
@property (copy, nonatomic) ZBDiscoveryCompletionHandler completion;
@property (strong, nonatomic) NSMutableArray *discoveries;
@property (strong, nonatomic) NSTimer *timeoutTimer;

@end

@implementation ZBScanner

#pragma mark - Public Interface

- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discovery:(ZBDiscoveryHandler)discovery completion:(ZBDiscoveryCompletionHandler)completion {
    if (self.busy) {
        completion(nil, [ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeAlreadyDiscovering]);
        return;
    }
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        completion(nil, [ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodeBLEAvailability]);
        return;
    }
    self.busy = YES;
    self.discovery = discovery;
    self.completion = completion;
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
        if (self.discovery) {
            self.discovery(discoveredStand);
        }
    });
}

#pragma mark - Internals

- (void)complete {
    [self.centralManager stopScan];
    ZBDiscoveryCompletionHandler completion = self.completion;
    NSArray *discoveries = self.discoveries;
    [self reset];
    self.busy = NO;
    completion(discoveries, nil);
}

- (void)reset {
    [self invalidateTimeoutTimer];
    self.discovery = nil;
    self.completion = nil;
    self.discoveries = nil;
}

- (void)invalidateTimeoutTimer {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
}

@end
