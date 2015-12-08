//
//  FTSerialPortCommunicatorTask.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTSerialPortCommunicator.h"

typedef NS_ENUM(NSUInteger, FTSerialPortCommunicatorTaskType) {
    FTSerialPortCommunicatorTaskTypeSendData,
    FTSerialPortCommunicatorTaskTypeSendDataEnsured,
    FTSerialPortCommunicatorTaskTypeGetConfiguration,
    FTSerialPortCommunicatorTaskTypeSetConfiguration
};

@interface FTSerialPortCommunicatorTask : NSObject

@property (assign, nonatomic) FTSerialPortCommunicatorTaskType type;
@property (assign, nonatomic) FTSerialPortNumber portNumber;
@property (strong, nonatomic) FTSerialPortConfiguration *configuration;
@property (copy, nonatomic) NSData *data;
@property (copy, nonatomic) id completionHandler;
@property (strong, nonatomic) CBService *service;
@property (strong, nonatomic) CBCharacteristic *characteristic;

+ (instancetype)sendDataTaskWithPortNumber:(FTSerialPortNumber)portNumber data:(NSData *)data completionHandler:(void(^)(NSError *error))completionHandler;
+ (instancetype)sendDataEnsuredTaskWithPortNumber:(FTSerialPortNumber)portNumber data:(NSData *)data completionHandler:(void(^)(NSError *error))completionHandler;
+ (instancetype)getConfigurationTaskWithPortNumber:(FTSerialPortNumber)portNumber completionHandler:(void(^)(FTSerialPortConfiguration *configuration, NSError *error))completionHandler;
+ (instancetype)setConfigurationTaskWithPortNumber:(FTSerialPortNumber)portNumber configuration:(FTSerialPortConfiguration *)configuration completionHandler:(void(^)(NSError *error))completionHandler;

@end
