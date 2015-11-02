//
//  CBService+Characteristics.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "CBService+Characteristics.h"
#import "CBPeripheral+Services.h"

NSString * const FTCharacteristicUUIDStringUUIDStringSystemID = @"2A23";
NSString * const FTCharacteristicUUIDStringModelNumberString = @"2A24";
NSString * const FTCharacteristicUUIDStringSerialNumberString = @"2A25";
NSString * const FTCharacteristicUUIDStringFirmwareRevisionString = @"2A26";
NSString * const FTCharacteristicUUIDStringHardwareRevisionString = @"2A27";
NSString * const FTCharacteristicUUIDStringSoftwareRevisionString = @"2A28";
NSString * const FTCharacteristicUUIDStringManufacturerNameString = @"2A29";
NSString * const FTCharacteristicUUIDStringIEEERegulatoryCertification = @"2A2A";
NSString * const FTCharacteristicUUIDStringPnPID = @"2A50";

NSString * const FTCharacteristicUUIDStringSerialPortOneTX = @"EC01";
NSString * const FTCharacteristicUUIDStringSerialPortOneRX = @"EC02";

NSString * const FTCharacteristicUUIDStringSerialPortTwoTX = @"EC11";
NSString * const FTCharacteristicUUIDStringSerialPortTwoRX = @"EC12";

NSString * const FTCharacteristicUUIDStringSerialPortThreeTX = @"EC21";
NSString * const FTCharacteristicUUIDStringSerialPortThreeRX = @"EC22";

NSString * const FTCharacteristicUUIDStringConfigurationCommandPort = @"EC31";
NSString * const FTCharacteristicUUIDStringConfigurationPortOne = @"EC32";
NSString * const FTCharacteristicUUIDStringConfigurationPortTwo = @"EC33";
NSString * const FTCharacteristicUUIDStringConfigurationPortThree = @"EC34";

NSString * const FTCharacteristicUUIDStringCashDrawerCommandPort = @"EC41";
NSString * const FTCharacteristicUUIDStringCashDrawerStatus = @"EC42";

@implementation CBService (Characteristics)

#pragma mark - Public Interface

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDs {
    NSString *UUIDString = self.UUID.UUIDString;
    if ([UUIDString isEqualToString:FTServiceUUIDStringDeviceInformation]) {
        return [self relevantCharacteristicUUIDsForDeviceInformationService];
    } else if ([UUIDString isEqualToString:FTServiceUUIDStringSerialPortOne]) {
        return [self relevantCharacteristicUUIDsForSerialPortOneService];
    } else if ([UUIDString isEqualToString:FTServiceUUIDStringSerialPortTwo]) {
        return [self relevantCharacteristicUUIDsForSerialPortTwoService];
    } else if ([UUIDString isEqualToString:FTServiceUUIDStringSerialPortThree]) {
        return [self relevantCharacteristicUUIDsForSerialPortThreeService];
    } else if ([UUIDString isEqualToString:FTServiceUUIDStringConfiguration]) {
        return [self relevantCharacteristicUUIDsForConfigurationService];
    } else if ([UUIDString isEqualToString:FTServiceUUIDStringCashDrawer]) {
        return [self relevantCharacteristicUUIDsForCashDrawerService];
    }
    return nil;
}

- (CBCharacteristic *)characteristicForUUIDString:(NSString *)UUIDString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:UUIDString]];
    return [[self.characteristics filteredArrayUsingPredicate:predicate] lastObject];
}

#pragma mark - Internals

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForDeviceInformationService {
    return @[ [CBUUID UUIDWithString:FTCharacteristicUUIDStringFirmwareRevisionString],
              [CBUUID UUIDWithString:FTCharacteristicUUIDStringModelNumberString] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForSerialPortOneService {
    return @[ [CBUUID UUIDWithString:FTCharacteristicUUIDStringSerialPortOneRX],
              [CBUUID UUIDWithString:FTCharacteristicUUIDStringSerialPortOneTX] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForSerialPortTwoService {
    return @[ [CBUUID UUIDWithString:FTCharacteristicUUIDStringSerialPortTwoRX],
              [CBUUID UUIDWithString:FTCharacteristicUUIDStringSerialPortTwoTX] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForSerialPortThreeService {
    return @[ [CBUUID UUIDWithString:FTCharacteristicUUIDStringSerialPortThreeRX],
              [CBUUID UUIDWithString:FTCharacteristicUUIDStringSerialPortThreeTX] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForConfigurationService {
    return @[ [CBUUID UUIDWithString:FTCharacteristicUUIDStringConfigurationCommandPort],
              [CBUUID UUIDWithString:FTCharacteristicUUIDStringConfigurationPortOne],
              [CBUUID UUIDWithString:FTCharacteristicUUIDStringConfigurationPortTwo],
              [CBUUID UUIDWithString:FTCharacteristicUUIDStringConfigurationPortThree] ];
}

- (NSArray<CBUUID *> *)relevantCharacteristicUUIDsForCashDrawerService {
    return @[ [CBUUID UUIDWithString:FTCharacteristicUUIDStringCashDrawerCommandPort],
              [CBUUID UUIDWithString:FTCharacteristicUUIDStringCashDrawerStatus] ];
}

@end
