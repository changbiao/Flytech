//
//  FTCentralManagerDelegateProxy.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTCentralManagerDelegateProxy.h"

@implementation FTCentralManagerDelegateProxy

#pragma mark - Life Cycle

- (instancetype)initWithStateDelegate:(id<FTCentralManagerStateDelegate>)stateDelegate
                  restorationDelegate:(id<FTCentralManagerRestorationDelegate>)restorationDelegate
                    discoveryDelegate:(id<FTCentralManagerDiscoveryDelegate>)discoveryDelegate
                   connectionDelegate:(id<FTCentralManagerConnectionDelegate>)connectionDelegate {
    self = [super init];
    if (self) {
        self.stateDelegate = stateDelegate;
        self.restorationDelegate = restorationDelegate;
        self.discoveryDelegate = discoveryDelegate;
        self.connectionDelegate = connectionDelegate;
    }
    return self;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (self.stateDelegate) {
        [self.stateDelegate centralManagerDidUpdateState:central];
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    if (self.restorationDelegate) {
        [self.restorationDelegate centralManager:central willRestoreState:dict];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if (self.discoveryDelegate) {
        [self.discoveryDelegate centralManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    if (self.connectionDelegate) {
        [self.connectionDelegate centralManager:central didConnectPeripheral:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    if (self.connectionDelegate) {
        [self.connectionDelegate centralManager:central didFailToConnectPeripheral:peripheral error:error];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    if (self.connectionDelegate) {
        [self.connectionDelegate centralManager:central didDisconnectPeripheral:peripheral error:error];
    }
}

@end
