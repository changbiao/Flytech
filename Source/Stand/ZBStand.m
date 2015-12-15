//
//  ZBStand.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBStand.h"
#import "ZBStand+Private.h"
#import "ZBPeripheralController.h"
#import "ZBSerialPortCommunicator.h"
#import "ZBSerialPortConfiguration+Factory.h"
#import "ZBPrinter+Private.h"
#import "NSData+ZBHex.h"
#import "CBPeripheral+ZBServices.h"
#import "CBService+ZBCharacteristics.h"

@interface ZBStand ()

@property (copy, nonatomic) NSUUID *identifier;
@property (assign, nonatomic) ZBStandModel model;
@property (copy, nonatomic) NSString *firmwareRevision;
@property (strong, nonatomic) ZBPrinter *printer;

@end

@implementation ZBStand

#pragma mark - Life Cycle

- (instancetype)initWithIdentifier:(NSUUID *)identifier {
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}

#pragma mark - Public Interface

- (ZBConnectivity)connectivity {
    if (!self.peripheral) {
        return ZBConnectivityNone;
    }
    #if TARGET_OS_IPHONE
    switch (self.peripheral.state) {
        case CBPeripheralStateDisconnected: return ZBConnectivityDisconnected; break;
        case CBPeripheralStateConnected: return ZBConnectivityConnected; break;
        case CBPeripheralStateConnecting: return ZBConnectivityConnecting; break;
        case CBPeripheralStateDisconnecting: return ZBConnectivityDisconnecting; break;
    }
    #else
    switch (self.peripheral.state) {
        case CBPeripheralStateDisconnected: return ZBConnectivityDisconnected; break;
        case CBPeripheralStateConnected: return ZBConnectivityConnected; break;
        case CBPeripheralStateConnecting: return ZBConnectivityConnecting; break;
    }
    #endif
    
}

- (void)setTabletLock:(BOOL)lock completion:(ZBLockCompletionHandler)completion {
    NSMutableData *commandData = [NSMutableData dataWithHex:@"4010"];
    unsigned char targetByte = self.printer.portNumber;
    unsigned char lockByte = lock;
    [commandData appendBytes:&targetByte length:sizeof(targetByte)];
    [commandData appendBytes:&lockByte length:sizeof(lockByte)];
    [commandData appendHex:@"1310"];
    CBService *service = [self.peripheral serviceWithUUIDString:ZBServiceUUIDStringConfiguration];
    CBCharacteristic *characteristic = [service characteristicForUUIDString:ZBCharacteristicUUIDStringConfigurationCommandPort];
    [self.peripheral writeValue:commandData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    if (completion) {
        completion(nil);
    }
}

#pragma mark - Compare

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        ZBStand *otherStand = object;
        return [self.identifier isEqual:otherStand.identifier];
    }
    return [super isEqual:object];
}

@end
