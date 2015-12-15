//
//  CBService+ZBCharacteristics.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

extern NSString * const ZBCharacteristicUUIDStringSystemID;
extern NSString * const ZBCharacteristicUUIDStringModelNumberString;
extern NSString * const ZBCharacteristicUUIDStringSerialNumberString;
extern NSString * const ZBCharacteristicUUIDStringFirmwareRevisionString;
extern NSString * const ZBCharacteristicUUIDStringHardwareRevisionString;
extern NSString * const ZBCharacteristicUUIDStringSoZBwareRevisionString;
extern NSString * const ZBCharacteristicUUIDStringManufacturerNameString;
extern NSString * const ZBCharacteristicUUIDStringIEEERegulatoryCertification;
extern NSString * const ZBCharacteristicUUIDStringPnPID;

extern NSString * const ZBCharacteristicUUIDStringSerialPortOneTX;
extern NSString * const ZBCharacteristicUUIDStringSerialPortOneRX;

extern NSString * const ZBCharacteristicUUIDStringSerialPortTwoTX;
extern NSString * const ZBCharacteristicUUIDStringSerialPortTwoRX;

extern NSString * const ZBCharacteristicUUIDStringSerialPortThreeTX;
extern NSString * const ZBCharacteristicUUIDStringSerialPortThreeRX;

extern NSString * const ZBCharacteristicUUIDStringConfigurationCommandPort;
extern NSString * const ZBCharacteristicUUIDStringConfigurationPortOne;
extern NSString * const ZBCharacteristicUUIDStringConfigurationPortTwo;
extern NSString * const ZBCharacteristicUUIDStringConfigurationPortThree;

extern NSString * const ZBCharacteristicUUIDStringCashDrawerCommandPort;
extern NSString * const ZBCharacteristicUUIDStringCashDrawerStatus;

@interface CBService (ZBCharacteristics)

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDs;
- (CBCharacteristic *)characteristicForUUIDString:(NSString *)UUIDString;
- (BOOL)isSerialPortService;

@end
