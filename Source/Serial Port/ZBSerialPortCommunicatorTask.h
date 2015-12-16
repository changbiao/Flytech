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
@property (copy, nonatomic) id completion;
@property (strong, nonatomic) CBService *service;
@property (strong, nonatomic) CBCharacteristic *characteristic;

+ (instancetype)sendDataTaskWithPortNumber:(ZBSerialPortNumber)portNumber data:(NSData *)data completion:(void(^)(NSError *error))completion;
+ (instancetype)sendDataEnsuredTaskWithPortNumber:(ZBSerialPortNumber)portNumber data:(NSData *)data completion:(void(^)(NSError *error))completion;
+ (instancetype)getConfigurationTaskWithPortNumber:(ZBSerialPortNumber)portNumber completion:(void(^)(ZBSerialPortConfiguration *configuration, NSError *error))completion;
+ (instancetype)setConfigurationTaskWithPortNumber:(ZBSerialPortNumber)portNumber configuration:(ZBSerialPortConfiguration *)configuration completion:(void(^)(NSError *error))completion;

@end
