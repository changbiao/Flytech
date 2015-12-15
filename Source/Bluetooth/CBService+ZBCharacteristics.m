//
//  CBService+ZBCharacteristics.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "CBService+ZBCharacteristics.h"
#import "CBPeripheral+ZBServices.h"

NSString * const ZBCharacteristicUUIDStringUUIDStringSystemID = @"2A23";
NSString * const ZBCharacteristicUUIDStringModelNumberString = @"2A24";
NSString * const ZBCharacteristicUUIDStringSerialNumberString = @"2A25";
NSString * const ZBCharacteristicUUIDStringFirmwareRevisionString = @"2A26";
NSString * const ZBCharacteristicUUIDStringHardwareRevisionString = @"2A27";
NSString * const ZBCharacteristicUUIDStringSoZBwareRevisionString = @"2A28";
NSString * const ZBCharacteristicUUIDStringManufacturerNameString = @"2A29";
NSString * const ZBCharacteristicUUIDStringIEEERegulatoryCertification = @"2A2A";
NSString * const ZBCharacteristicUUIDStringPnPID = @"2A50";

NSString * const ZBCharacteristicUUIDStringSerialPortOneTX = @"EC01";
NSString * const ZBCharacteristicUUIDStringSerialPortOneRX = @"EC02";

NSString * const ZBCharacteristicUUIDStringSerialPortTwoTX = @"EC11";
NSString * const ZBCharacteristicUUIDStringSerialPortTwoRX = @"EC12";

NSString * const ZBCharacteristicUUIDStringSerialPortThreeTX = @"EC21";
NSString * const ZBCharacteristicUUIDStringSerialPortThreeRX = @"EC22";

NSString * const ZBCharacteristicUUIDStringConfigurationCommandPort = @"EC31";
NSString * const ZBCharacteristicUUIDStringConfigurationPortOne = @"EC32";
NSString * const ZBCharacteristicUUIDStringConfigurationPortTwo = @"EC33";
NSString * const ZBCharacteristicUUIDStringConfigurationPortThree = @"EC34";

NSString * const ZBCharacteristicUUIDStringCashDrawerCommandPort = @"EC41";
NSString * const ZBCharacteristicUUIDStringCashDrawerStatus = @"EC42";

@implementation CBService (ZBCharacteristics)

#pragma mark - Public Interface

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDs {
    NSString *UUIDString = self.UUID.UUIDString;
    if ([UUIDString isEqualToString:ZBServiceUUIDStringDeviceInformation]) {
        return [self relevantCharacteristicUUIDsForDeviceInformationService];
    } else if ([UUIDString isEqualToString:ZBServiceUUIDStringSerialPortOne]) {
        return [self relevantCharacteristicUUIDsForSerialPortOneService];
    } else if ([UUIDString isEqualToString:ZBServiceUUIDStringSerialPortTwo]) {
        return [self relevantCharacteristicUUIDsForSerialPortTwoService];
    } else if ([UUIDString isEqualToString:ZBServiceUUIDStringSerialPortThree]) {
        return [self relevantCharacteristicUUIDsForSerialPortThreeService];
    } else if ([UUIDString isEqualToString:ZBServiceUUIDStringConfiguration]) {
        return [self relevantCharacteristicUUIDsForConfigurationService];
    } else if ([UUIDString isEqualToString:ZBServiceUUIDStringCashDrawer]) {
        return [self relevantCharacteristicUUIDsForCashDrawerService];
    }
    return nil;
}

- (CBCharacteristic *)characteristicForUUIDString:(NSString *)UUIDString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:UUIDString]];
    return [[self.characteristics filteredArrayUsingPredicate:predicate] lastObject];
}

- (BOOL)isSerialPortService {
    NSString *UUIDString = self.UUID.UUIDString;
    return [UUIDString isEqualToString:ZBServiceUUIDStringConfiguration] || [UUIDString isEqualToString:ZBServiceUUIDStringSerialPortOne] || [UUIDString isEqualToString:ZBServiceUUIDStringSerialPortTwo] || [UUIDString isEqualToString:ZBServiceUUIDStringSerialPortThree];
}

#pragma mark - Internals

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForDeviceInformationService {
    return @[ [CBUUID UUIDWithString:ZBCharacteristicUUIDStringFirmwareRevisionString],
              [CBUUID UUIDWithString:ZBCharacteristicUUIDStringModelNumberString] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForSerialPortOneService {
    return @[ [CBUUID UUIDWithString:ZBCharacteristicUUIDStringSerialPortOneRX],
              [CBUUID UUIDWithString:ZBCharacteristicUUIDStringSerialPortOneTX] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForSerialPortTwoService {
    return @[ [CBUUID UUIDWithString:ZBCharacteristicUUIDStringSerialPortTwoRX],
              [CBUUID UUIDWithString:ZBCharacteristicUUIDStringSerialPortTwoTX] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForSerialPortThreeService {
    return @[ [CBUUID UUIDWithString:ZBCharacteristicUUIDStringSerialPortThreeRX],
              [CBUUID UUIDWithString:ZBCharacteristicUUIDStringSerialPortThreeTX] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForConfigurationService {
    return @[ [CBUUID UUIDWithString:ZBCharacteristicUUIDStringConfigurationCommandPort],
              [CBUUID UUIDWithString:ZBCharacteristicUUIDStringConfigurationPortOne],
              [CBUUID UUIDWithString:ZBCharacteristicUUIDStringConfigurationPortTwo],
              [CBUUID UUIDWithString:ZBCharacteristicUUIDStringConfigurationPortThree] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForCashDrawerService {
    return @[ [CBUUID UUIDWithString:ZBCharacteristicUUIDStringCashDrawerCommandPort],
              [CBUUID UUIDWithString:ZBCharacteristicUUIDStringCashDrawerStatus] ];
}

@end
