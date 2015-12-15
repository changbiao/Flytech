//
//  ZBSerialPortCommunicator.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 27/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZBSerialPortConfiguration.h"

@class ZBSerialPortCommunicator;

typedef NS_ENUM(NSUInteger, ZBSerialPortNumber) {
    ZBSerialPortNumberOne = 1,
    ZBSerialPortNumberTwo = 2,
    ZBSerialPortNumberThree = 3
};

typedef NS_ENUM(NSUInteger, ZBSerialPortCommunicatorErrorCode) {
    ZBSerialPortCommunicatorErrorCodeInternalError
};

@protocol ZBSerialPortCommunicatorObserver <NSObject>

- (void)serialPortCommunicator:(ZBSerialPortCommunicator *)serialPortCommunicator receivedData:(NSData *)data fromPortNumber:(ZBSerialPortNumber)portNumber;

@end

@interface ZBSerialPortCommunicator : NSObject

@property (copy, nonatomic, readonly) NSSet<id<ZBSerialPortCommunicatorObserver>> *observers;

- (void)addObserver:(id<ZBSerialPortCommunicatorObserver>)observer;
- (void)removeObserver:(id<ZBSerialPortCommunicatorObserver>)observer;

- (void)configurationForPortNumber:(ZBSerialPortNumber)portNumber completion:(void(^)(ZBSerialPortConfiguration *configuration, NSError *error))completion;
- (void)applyConfiguration:(ZBSerialPortConfiguration *)configuration toPortNumber:(ZBSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion;
- (void)sendData:(NSData *)data toPortNumber:(ZBSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion;
- (void)sendDataEnsured:(NSData *)data toPortNumber:(ZBSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion;

@end
