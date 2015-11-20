//
//  CBPeripheral+Services.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

extern NSString * const FTServiceUUIDStringDeviceInformation;
extern NSString * const FTServiceUUIDStringOverAirDownload;
extern NSString * const FTServiceUUIDStringSerialPortOne;
extern NSString * const FTServiceUUIDStringSerialPortTwo;
extern NSString * const FTServiceUUIDStringSerialPortThree;
extern NSString * const FTServiceUUIDStringConfiguration;
extern NSString * const FTServiceUUIDStringCashDrawer;

@interface CBPeripheral (Services)

+ (NSArray<CBUUID *> *)relevantServiceUUIDs;
- (CBService *)serviceWithUUIDString:(NSString *)UUIDString;

@end
