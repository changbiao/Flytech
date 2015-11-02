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

@implementation FTSerialPortCommunicator (Private)

#pragma mark - Private Interface

- (void)receiveData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic {
    if ([characteristic.service.UUID.UUIDString isEqualToString:FTServiceUUIDStringConfiguration]) {
        [self handleResponseForGetConfigurationWithResponseData:data];
    }
}

- (void)completeCurrentTask {
    [self.tasks removeObject:self.tasks.firstObject];
}

#pragma mark - Internals

- (void)handleResponseForGetConfigurationWithResponseData:(NSData *)responseData {
    FTSerialPortConfiguration *configuration = [[FTSerialPortConfiguration alloc] initWithData:responseData];
    void(^completionHandler)(FTSerialPortConfiguration *configuration, NSError *error) = self.tasks.firstObject.completionHandler;
    completionHandler(configuration, configuration ? nil : [FTErrorDomain flytechError]);
    [self completeCurrentTask];
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

#pragma mark - Mutators

- (void)setPeripheral:(CBPeripheral *)peripheral {
    objc_setAssociatedObject(self, @selector(peripheral), peripheral, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setTasks:(NSMutableArray<FTSerialPortCommunicatorTask *> *)tasks {
    objc_setAssociatedObject(self, @selector(tasks), tasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
