//
//  ZBSerialPortConfigurator.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 12/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBSerialPortConfigurator.h"
#import "ZBErrorDomain+Factory.h"
#import "ZBSerialPortCommunicator.h"
#import "ZBSerialPortConfiguration+Factory.h"
#import "ZBDebugging.h"

@interface ZBSerialPortConfigurator ()

@property (strong, nonatomic) ZBSerialPortCommunicator *communicator;
@property (assign, nonatomic) ZBStandModel model;
@property (copy, nonatomic) void(^completionHandler)(NSError *error);

@end

@implementation ZBSerialPortConfigurator

#pragma mark - Public Interface

- (void)applyConfigurationAppropriateForStandModel:(ZBStandModel)model toSerialPortCommunicator:(ZBSerialPortCommunicator *)communicator completion:(void (^)(NSError *))completion {
    if (self.communicator) {
        completion([ZBErrorDomain zeebaError]);
        return;
    }
    self.communicator = communicator;
    self.model = model;
    self.completionHandler = completion;
    [self getConfigurationForPortNumber:ZBSerialPortNumberOne];
}

#pragma mark - Internals

- (void)getConfigurationForPortNumber:(ZBSerialPortNumber)portNumber {
    if (portNumber > ZBSerialPortNumberThree) {
        [self completeWithError:nil];
        return;
    }
    [self.communicator configurationForPortNumber:portNumber completion:^(ZBSerialPortConfiguration *configuration, NSError *error) {
        if (error) {
            [self completeWithError:error];
            return;
        }
        ZBSerialPortConfiguration *appropriateConfiguration = [ZBSerialPortConfiguration configurationForPortNumber:portNumber standModel:self.model];
        ZBLog(@"Appropriate configuration for port %ld: %@", (unsigned long)portNumber, appropriateConfiguration);
        ZBLog(@"Current configuration for port %ld: %@", (unsigned long)portNumber, configuration);
        if ([configuration isEqual:appropriateConfiguration]) {
            [self getConfigurationForPortNumber:portNumber + 1];
        } else {
            [self applyConfiguration:appropriateConfiguration toPortNumber:portNumber];
        }
    }];
}

- (void)applyConfiguration:(ZBSerialPortConfiguration *)configuration toPortNumber:(ZBSerialPortNumber)portNumber {
    [self.communicator applyConfiguration:configuration toPortNumber:portNumber completion:^(NSError *error) {
        if (error) {
            [self completeWithError:error];
            return;
        }
        [self getConfigurationForPortNumber:portNumber + 1];
    }];
}

- (void)completeWithError:(NSError *)error {
    self.communicator = nil;
    self.model = ZBStandModelUnknown;
    void(^completionHandler)(NSError *error) = self.completionHandler;
    self.completionHandler = nil;
    completionHandler(error);
}

@end
