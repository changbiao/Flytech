//
//  CBPeripheral+ZBServices.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "CBPeripheral+ZBServices.h"

NSString * const ZBServiceUUIDStringDeviceInformation = @"180A";
NSString * const ZBServiceUUIDStringOverAirDownload = @"F000FFC0-0451-4000-B000-000000000000";
NSString * const ZBServiceUUIDStringSerialPortOne = @"EC00";
NSString * const ZBServiceUUIDStringSerialPortTwo = @"EC10";
NSString * const ZBServiceUUIDStringSerialPortThree = @"EC20";
NSString * const ZBServiceUUIDStringConfiguration = @"EC30";
NSString * const ZBServiceUUIDStringCashDrawer = @"EC40";

@implementation CBPeripheral (ZBServices)

#pragma mark - Public Interface

+ (NSArray<CBUUID *> *)relevantServiceUUIDs {
    return @[ [CBUUID UUIDWithString:ZBServiceUUIDStringDeviceInformation],
              [CBUUID UUIDWithString:ZBServiceUUIDStringSerialPortOne],
              [CBUUID UUIDWithString:ZBServiceUUIDStringSerialPortTwo],
              [CBUUID UUIDWithString:ZBServiceUUIDStringSerialPortThree],
              [CBUUID UUIDWithString:ZBServiceUUIDStringConfiguration],
              [CBUUID UUIDWithString:ZBServiceUUIDStringCashDrawer] ];
}

- (CBService *)serviceWithUUIDString:(NSString *)UUIDString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:UUIDString]];
    return [[self.services filteredArrayUsingPredicate:predicate] lastObject];
}

@end
