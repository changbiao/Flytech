//
//  FTSerialPortCommunicator+Private.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTSerialPortCommunicator+Private.h"
#import <objc/runtime.h>
#import "CBPeripheral+Services.h"
#import "CBService+Characteristics.h"
#import "FTErrorDomain+Factory.h"
#import "FTSerialPortDataReception.h"
#import "FTDebugging.h"

@interface FTSerialPortCommunicator ()

@property (strong, nonatomic) NSMutableSet<FTSerialPortDataReception *> *dataReceptions;

@end

@implementation FTSerialPortCommunicator (Private)

#pragma mark - Private Interface

- (void)receiveData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic {
    if ([characteristic.service.UUID.UUIDString isEqualToString:FTServiceUUIDStringConfiguration]) {
        [self handleResponseForGetConfigurationWithResponseData:data];
    } else if ([characteristic.UUID.UUIDString isEqualToString:FTCharacteristicUUIDStringSerialPortOneTX]) {
        [self handleReceivedData:data fromPortNumber:FTSerialPortNumberOne];
    } else if ([characteristic.UUID.UUIDString isEqualToString:FTCharacteristicUUIDStringSerialPortTwoTX]) {
        [self handleReceivedData:data fromPortNumber:FTSerialPortNumberTwo];
    } else if ([characteristic.UUID.UUIDString isEqualToString:FTCharacteristicUUIDStringSerialPortThreeTX]) {
        [self handleReceivedData:data fromPortNumber:FTSerialPortNumberThree];
    }
}

- (void)completeCurrentTask {
    [self.tasks removeObject:self.tasks.firstObject];
}

#pragma mark - Internals

- (void)handleResponseForGetConfigurationWithResponseData:(NSData *)responseData {
    FTSerialPortConfiguration *configuration = [[FTSerialPortConfiguration alloc] initWithData:responseData];
    void(^completionHandler)(FTSerialPortConfiguration *configuration, NSError *error) = self.tasks.firstObject.completionHandler;
    [self completeCurrentTask];
    completionHandler(configuration, configuration ? nil : [FTErrorDomain flytechError]);
}

- (void)handleReceivedData:(NSData *)data fromPortNumber:(FTSerialPortNumber)portNumber {
    NSPredicate *predicateForExistingDataReception = [NSPredicate predicateWithFormat:@"%K == %ld", NSStringFromSelector(@selector(portNumber)), portNumber];
    FTSerialPortDataReception *dataReception = [[self.dataReceptions filteredSetUsingPredicate:predicateForExistingDataReception] anyObject];
    if (dataReception) {
        [dataReception.timer invalidate];
        [dataReception.data appendData:data];
    } else {
        dataReception = [FTSerialPortDataReception new];
        dataReception.portNumber = portNumber;
        dataReception.data = [NSMutableData dataWithData:data];
        [self.dataReceptions addObject:dataReception];
    }
    dataReception.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(dataReceptionTimerElapsed:) userInfo:nil repeats:NO];
}

- (void)dataReceptionTimerElapsed:(NSTimer *)timer {
    NSPredicate *predicateForDataReception = [NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(timer)), timer];
    FTSerialPortDataReception *dataReception = [[self.dataReceptions filteredSetUsingPredicate:predicateForDataReception] anyObject];
    [self.dataReceptions removeObject:dataReception];
    for (id<FTSerialPortCommunicatorObserver> serialPortCommunicatorObserver in self.observers) {
        [serialPortCommunicatorObserver serialPortCommunicator:self receivedData:dataReception.data fromPortNumber:dataReception.portNumber];
    }
}

#pragma mark - Accessors

- (CBPeripheral *)peripheral {
    return objc_getAssociatedObject(self, @selector(peripheral));
}

- (NSMutableArray<FTSerialPortCommunicatorTask *> *)tasks {
    NSMutableArray *tasks = objc_getAssociatedObject(self, @selector(tasks));
    if (!tasks) {
        tasks = [NSMutableArray array];
        [self setTasks:tasks];
    }
    return tasks;
}

- (NSMutableSet<FTSerialPortDataReception *> *)dataReceptions {
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

- (void)setTasks:(NSMutableArray<FTSerialPortCommunicatorTask *> *)tasks {
    objc_setAssociatedObject(self, @selector(tasks), tasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDataReceptions:(NSMutableSet<FTSerialPortDataReception *> *)dataReceptions {
    objc_setAssociatedObject(self, @selector(dataReceptions), dataReceptions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
