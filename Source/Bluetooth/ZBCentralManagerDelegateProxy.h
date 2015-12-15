//
//  ZBCentralManagerDelegateProxy.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZBCentralManagerStateDelegate <NSObject>

- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

@end

@protocol ZBCentralManagerRestorationDelegate <NSObject>

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict;

@end

@protocol ZBCentralManagerDiscoveryDelegate <NSObject>

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;

@end

@protocol ZBCentralManagerConnectionDelegate <NSObject>

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;

@end

@interface ZBCentralManagerDelegateProxy : NSObject <CBCentralManagerDelegate>

@property (nullable, weak, nonatomic) id<ZBCentralManagerStateDelegate> stateDelegate;
@property (nullable, weak, nonatomic) id<ZBCentralManagerRestorationDelegate> restorationDelegate;
@property (nullable, weak, nonatomic) id<ZBCentralManagerDiscoveryDelegate> discoveryDelegate;
@property (nullable, weak, nonatomic) id<ZBCentralManagerConnectionDelegate> connectionDelegate;

- (instancetype)initWithStateDelegate:(nullable id<ZBCentralManagerStateDelegate>)stateDelegate
                  restorationDelegate:(nullable id<ZBCentralManagerRestorationDelegate>)restorationDelegate
                    discoveryDelegate:(nullable id<ZBCentralManagerDiscoveryDelegate>)discoveryDelegate
                   connectionDelegate:(nullable id<ZBCentralManagerConnectionDelegate>)connectionDelegate;

@end

NS_ASSUME_NONNULL_END
