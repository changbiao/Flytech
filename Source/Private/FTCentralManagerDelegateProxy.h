//
//  FTCentralManagerDelegateProxy.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FTCentralManagerStateDelegate <NSObject>

- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

@end

@protocol FTCentralManagerRestorationDelegate <NSObject>

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict;

@end

@protocol FTCentralManagerDiscoveryDelegate <NSObject>

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;

@end

@protocol FTCentralManagerConnectionDelegate <NSObject>

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error;

@end

@interface FTCentralManagerDelegateProxy : NSObject <CBCentralManagerDelegate>

@property (nullable, weak, nonatomic) id<FTCentralManagerStateDelegate> stateDelegate;
@property (nullable, weak, nonatomic) id<FTCentralManagerRestorationDelegate> restorationDelegate;
@property (nullable, weak, nonatomic) id<FTCentralManagerDiscoveryDelegate> discoveryDelegate;
@property (nullable, weak, nonatomic) id<FTCentralManagerConnectionDelegate> connectionDelegate;

- (instancetype)initWithStateDelegate:(nullable id<FTCentralManagerStateDelegate>)stateDelegate
                  restorationDelegate:(nullable id<FTCentralManagerRestorationDelegate>)restorationDelegate
                    discoveryDelegate:(nullable id<FTCentralManagerDiscoveryDelegate>)discoveryDelegate
                   connectionDelegate:(nullable id<FTCentralManagerConnectionDelegate>)connectionDelegate;

@end

NS_ASSUME_NONNULL_END
