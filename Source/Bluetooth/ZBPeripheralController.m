//
//  ZBPeripheralController.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPeripheralController.h"
#import "ZBErrorDomain+Factory.h"
#import "CBPeripheral+ZBServices.h"
#import "CBService+ZBCharacteristics.h"
#import "ZBSerialPortCommunicator.h"
#import "ZBSerialPortCommunicator+Private.h"
#import "ZBDebugging.h"

@interface ZBPeripheralController () <CBPeripheralDelegate>

@property (copy, nonatomic) ZBPeripheralControllerPrepareForUseCompletionHandler completionHandler;
@property (copy, nonatomic) NSString *modelNumber;
@property (copy, nonatomic) NSString *firmwareRevision;
@property (assign, nonatomic) BOOL serialPortOneReady;
@property (assign, nonatomic) BOOL serialPortTwoReady;
@property (assign, nonatomic) BOOL serialPortThreeReady;
@property (strong, nonatomic) ZBSerialPortCommunicator *serialPortCommunicator;

@end

@implementation ZBPeripheralController

#pragma mark - Public Interface

- (void)prepareForUseWithCompletion:(ZBPeripheralControllerPrepareForUseCompletionHandler)completion {
    self.completionHandler = completion;
    [self.peripheral discoverServices:[CBPeripheral relevantServiceUUIDs]];
}

#pragma mark - Internals

- (void)evaluateState {
    if (!self.completionHandler) {
        return;
    }
    if (self.modelNumber && self.firmwareRevision && self.serialPortOneReady && self.serialPortTwoReady && self.serialPortThreeReady) {
        self.serialPortCommunicator = [ZBSerialPortCommunicator new];
        self.serialPortCommunicator.peripheral = self.peripheral;
        [self completeWithError:nil];
    }
}

- (void)completeWithError:(NSError *)error {
    ZBPeripheralControllerPrepareForUseCompletionHandler completionHandler = self.completionHandler;
    self.completionHandler = nil;
    if (error) {
        self.modelNumber = nil;
        self.firmwareRevision = nil;
        self.serialPortCommunicator = nil;
        completionHandler(nil, nil, nil, error);
    } else {
        completionHandler(self.modelNumber, self.firmwareRevision, self.serialPortCommunicator, nil);
    }
}

#pragma mark - Utility

- (NSPredicate *)predicateForAttributeWithUUIDString:(NSString *)UUIDString {
    return [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:UUIDString]];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, Service: %@, Error: %@", peripheral, service, error);
    #ifdef ZBBLEDebugLoggingEnabled
    for (CBCharacteristic *characteristic in service.characteristics) {
        ZBBLELog(@"Characteristic: %@", characteristic);
    }
    #endif
    NSString *serviceUUIDString = service.UUID.UUIDString;
    if ([serviceUUIDString isEqualToString:ZBServiceUUIDStringDeviceInformation]) {
        [peripheral readValueForCharacteristic:[service characteristicForUUIDString:ZBCharacteristicUUIDStringModelNumberString]];
        [peripheral readValueForCharacteristic:[service characteristicForUUIDString:ZBCharacteristicUUIDStringFirmwareRevisionString]];
    } else if ([serviceUUIDString isEqualToString:ZBServiceUUIDStringSerialPortOne]) {
        [peripheral setNotifyValue:YES forCharacteristic:[service characteristicForUUIDString:ZBCharacteristicUUIDStringSerialPortOneTX]];
    } else if ([serviceUUIDString isEqualToString:ZBServiceUUIDStringSerialPortTwo]) {
        [peripheral setNotifyValue:YES forCharacteristic:[service characteristicForUUIDString:ZBCharacteristicUUIDStringSerialPortTwoTX]];
    } else if ([serviceUUIDString isEqualToString:ZBServiceUUIDStringSerialPortThree]) {
        [peripheral setNotifyValue:YES forCharacteristic:[service characteristicForUUIDString:ZBCharacteristicUUIDStringSerialPortThreeTX]];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, Characteristic: %@, Error: %@", peripheral, characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, Service: %@, Error: %@", peripheral, service, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, Error: %@", peripheral, error);
    for (CBService *service in peripheral.services) {
        ZBBLELog(@"Service: %@", service);
        NSArray *relevantCharacteristicUUIDs = [service relevantCharacteristicUUIDs];
        if (relevantCharacteristicUUIDs) {
            [peripheral discoverCharacteristics:relevantCharacteristicUUIDs forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    ZBBLELog(@"Peripheral: %@, Services: %@", peripheral, invalidatedServices);
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, RSSI: %@, Error: %@", peripheral, RSSI, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, Characteristic: %@, Error: %@", peripheral, characteristic, error);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *characteristicUUIDString = characteristic.UUID.UUIDString;
        if ([characteristicUUIDString isEqualToString:ZBCharacteristicUUIDStringSerialPortOneTX]) {
            self.serialPortOneReady = characteristic.isNotifying;
        } else if ([characteristicUUIDString isEqualToString:ZBCharacteristicUUIDStringSerialPortTwoTX]) {
            self.serialPortTwoReady = characteristic.isNotifying;
        } else if ([characteristicUUIDString isEqualToString:ZBCharacteristicUUIDStringSerialPortThreeTX]) {
            self.serialPortThreeReady = characteristic.isNotifying;
        }
        [self evaluateState];
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, Characteristic: %@, Error: %@", peripheral, characteristic, error);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *characteristicUUIDString = characteristic.UUID.UUIDString;
        if ([characteristicUUIDString isEqualToString:ZBCharacteristicUUIDStringModelNumberString]) {
            self.modelNumber = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
        } else if ([characteristicUUIDString isEqualToString:ZBCharacteristicUUIDStringFirmwareRevisionString]) {
            self.firmwareRevision = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
        } else if ([characteristic.service isSerialPortService]) {
            [self.serialPortCommunicator receiveData:characteristic.value forCharacteristic:characteristic];
        }
        [self evaluateState];
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, Descriptor: %@, Error: %@", peripheral, descriptor, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, Characteristic: %@, Error: %@", peripheral, characteristic, error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.serialPortCommunicator sendingDataCompletedForCharacteristic:characteristic error:error];
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    ZBBLELog(@"Peripheral: %@, Descriptor: %@, Error: %@", peripheral, descriptor, error);
}

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    ZBBLELog(@"Peripheral: %@", peripheral);
}

#pragma mark - Mutators

- (void)setPeripheral:(CBPeripheral *)peripheral {
    _peripheral = peripheral;
    if (_peripheral) {
        _peripheral.delegate = self;
    }
}

@end
