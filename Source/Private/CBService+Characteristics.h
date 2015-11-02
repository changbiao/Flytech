//
//  CBService+Characteristics.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

extern NSString * const FTCharacteristicUUIDStringSystemID;
extern NSString * const FTCharacteristicUUIDStringModelNumberString;
extern NSString * const FTCharacteristicUUIDStringSerialNumberString;
extern NSString * const FTCharacteristicUUIDStringFirmwareRevisionString;
extern NSString * const FTCharacteristicUUIDStringHardwareRevisionString;
extern NSString * const FTCharacteristicUUIDStringSoftwareRevisionString;
extern NSString * const FTCharacteristicUUIDStringManufacturerNameString;
extern NSString * const FTCharacteristicUUIDStringIEEERegulatoryCertification;
extern NSString * const FTCharacteristicUUIDStringPnPID;

extern NSString * const FTCharacteristicUUIDStringSerialPortOneTX;
extern NSString * const FTCharacteristicUUIDStringSerialPortOneRX;

extern NSString * const FTCharacteristicUUIDStringSerialPortTwoTX;
extern NSString * const FTCharacteristicUUIDStringSerialPortTwoRX;

extern NSString * const FTCharacteristicUUIDStringSerialPortThreeTX;
extern NSString * const FTCharacteristicUUIDStringSerialPortThreeRX;

extern NSString * const FTCharacteristicUUIDStringConfigurationCommandPort;
extern NSString * const FTCharacteristicUUIDStringConfigurationPortOne;
extern NSString * const FTCharacteristicUUIDStringConfigurationPortTwo;
extern NSString * const FTCharacteristicUUIDStringConfigurationPortThree;

extern NSString * const FTCharacteristicUUIDStringCashDrawerCommandPort;
extern NSString * const FTCharacteristicUUIDStringCashDrawerStatus;

@interface CBService (Characteristics)

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDs;
- (CBCharacteristic *)characteristicForUUIDString:(NSString *)UUIDString;

@end
