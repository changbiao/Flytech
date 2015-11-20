//
//  CBPeripheral+Services.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "CBPeripheral+Services.h"

NSString * const FTServiceUUIDStringDeviceInformation = @"180A";
NSString * const FTServiceUUIDStringOverAirDownload = @"F000FFC0-0451-4000-B000-000000000000";
NSString * const FTServiceUUIDStringSerialPortOne = @"EC00";
NSString * const FTServiceUUIDStringSerialPortTwo = @"EC10";
NSString * const FTServiceUUIDStringSerialPortThree = @"EC20";
NSString * const FTServiceUUIDStringConfiguration = @"EC30";
NSString * const FTServiceUUIDStringCashDrawer = @"EC40";

@implementation CBPeripheral (Services)

#pragma mark - Public Interface

+ (NSArray<CBUUID *> *)relevantServiceUUIDs {
    return @[ [CBUUID UUIDWithString:FTServiceUUIDStringDeviceInformation],
              [CBUUID UUIDWithString:FTServiceUUIDStringSerialPortOne],
              [CBUUID UUIDWithString:FTServiceUUIDStringSerialPortTwo],
              [CBUUID UUIDWithString:FTServiceUUIDStringSerialPortThree],
              [CBUUID UUIDWithString:FTServiceUUIDStringConfiguration],
              [CBUUID UUIDWithString:FTServiceUUIDStringCashDrawer] ];
}

- (CBService *)serviceWithUUIDString:(NSString *)UUIDString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:UUIDString]];
    return [[self.services filteredArrayUsingPredicate:predicate] lastObject];
}

@end
