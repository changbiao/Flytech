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

+ (instancetype)sendDataTaskWithPortNumber:(ZBSerialPortNumber)portNumber data:(NSData *)data completionHandler:(void(^)(NSError *error))completionHandler {
    ZBSerialPortCommunicatorTask *task = [self taskWithType:ZBSerialPortCommunicatorTaskTypeSendData portNumber:portNumber completionHandler:completionHandler];
    task.data = data;
    return task;
}

+ (instancetype)sendDataEnsuredTaskWithPortNumber:(ZBSerialPortNumber)portNumber data:(NSData *)data completionHandler:(void (^)(NSError *))completionHandler {
    ZBSerialPortCommunicatorTask *task = [self taskWithType:ZBSerialPortCommunicatorTaskTypeSendDataEnsured portNumber:portNumber completionHandler:completionHandler];
    task.data = data;
    return task;
}

+ (instancetype)getConfigurationTaskWithPortNumber:(ZBSerialPortNumber)portNumber completionHandler:(void(^)(ZBSerialPortConfiguration *configuration, NSError *error))completionHandler {
    return [self taskWithType:ZBSerialPortCommunicatorTaskTypeGetConfiguration portNumber:portNumber completionHandler:completionHandler];
}

+ (instancetype)setConfigurationTaskWithPortNumber:(ZBSerialPortNumber)portNumber configuration:(ZBSerialPortConfiguration *)configuration completionHandler:(void(^)(NSError *error))completionHandler {
    ZBSerialPortCommunicatorTask *task = [self taskWithType:ZBSerialPortCommunicatorTaskTypeSetConfiguration portNumber:portNumber completionHandler:completionHandler];
    task.configuration = configuration;
    return task;
}

#pragma mark - Internals

+ (instancetype)taskWithType:(ZBSerialPortCommunicatorTaskType)type portNumber:(ZBSerialPortNumber)portNumber completionHandler:(id)completionHandler {
    ZBSerialPortCommunicatorTask *task = [ZBSerialPortCommunicatorTask new];
    task.type = type;
    task.portNumber = portNumber;
    task.completionHandler = completionHandler;
    return task;
}

@end
