//
//  ZBSerialPortCommunicatorTask.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBSerialPortCommunicator.h"

typedef NS_ENUM(NSUInteger, ZBSerialPortCommunicatorTaskType) {
    ZBSerialPortCommunicatorTaskTypeSendData,
    ZBSerialPortCommunicatorTaskTypeSendDataEnsured,
    ZBSerialPortCommunicatorTaskTypeGetConfiguration,
    ZBSerialPortCommunicatorTaskTypeSetConfiguration
};

@interface ZBSerialPortCommunicatorTask : NSObject

@property (assign, nonatomic) ZBSerialPortCommunicatorTaskType type;
@property (assign, nonatomic) ZBSerialPortNumber portNumber;
@property (strong, nonatomic) ZBSerialPortConfiguration *configuration;
@property (copy, nonatomic) NSData *data;
@property (copy, nonatomic) id completionHandler;
@property (strong, nonatomic) CBService *service;
@property (strong, nonatomic) CBCharacteristic *characteristic;

+ (instancetype)sendDataTaskWithPortNumber:(ZBSerialPortNumber)portNumber data:(NSData *)data completionHandler:(void(^)(NSError *error))completionHandler;
+ (instancetype)sendDataEnsuredTaskWithPortNumber:(ZBSerialPortNumber)portNumber data:(NSData *)data completionHandler:(void(^)(NSError *error))completionHandler;
+ (instancetype)getConfigurationTaskWithPortNumber:(ZBSerialPortNumber)portNumber completionHandler:(void(^)(ZBSerialPortConfiguration *configuration, NSError *error))completionHandler;
+ (instancetype)setConfigurationTaskWithPortNumber:(ZBSerialPortNumber)portNumber configuration:(ZBSerialPortConfiguration *)configuration completionHandler:(void(^)(NSError *error))completionHandler;

@end
