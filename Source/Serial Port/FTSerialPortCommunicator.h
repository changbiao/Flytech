//
//  FTSerialPortCommunicator.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 27/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FTSerialPortConfiguration.h"

@class FTSerialPortCommunicator;

typedef NS_ENUM(NSUInteger, FTSerialPortNumber) {
    FTSerialPortNumberOne = 1,
    FTSerialPortNumberTwo = 2,
    FTSerialPortNumberThree = 3
};

typedef NS_ENUM(NSUInteger, FTSerialPortCommunicatorErrorCode) {
    FTSerialPortCommunicatorErrorCodeInternalError
};

@protocol FTSerialPortCommunicatorObserver <NSObject>

- (void)serialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator receivedData:(NSData *)data fromPortNumber:(FTSerialPortNumber)portNumber;

@end

@interface FTSerialPortCommunicator : NSObject

@property (copy, nonatomic, readonly) NSSet<id<FTSerialPortCommunicatorObserver>> *observers;

- (void)addObserver:(id<FTSerialPortCommunicatorObserver>)observer;
- (void)removeObserver:(id<FTSerialPortCommunicatorObserver>)observer;

- (void)configurationForPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(FTSerialPortConfiguration *configuration, NSError *error))completion;
- (void)applyConfiguration:(FTSerialPortConfiguration *)configuration toPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion;
- (void)sendData:(NSData *)data toPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion;
- (void)sendDataEnsured:(NSData *)data toPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion;

@end
