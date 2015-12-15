//
//  CBPeripheral+ZBServices.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

extern NSString * const ZBServiceUUIDStringDeviceInformation;
extern NSString * const ZBServiceUUIDStringOverAirDownload;
extern NSString * const ZBServiceUUIDStringSerialPortOne;
extern NSString * const ZBServiceUUIDStringSerialPortTwo;
extern NSString * const ZBServiceUUIDStringSerialPortThree;
extern NSString * const ZBServiceUUIDStringConfiguration;
extern NSString * const ZBServiceUUIDStringCashDrawer;

@interface CBPeripheral (ZBServices)

+ (NSArray<CBUUID *> *)relevantServiceUUIDs;
- (CBService *)serviceWithUUIDString:(NSString *)UUIDString;

@end
