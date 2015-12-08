//
//  FTSerialPortCommunicatorTask.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTSerialPortCommunicatorTask.h"

@implementation FTSerialPortCommunicatorTask

#pragma mark - Public Interface

+ (instancetype)sendDataTaskWithPortNumber:(FTSerialPortNumber)portNumber data:(NSData *)data completionHandler:(void(^)(NSError *error))completionHandler {
    FTSerialPortCommunicatorTask *task = [self taskWithType:FTSerialPortCommunicatorTaskTypeSendData portNumber:portNumber completionHandler:completionHandler];
    task.data = data;
    return task;
}

+ (instancetype)sendDataEnsuredTaskWithPortNumber:(FTSerialPortNumber)portNumber data:(NSData *)data completionHandler:(void (^)(NSError *))completionHandler {
    FTSerialPortCommunicatorTask *task = [self taskWithType:FTSerialPortCommunicatorTaskTypeSendDataEnsured portNumber:portNumber completionHandler:completionHandler];
    task.data = data;
    return task;
}

+ (instancetype)getConfigurationTaskWithPortNumber:(FTSerialPortNumber)portNumber completionHandler:(void(^)(FTSerialPortConfiguration *configuration, NSError *error))completionHandler {
    return [self taskWithType:FTSerialPortCommunicatorTaskTypeGetConfiguration portNumber:portNumber completionHandler:completionHandler];
}

+ (instancetype)setConfigurationTaskWithPortNumber:(FTSerialPortNumber)portNumber configuration:(FTSerialPortConfiguration *)configuration completionHandler:(void(^)(NSError *error))completionHandler {
    FTSerialPortCommunicatorTask *task = [self taskWithType:FTSerialPortCommunicatorTaskTypeSetConfiguration portNumber:portNumber completionHandler:completionHandler];
    task.configuration = configuration;
    return task;
}

#pragma mark - Internals

+ (instancetype)taskWithType:(FTSerialPortCommunicatorTaskType)type portNumber:(FTSerialPortNumber)portNumber completionHandler:(id)completionHandler {
    FTSerialPortCommunicatorTask *task = [FTSerialPortCommunicatorTask new];
    task.type = type;
    task.portNumber = portNumber;
    task.completionHandler = completionHandler;
    return task;
}

@end
