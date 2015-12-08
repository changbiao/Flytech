//
//  FTSerialPortCommunicator.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 27/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTSerialPortCommunicator.h"
#import "FTSerialPortCommunicator+Private.h"
#import "CBPeripheral+Services.h"
#import "CBService+Characteristics.h"
#import "FTSerialPortCommunicatorTask.h"
#import "FTSerialPortCommunicator+Private.h"
#import "FTErrorDomain+Factory.h"
#import "FTDebugging.h"

@interface FTSerialPortCommunicator ()

@property (strong, nonatomic) NSHashTable *weakObservers;

@end

@implementation FTSerialPortCommunicator

#pragma mark - Public Interface

- (NSSet<id<FTSerialPortCommunicatorObserver>> *)observers {
    return self.weakObservers.setRepresentation;
}

- (void)addObserver:(id<FTSerialPortCommunicatorObserver>)observer {
    [self.weakObservers addObject:observer];
}

- (void)removeObserver:(id<FTSerialPortCommunicatorObserver>)observer {
    [self.weakObservers removeObject:observer];
}

- (void)configurationForPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(FTSerialPortConfiguration *configuration, NSError *error))completion {
    [self addTask:[FTSerialPortCommunicatorTask getConfigurationTaskWithPortNumber:portNumber completionHandler:completion]];
}

- (void)applyConfiguration:(FTSerialPortConfiguration *)configuration toPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion {
    FTLog(@"Configuration: %@, Port number: %ld", configuration, portNumber);
    [self addTask:[FTSerialPortCommunicatorTask setConfigurationTaskWithPortNumber:portNumber configuration:configuration completionHandler:completion]];
}

- (void)sendData:(NSData *)data toPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion {
    FTLog(@"Data: %@, Port number: %ld", data, portNumber);
    [self addTask:[FTSerialPortCommunicatorTask sendDataTaskWithPortNumber:portNumber data:data completionHandler:completion]];
}

- (void)sendDataEnsured:(NSData *)data toPortNumber:(FTSerialPortNumber)portNumber completion:(void (^)(NSError *))completion {
    FTLog(@"Data: %@, Port number: %ld", data, portNumber);
    [self addTask:[FTSerialPortCommunicatorTask sendDataEnsuredTaskWithPortNumber:portNumber data:data completionHandler:completion]];
}

#pragma mark - Internals

- (void)addTask:(FTSerialPortCommunicatorTask *)task {
    [self.tasks addObject:task];
    if (self.tasks.count == 1) {
        [self processTask:task];
    }
}

- (void)processTask:(FTSerialPortCommunicatorTask *)task {
    switch (task.type) {
        case FTSerialPortCommunicatorTaskTypeGetConfiguration: [self processGetConfigurationTask:task]; break;
        case FTSerialPortCommunicatorTaskTypeSetConfiguration: [self processSetConfigurationTask:task]; break;
        case FTSerialPortCommunicatorTaskTypeSendData: [self processSendDataTask:task]; break;
        case FTSerialPortCommunicatorTaskTypeSendDataEnsured: [self processSendDataEnsuredTask:task]; break;
    }
}

- (void)processGetConfigurationTask:(FTSerialPortCommunicatorTask *)task {
    CBService *configurationService = [self.peripheral serviceWithUUIDString:FTServiceUUIDStringConfiguration];
    CBCharacteristic *characteristic;
    switch (task.portNumber) {
        case FTSerialPortNumberOne: characteristic = [configurationService characteristicForUUIDString:FTCharacteristicUUIDStringConfigurationPortOne]; break;
        case FTSerialPortNumberTwo: characteristic = [configurationService characteristicForUUIDString:FTCharacteristicUUIDStringConfigurationPortTwo]; break;
        case FTSerialPortNumberThree: characteristic = [configurationService characteristicForUUIDString:FTCharacteristicUUIDStringConfigurationPortThree]; break;
    }
    [self.peripheral readValueForCharacteristic:characteristic];
}

- (void)processSetConfigurationTask:(FTSerialPortCommunicatorTask *)task {
    CBService *configurationService = [self.peripheral serviceWithUUIDString:FTServiceUUIDStringConfiguration];
    CBCharacteristic *characteristic = [configurationService characteristicForUUIDString:FTCharacteristicUUIDStringConfigurationCommandPort];
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
    if (task.portNumber != FTSerialPortNumberThree) {
        NSData *poweredCommand = [self commandForSettingPowered:task.configuration.powered onPortNumber:task.portNumber];
        [self.peripheral writeValue:poweredCommand forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    NSData *saveConfigurationCommand = [self commandForSavingConfiguration];
    [self.peripheral writeValue:saveConfigurationCommand forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    [self completeCurrentSetConfigurationTask];
}

- (void)completeCurrentSetConfigurationTask {
    void(^completionHandler)(NSError *error) = self.tasks.firstObject.completionHandler;
    [self completeCurrentTask];
    completionHandler(nil);
}

- (NSData *)commandForSettingBaudRate:(FTSerialPortBaudRate)baudRate onPortNumber:(FTSerialPortNumber)portNumber {
    unsigned char commandByte = 0x01;
    unsigned char targetByte = portNumber;
    unsigned char valueByte = baudRate;
    unsigned char command[] = { 0x40, commandByte, targetByte, valueByte, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingParity:(FTSerialPortParity)parity onPortNumber:(FTSerialPortNumber)portNumber {
    unsigned char commandByte = 0x02;
    unsigned char targetByte = portNumber;
    unsigned char value = parity;
    unsigned char command[] = { 0x40, commandByte, targetByte, value, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingDataBits:(FTSerialPortDataBits)dataBits onPortNumber:(FTSerialPortNumber)portNumber {
    unsigned char commandByte = 0x03;
    unsigned char targetByte = portNumber;
    unsigned char value = dataBits;
    unsigned char command[] = { 0x40, commandByte, targetByte, value, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingStopBits:(FTSerialPortStopBits)stopBits onPortNumber:(FTSerialPortNumber)portNumber {
    unsigned char commandByte = 0x04;
    unsigned char targetByte = portNumber;
    unsigned char value = stopBits;
    unsigned char command[] = { 0x40, commandByte, targetByte, value, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingFlowControlled:(BOOL)flowControlled onPortNumber:(FTSerialPortNumber)portNumber {
    unsigned char commandByte = 0x05;
    unsigned char targetByte = portNumber;
    unsigned char value = flowControlled;
    unsigned char command[] = { 0x40, commandByte, targetByte, value, 0x13, 0x10 };
    return [NSData dataWithBytes:command length:sizeof(command)];
}

- (NSData *)commandForSettingPowered:(BOOL)powered onPortNumber:(FTSerialPortNumber)portNumber {
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

- (void)processSendDataTask:(FTSerialPortCommunicatorTask *)task {
    CBService *serialPortService = [self serviceForPortNumber:task.portNumber];
    CBCharacteristic *writeCharacteristic = [self writeCharacteristicForService:serialPortService];
    NSData *remainingData = task.data;
    CBCharacteristicWriteType writeType = CBCharacteristicWriteWithoutResponse;
    NSUInteger chunkSize = 100;
    while (remainingData) {
        NSData *payload = remainingData.length > chunkSize ? [remainingData subdataWithRange:NSMakeRange(0, chunkSize)] : remainingData;
        [self.peripheral writeValue:payload forCharacteristic:writeCharacteristic type:writeType];
        remainingData = remainingData.length > chunkSize ? [remainingData subdataWithRange:NSMakeRange(chunkSize, remainingData.length - chunkSize)] : nil;
    }
    [self completeCurrentSendDataTaskWithError:nil];
}

#pragma mark - Accessors

- (NSHashTable *)weakObservers {
    if (!_weakObservers) {
        _weakObservers = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    }
    return _weakObservers;
}

@end
