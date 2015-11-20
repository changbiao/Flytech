//
//  FTSerialPortConfigurator.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 12/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTSerialPortConfigurator.h"
#import "FTErrorDomain+Factory.h"
#import "FTSerialPortCommunicator.h"
#import "FTSerialPortConfiguration+Factory.h"
#import "FTDebugging.h"

@interface FTSerialPortConfigurator ()

@property (strong, nonatomic) FTSerialPortCommunicator *communicator;
@property (assign, nonatomic) FTStandModel model;
@property (copy, nonatomic) void(^completionHandler)(NSError *error);

@end

@implementation FTSerialPortConfigurator

#pragma mark - Public Interface

- (void)applyConfigurationAppropriateForStandModel:(FTStandModel)model toSerialPortCommunicator:(FTSerialPortCommunicator *)communicator completion:(void (^)(NSError *))completion {
    if (self.communicator) {
        completion([FTErrorDomain flytechError]);
        return;
    }
    self.communicator = communicator;
    self.model = model;
    self.completionHandler = completion;
    [self getConfigurationForPortNumber:FTSerialPortNumberOne];
}

#pragma mark - Internals

- (void)getConfigurationForPortNumber:(FTSerialPortNumber)portNumber {
    if (portNumber > FTSerialPortNumberThree) {
        [self completeWithError:nil];
        return;
    }
    [self.communicator configurationForPortNumber:portNumber completion:^(FTSerialPortConfiguration *configuration, NSError *error) {
        if (error) {
            [self completeWithError:error];
            return;
        }
        FTSerialPortConfiguration *appropriateConfiguration = [FTSerialPortConfiguration configurationForPortNumber:portNumber standModel:self.model];
        FTLog(@"Appropriate configuration for port %ld: %@", portNumber, appropriateConfiguration);
        FTLog(@"Current configuration for port %ld: %@", portNumber, configuration);
        if ([configuration isEqual:appropriateConfiguration]) {
            [self getConfigurationForPortNumber:portNumber + 1];
        } else {
            [self applyConfiguration:appropriateConfiguration toPortNumber:portNumber];
        }
    }];
}

- (void)applyConfiguration:(FTSerialPortConfiguration *)configuration toPortNumber:(FTSerialPortNumber)portNumber {
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
    self.model = FTStandModelUnknown;
    void(^completionHandler)(NSError *error) = self.completionHandler;
    self.completionHandler = nil;
    completionHandler(error);
}

@end
