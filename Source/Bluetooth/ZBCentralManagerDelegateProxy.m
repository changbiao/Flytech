//
//  ZBCentralManagerDelegateProxy.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBCentralManagerDelegateProxy.h"
#import "ZBDebugging.h"

@implementation ZBCentralManagerDelegateProxy

#pragma mark - Life Cycle

- (instancetype)initWithStateDelegate:(id<ZBCentralManagerStateDelegate>)stateDelegate
                  restorationDelegate:(id<ZBCentralManagerRestorationDelegate>)restorationDelegate
                    discoveryDelegate:(id<ZBCentralManagerDiscoveryDelegate>)discoveryDelegate
                   connectionDelegate:(id<ZBCentralManagerConnectionDelegate>)connectionDelegate {
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
    ZBBLELog(@"Central: %@, State: %ld", central, central.state);
    if (self.stateDelegate) {
        [self.stateDelegate centralManagerDidUpdateState:central];
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    ZBBLELog(@"Central: %@, State: %@", central, dict);
    if (self.restorationDelegate) {
        [self.restorationDelegate centralManager:central willRestoreState:dict];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    ZBBLELog(@"Central: %@, Peripheral: %@, Advertisement data: %@, RSSI: %@", central, peripheral, advertisementData, RSSI);
    if (self.discoveryDelegate) {
        [self.discoveryDelegate centralManager:central didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    ZBBLELog(@"Central: %@, Peripheral: %@", central, peripheral);
    if (self.connectionDelegate) {
        [self.connectionDelegate centralManager:central didConnectPeripheral:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    ZBBLELog(@"Central: %@, Peripheral: %@, Error: %@", central, peripheral, error);
    if (self.connectionDelegate) {
        [self.connectionDelegate centralManager:central didFailToConnectPeripheral:peripheral error:error];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    ZBBLELog(@"Central: %@, Peripheral: %@, Error: %@", central, peripheral, error);
    if (self.connectionDelegate) {
        [self.connectionDelegate centralManager:central didDisconnectPeripheral:peripheral error:error];
    }
}

@end
