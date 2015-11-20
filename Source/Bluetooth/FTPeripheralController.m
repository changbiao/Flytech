//
//  FTPeripheralController.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPeripheralController.h"
#import "FTErrorDomain+Factory.h"
#import "CBPeripheral+Services.h"
#import "CBService+Characteristics.h"
#import "FTSerialPortCommunicator.h"
#import "FTSerialPortCommunicator+Private.h"
#import "FTDebugging.h"

@interface FTPeripheralController () <CBPeripheralDelegate>

@property (copy, nonatomic) FTPeripheralControllerPrepareForUseCompletionHandler completionHandler;
@property (copy, nonatomic) NSString *modelNumber;
@property (copy, nonatomic) NSString *firmwareRevision;
@property (assign, nonatomic) BOOL serialPortOneReady;
@property (assign, nonatomic) BOOL serialPortTwoReady;
@property (assign, nonatomic) BOOL serialPortThreeReady;
@property (strong, nonatomic) FTSerialPortCommunicator *serialPortCommunicator;

@end

@implementation FTPeripheralController

#pragma mark - Public Interface

- (void)prepareForUseWithCompletion:(FTPeripheralControllerPrepareForUseCompletionHandler)completion {
    self.completionHandler = completion;
    [self.peripheral discoverServices:[CBPeripheral relevantServiceUUIDs]];
}

#pragma mark - Internals

- (void)evaluateState {
    if (!self.completionHandler) {
        return;
    }
    if (self.modelNumber && self.firmwareRevision && self.serialPortOneReady && self.serialPortTwoReady && self.serialPortThreeReady) {
        self.serialPortCommunicator = [FTSerialPortCommunicator new];
        self.serialPortCommunicator.peripheral = self.peripheral;
        [self completeWithError:nil];
    }
}

- (void)completeWithError:(NSError *)error {
    FTPeripheralControllerPrepareForUseCompletionHandler completionHandler = self.completionHandler;
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
    FTBLELog(@"Peripheral: %@, Service: %@, Error: %@", peripheral, service, error);
    for (CBCharacteristic *characteristic in service.characteristics) {
        FTBLELog(@"Characteristic: %@", characteristic);
    }
    NSString *serviceUUIDString = service.UUID.UUIDString;
    if ([serviceUUIDString isEqualToString:FTServiceUUIDStringDeviceInformation]) {
        [peripheral readValueForCharacteristic:[service characteristicForUUIDString:FTCharacteristicUUIDStringModelNumberString]];
        [peripheral readValueForCharacteristic:[service characteristicForUUIDString:FTCharacteristicUUIDStringFirmwareRevisionString]];
    } else if ([serviceUUIDString isEqualToString:FTServiceUUIDStringSerialPortOne]) {
        [peripheral setNotifyValue:YES forCharacteristic:[service characteristicForUUIDString:FTCharacteristicUUIDStringSerialPortOneTX]];
    } else if ([serviceUUIDString isEqualToString:FTServiceUUIDStringSerialPortTwo]) {
        [peripheral setNotifyValue:YES forCharacteristic:[service characteristicForUUIDString:FTCharacteristicUUIDStringSerialPortTwoTX]];
    } else if ([serviceUUIDString isEqualToString:FTServiceUUIDStringSerialPortThree]) {
        [peripheral setNotifyValue:YES forCharacteristic:[service characteristicForUUIDString:FTCharacteristicUUIDStringSerialPortThreeTX]];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    FTBLELog(@"Peripheral: %@, Characteristic: %@, Error: %@", peripheral, characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
    FTBLELog(@"Peripheral: %@, Service: %@, Error: %@", peripheral, service, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    FTBLELog(@"Peripheral: %@, Error: %@", peripheral, error);
    for (CBService *service in peripheral.services) {
        FTBLELog(@"Service: %@", service);
        NSArray *relevantCharacteristicUUIDs = [service relevantCharacteristicUUIDs];
        if (relevantCharacteristicUUIDs) {
            [peripheral discoverCharacteristics:relevantCharacteristicUUIDs forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    FTBLELog(@"Peripheral: %@, Services: %@", peripheral, invalidatedServices);
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    FTBLELog(@"Peripheral: %@, RSSI: %@, Error: %@", peripheral, RSSI, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    FTBLELog(@"Peripheral: %@, Characteristic: %@, Error: %@", peripheral, characteristic, error);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *characteristicUUIDString = characteristic.UUID.UUIDString;
        if ([characteristicUUIDString isEqualToString:FTCharacteristicUUIDStringSerialPortOneTX]) {
            self.serialPortOneReady = characteristic.isNotifying;
        } else if ([characteristicUUIDString isEqualToString:FTCharacteristicUUIDStringSerialPortTwoTX]) {
            self.serialPortTwoReady = characteristic.isNotifying;
        } else if ([characteristicUUIDString isEqualToString:FTCharacteristicUUIDStringSerialPortThreeTX]) {
            self.serialPortThreeReady = characteristic.isNotifying;
        }
        [self evaluateState];
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    FTBLELog(@"Peripheral: %@, Characteristic: %@, Error: %@", peripheral, characteristic, error);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *characteristicUUIDString = characteristic.UUID.UUIDString;
        if ([characteristicUUIDString isEqualToString:FTCharacteristicUUIDStringModelNumberString]) {
            self.modelNumber = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
        } else if ([characteristicUUIDString isEqualToString:FTCharacteristicUUIDStringFirmwareRevisionString]) {
            self.firmwareRevision = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
        } else if ([characteristic.service isSerialPortService]) {
            [self.serialPortCommunicator receiveData:characteristic.value forCharacteristic:characteristic];
        }
        [self evaluateState];
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    FTBLELog(@"Peripheral: %@, Descriptor: %@, Error: %@", peripheral, descriptor, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    FTBLELog(@"Peripheral: %@, Characteristic: %@, Error: %@", peripheral, characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    FTBLELog(@"Peripheral: %@, Descriptor: %@, Error: %@", peripheral, descriptor, error);
}

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    FTBLELog(@"Peripheral: %@", peripheral);
}

#pragma mark - Mutators

- (void)setPeripheral:(CBPeripheral *)peripheral {
    _peripheral = peripheral;
    if (_peripheral) {
        _peripheral.delegate = self;
    }
}

@end
