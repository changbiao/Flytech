//
//  ZBSerialPortCommunicator.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 27/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBSerialPortCommunicator.h"
#import "ZBSerialPortCommunicator+Private.h"
#import "CBPeripheral+ZBServices.h"
#import "CBService+ZBCharacteristics.h"
#import "ZBSerialPortCommunicatorTask.h"
#import "ZBSerialPortCommunicator+Private.h"
#import "ZBErrorDomain+Factory.h"
#import "ZBDebugging.h"

@interface ZBSerialPortCommunicator ()

@property (strong, nonatomic) NSHashTable *weakObservers;

@end

@implementation ZBSerialPortCommunicator

#pragma mark - Public Interface

- (NSSet<id<ZBSerialPortCommunicatorObserver>> *)observers {
    return self.weakObservers.setRepresentation;
}

- (void)addObserver:(id<ZBSerialPortCommunicatorObserver>)observer {
    [self.weakObservers addObject:observer];
}

- (void)removeObserver:(id<ZBSerialPortCommunicatorObserver>)observer {
    [self.weakObservers removeObject:observer];
}

- (void)configurationForPortNumber:(ZBSerialPortNumber)portNumber completion:(void(^)(ZBSerialPortConfiguration *configuration, NSError *error))completion {
    [self addTask:[ZBSerialPortCommunicatorTask getConfigurationTaskWithPortNumber:portNumber completion:completion]];
}

- (void)applyConfiguration:(ZBSerialPortConfiguration *)configuration toPortNumber:(ZBSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion {
    ZBLog(@"Configuration: %@, Port number: %ld", configuration, (unsigned long)portNumber);
    [self addTask:[ZBSerialPortCommunicatorTask setConfigurationTaskWithPortNumber:portNumber configuration:configuration completion:completion]];
}

- (void)sendData:(NSData *)data toPortNumber:(ZBSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion {
    ZBLog(@"Data (%ld bytes): %@, Port number: %ld", (unsigned long)data.length, data, (unsigned long)portNumber);
    [self addTask:[ZBSerialPortCommunicatorTask sendDataTaskWithPortNumber:portNumber data:data completion:completion]];
}

- (void)sendDataEnsured:(NSData *)data toPortNumber:(ZBSerialPortNumber)portNumber completion:(void (^)(NSError *))completion {
    ZBLog(@"Data (%ld bytes): %@, Port number: %ld", (unsigned long)data.length, data, (unsigned long)portNumber);
    [self addTask:[ZBSerialPortCommunicatorTask sendDataEnsuredTaskWithPortNumber:portNumber data:data completion:completion]];
}

#pragma mark - Internals

- (void)addTask:(ZBSerialPortCommunicatorTask *)task {
    [self.tasks addObject:task];
    if (self.tasks.count == 1) {
        [self processTask:task];
    }
}

- (void)processTask:(ZBSerialPortCommunicatorTask *)task {
    switch (task.type) {
        case ZBSerialPortCommunicatorTaskTypeGetConfiguration: [self processGetConfigurationTask:task]; break;
        case ZBSerialPortCommunicatorTaskTypeSetConfiguration: [self processSetConfigurationTask:task]; break;
        case ZBSerialPortCommunicatorTaskTypeSendData: [self processSendDataTask:task]; break;
        case ZBSerialPortCommunicatorTaskTypeSendDataEnsured: [self processSendDataEnsuredTask:task]; break;
    }
}

- (void)processGetConfigurationTask:(ZBSerialPortCommunicatorTask *)task {
    CBService *configurationService = [self.peripheral serviceWithUUIDString:ZBServiceUUIDStringConfiguration];
    CBCharacteristic *characteristic;
    switch (task.portNumber) {
        case ZBSerialPortNumberOne: characteristic = [configurationService characteristicForUUIDString:ZBCharacteristicUUIDStringConfigurationPortOne]; break;
        case ZBSerialPortNumberTwo: characteristic = [configurationService characteristicForUUIDString:ZBCharacteristicUUIDStringConfigurationPortTwo]; break;
        case ZBSerialPortNumberThree: characteristic = [configurationService characteristicForUUIDString:ZBCharacteristicUUIDStringConfigurationPortThree]; break;
    }
    [self.peripheral readValueForCharacteristic:characteristic];
}

- (void)processSetConfigurationTask:(ZBSerialPortCommunicatorTask *)task {
    CBService *configurationService = [self.peripheral serviceWithUUIDString:ZBServiceUUIDStringConfiguration];
    CBCharacteristic *characteristic = [configurationService characteristicForUUIDString:ZBCharacteristicUUIDStringConfigurationCommandPort];
    NSData *baudRateCommand = [self commandForSettingBaudRate:task.configuration.baudRate onPortNumber:task.portNumber];
    [self.peripheral writeValue:baudRateCommand forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    NSData *parityCommand = [self commandForSettingParity:task.configuration.parity onPortNumber:task.portNumber];
    [self.peripheral writeValue:parityCommand forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    NSData *dataBitsCommand = [self commandForSettingDataBits:task.configuration.dataBits onPortNumber:task.portNumber];
    [self.peripheral writeValue:dataBitsCommand forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    NSData *stopBitsCommand = [self commandForSettingStopBits:task.configuration.stopBits onPortNumber:task.portNumber];
    [self.peripheral writeValue:stopBitsCommand forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    NSData *flowControlledCommand = [self commandForSettingFlowControlled:task.configuration.flowControlled onPortNumber:task.portNumber];
    [self.peripheral writeValue:flowControlledCommand forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    if (task.portNumber != ZBSerialPortNumberThree) {
        NSData *poweredCommand = [self commandForSettingPowered:task.configuration.powered onPortNumber:task.portNumber];
        [self.peripheral writeValue:poweredCommand forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    NSData *saveConfigurationCommand = [self commandForSavingConfiguration];
    [self.peripheral writeValue:saveConfigurationCommand forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    [self completeCurrentSetConfigurationTask];
}

- (void)completeCurrentSetConfigurationTask {
    void(^completion)(NSError *error) = self.tasks.firstObject.completion;
    [self completeCurrentTask];
    completion(nil);
}

- (NSData *)commandForSettingBaudRate:(ZBSerialPortBaudRate)baudRate onPortNumber:(ZBSerialPortNumber)portNumber {
    unsigned char commandByte = 0x01;
    unsigned char targetByte = portNumber;
    unsigned char valueByte = baudRate;
    unsigned char command[] = { 0x40, commandByte, targetByte, valueByte, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingParity:(ZBSerialPortParity)parity onPortNumber:(ZBSerialPortNumber)portNumber {
    unsigned char commandByte = 0x02;
    unsigned char targetByte = portNumber;
    unsigned char value = parity;
    unsigned char command[] = { 0x40, commandByte, targetByte, value, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingDataBits:(ZBSerialPortDataBits)dataBits onPortNumber:(ZBSerialPortNumber)portNumber {
    unsigned char commandByte = 0x03;
    unsigned char targetByte = portNumber;
    unsigned char value = dataBits;
    unsigned char command[] = { 0x40, commandByte, targetByte, value, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingStopBits:(ZBSerialPortStopBits)stopBits onPortNumber:(ZBSerialPortNumber)portNumber {
    unsigned char commandByte = 0x04;
    unsigned char targetByte = portNumber;
    unsigned char value = stopBits;
    unsigned char command[] = { 0x40, commandByte, targetByte, value, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingFlowControlled:(BOOL)flowControlled onPortNumber:(ZBSerialPortNumber)portNumber {
    unsigned char commandByte = 0x05;
    unsigned char targetByte = portNumber;
    unsigned char value = flowControlled;
    unsigned char command[] = { 0x40, commandByte, targetByte, value, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingPowered:(BOOL)powered onPortNumber:(ZBSerialPortNumber)portNumber {
    unsigned char commandByte = 0x10;
    unsigned char targetByte = portNumber;
    unsigned char value = powered;
    unsigned char command[] = { 0x40, commandByte, targetByte, value, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSavingConfiguration {
    unsigned char command[] = { 0x40, 0x09, 0xA0, 0x00, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (void)processSendDataTask:(ZBSerialPortCommunicatorTask *)task {
    CBService *serialPortService = [self serviceForPortNumber:task.portNumber];
    CBCharacteristic *writeCharacteristic = [self writeCharacteristicForService:serialPortService];
    __block NSData *remainingData = task.data;
    CBCharacteristicWriteType writeType = CBCharacteristicWriteWithoutResponse;
    NSUInteger chunkSize = 20;
    dispatch_queue_t queue = dispatch_queue_create("com.glastonia.zeeba.sendDataQueue", NULL);
    dispatch_async(queue, ^{
        while (remainingData) {
            NSData *payload = remainingData.length > chunkSize ? [remainingData subdataWithRange:NSMakeRange(0, chunkSize)] : remainingData;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.peripheral writeValue:payload forCharacteristic:writeCharacteristic type:writeType];
            });
            remainingData = remainingData.length > chunkSize ? [remainingData subdataWithRange:NSMakeRange(chunkSize, remainingData.length - chunkSize)] : nil;
            if (remainingData) {
                [NSThread sleepForTimeInterval:0.02];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self completeCurrentSendDataTaskWithError:nil];
        });
    });
}

#pragma mark - Accessors

- (NSHashTable *)weakObservers {
    if (!_weakObservers) {
        _weakObservers = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    }
    return _weakObservers;
}

@end
