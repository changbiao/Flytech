//
//  ZBSerialPortCommunicatorTask.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBSerialPortCommunicatorTask.h"

@implementation ZBSerialPortCommunicatorTask

#pragma mark - Public Interface

+ (instancetype)sendDataTaskWithPortNumber:(ZBSerialPortNumber)portNumber data:(NSData *)data completion:(void(^)(NSError *error))completion {
    ZBSerialPortCommunicatorTask *task = [self taskWithType:ZBSerialPortCommunicatorTaskTypeSendData portNumber:portNumber completion:completion];
    task.data = data;
    return task;
}

+ (instancetype)sendDataEnsuredTaskWithPortNumber:(ZBSerialPortNumber)portNumber data:(NSData *)data completion:(void (^)(NSError *))completion {
    ZBSerialPortCommunicatorTask *task = [self taskWithType:ZBSerialPortCommunicatorTaskTypeSendDataEnsured portNumber:portNumber completion:completion];
    task.data = data;
    return task;
}

+ (instancetype)getConfigurationTaskWithPortNumber:(ZBSerialPortNumber)portNumber completion:(void(^)(ZBSerialPortConfiguration *configuration, NSError *error))completion {
    return [self taskWithType:ZBSerialPortCommunicatorTaskTypeGetConfiguration portNumber:portNumber completion:completion];
}

+ (instancetype)setConfigurationTaskWithPortNumber:(ZBSerialPortNumber)portNumber configuration:(ZBSerialPortConfiguration *)configuration completion:(void(^)(NSError *error))completion {
    ZBSerialPortCommunicatorTask *task = [self taskWithType:ZBSerialPortCommunicatorTaskTypeSetConfiguration portNumber:portNumber completion:completion];
    task.configuration = configuration;
    return task;
}

#pragma mark - Internals

+ (instancetype)taskWithType:(ZBSerialPortCommunicatorTaskType)type portNumber:(ZBSerialPortNumber)portNumber completion:(id)completion {
    ZBSerialPortCommunicatorTask *task = [ZBSerialPortCommunicatorTask new];
    task.type = type;
    task.portNumber = portNumber;
    task.completion = completion;
    return task;
}

@end
