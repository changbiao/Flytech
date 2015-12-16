//
//  ZBSerialPortCommunicator+Private.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBSerialPortCommunicator+Private.h"
#import <objc/runtime.h>
#import "CBPeripheral+ZBServices.h"
#import "CBService+ZBCharacteristics.h"
#import "ZBErrorDomain+Factory.h"
#import "ZBSerialPortDataReception.h"
#import "ZBDebugging.h"

@interface ZBSerialPortCommunicator ()

@property (strong, nonatomic) NSMutableSet<ZBSerialPortDataReception *> *dataReceptions;

@end

@implementation ZBSerialPortCommunicator (Private)

#pragma mark - Private Interface

- (void)processSendDataEnsuredTask:(ZBSerialPortCommunicatorTask *)task {
    task.service = [self serviceForPortNumber:task.portNumber];
    task.characteristic = [self writeCharacteristicForService:task.service];
    [self continueProcessingSendDataEnsuredTask:task];
}

- (void)continueProcessingSendDataEnsuredTask:(ZBSerialPortCommunicatorTask *)task {
    CBCharacteristicWriteType writeType = CBCharacteristicWriteWithResponse;
    NSUInteger chunkSize = 20;
    if (task.data) {
        NSData *payload = task.data.length > chunkSize ? [task.data subdataWithRange:NSMakeRange(0, chunkSize)] : task.data;
        task.data = task.data.length > chunkSize ? [task.data subdataWithRange:NSMakeRange(chunkSize, task.data.length - chunkSize)] : nil;
        [self.peripheral writeValue:payload forCharacteristic:task.characteristic type:writeType];
    } else {
        [self completeCurrentSendDataTaskWithError:nil];
    }
}

- (void)receiveData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic {
    if ([characteristic.service.UUID.UUIDString isEqualToString:ZBServiceUUIDStringConfiguration]) {
        [self handleResponseForGetConfigurationWithResponseData:data];
    } else if ([characteristic.UUID.UUIDString isEqualToString:ZBCharacteristicUUIDStringSerialPortOneTX]) {
        [self handleReceivedData:data fromPortNumber:ZBSerialPortNumberOne];
    } else if ([characteristic.UUID.UUIDString isEqualToString:ZBCharacteristicUUIDStringSerialPortTwoTX]) {
        [self handleReceivedData:data fromPortNumber:ZBSerialPortNumberTwo];
    } else if ([characteristic.UUID.UUIDString isEqualToString:ZBCharacteristicUUIDStringSerialPortThreeTX]) {
        [self handleReceivedData:data fromPortNumber:ZBSerialPortNumberThree];
    }
}

- (void)sendingDataCompletedForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    ZBSerialPortCommunicatorTask *currentTask = self.tasks.firstObject;
    if (!currentTask || currentTask.characteristic != characteristic) {
        return;
    }
    if (error) {
        [self completeCurrentSendDataTaskWithError:error];
    } else {
        [self continueProcessingSendDataEnsuredTask:currentTask];
    }
}

- (void)completeCurrentTask {
    [self.tasks removeObject:self.tasks.firstObject];
}

#pragma mark - Internals

- (void)handleResponseForGetConfigurationWithResponseData:(NSData *)responseData {
    ZBSerialPortConfiguration *configuration = [[ZBSerialPortConfiguration alloc] initWithData:responseData];
    void(^completion)(ZBSerialPortConfiguration *configuration, NSError *error) = self.tasks.firstObject.completion;
    [self completeCurrentTask];
    completion(configuration, configuration ? nil : [ZBErrorDomain zeebaError]);
}

- (void)handleReceivedData:(NSData *)data fromPortNumber:(ZBSerialPortNumber)portNumber {
    NSPredicate *predicateForExistingDataReception = [NSPredicate predicateWithFormat:@"%K == %ld", NSStringFromSelector(@selector(portNumber)), portNumber];
    ZBSerialPortDataReception *dataReception = [[self.dataReceptions filteredSetUsingPredicate:predicateForExistingDataReception] anyObject];
    if (dataReception) {
        [dataReception.timer invalidate];
        [dataReception.data appendData:data];
    } else {
        dataReception = [ZBSerialPortDataReception new];
        dataReception.portNumber = portNumber;
        dataReception.data = [NSMutableData dataWithData:data];
        [self.dataReceptions addObject:dataReception];
    }
    dataReception.timer = [NSTimer scheduledTimerWithTimeInterval:0.035 target:self selector:@selector(dataReceptionTimerElapsed:) userInfo:nil repeats:NO];
}

- (void)dataReceptionTimerElapsed:(NSTimer *)timer {
    NSPredicate *predicateForDataReception = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(timer)), timer];
    ZBSerialPortDataReception *dataReception = [[self.dataReceptions filteredSetUsingPredicate:predicateForDataReception] anyObject];
    [self.dataReceptions removeObject:dataReception];
    for (id<ZBSerialPortCommunicatorObserver> serialPortCommunicatorObserver in self.observers) {
        [serialPortCommunicatorObserver serialPortCommunicator:self receivedData:dataReception.data fromPortNumber:dataReception.portNumber];
    }
}

- (CBService *)serviceForPortNumber:(ZBSerialPortNumber)portNumber {
    switch (portNumber) {
        case ZBSerialPortNumberOne: return [self.peripheral serviceWithUUIDString:ZBServiceUUIDStringSerialPortOne]; break;
        case ZBSerialPortNumberTwo: return [self.peripheral serviceWithUUIDString:ZBServiceUUIDStringSerialPortTwo]; break;
        case ZBSerialPortNumberThree: return [self.peripheral serviceWithUUIDString:ZBServiceUUIDStringSerialPortThree]; break;
    }
}

- (CBCharacteristic *)writeCharacteristicForService:(CBService *)service {
    if ([service.UUID.UUIDString isEqualToString:ZBServiceUUIDStringSerialPortOne]) {
        return [service characteristicForUUIDString:ZBCharacteristicUUIDStringSerialPortOneRX];
    } else if ([service.UUID.UUIDString isEqualToString:ZBServiceUUIDStringSerialPortTwo]) {
        return [service characteristicForUUIDString:ZBCharacteristicUUIDStringSerialPortTwoRX];
    } else if ([service.UUID.UUIDString isEqualToString:ZBServiceUUIDStringSerialPortThree]) {
        return [service characteristicForUUIDString:ZBCharacteristicUUIDStringSerialPortThreeRX];
    }
    return nil;
}

- (void)completeCurrentSendDataTaskWithError:(NSError *)error {
    void(^completion)(NSError *error) = self.tasks.firstObject.completion;
    [self completeCurrentTask];
    if (completion) {
        completion(nil);
    }
}

#pragma mark - Accessors

- (CBPeripheral *)peripheral {
    return objc_getAssociatedObject(self, @selector(peripheral));
}

- (NSMutableArray<ZBSerialPortCommunicatorTask *> *)tasks {
    NSMutableArray *tasks = objc_getAssociatedObject(self, @selector(tasks));
    if (!tasks) {
        tasks = [NSMutableArray array];
        [self setTasks:tasks];
    }
    return tasks;
}

- (NSMutableSet<ZBSerialPortDataReception *> *)dataReceptions {
    NSMutableSet *dataReceptions = objc_getAssociatedObject(self, @selector(dataReceptions));
    if (!dataReceptions) {
        dataReceptions = [NSMutableSet setWithCapacity:3];
        [self setDataReceptions:dataReceptions];
    }
    return dataReceptions;
}

#pragma mark - Mutators

- (void)setPeripheral:(CBPeripheral *)peripheral {
    objc_setAssociatedObject(self, @selector(peripheral), peripheral, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setTasks:(NSMutableArray<ZBSerialPortCommunicatorTask *> *)tasks {
    objc_setAssociatedObject(self, @selector(tasks), tasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDataReceptions:(NSMutableSet<ZBSerialPortDataReception *> *)dataReceptions {
    objc_setAssociatedObject(self, @selector(dataReceptions), dataReceptions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
