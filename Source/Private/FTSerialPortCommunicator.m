//
//  FTSerialPortCommunicator.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 27/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTSerialPortCommunicator.h"
#import "FTSerialPortCommunicator+Private.h"
#import "CBPeripheral+Services.h"
#import "CBService+Characteristics.h"
#import "FTSerialPortCommunicatorTask.h"

@interface FTSerialPortCommunicator ()

@property (strong, nonatomic) NSHashTable *weakObservers;
@property (strong, nonatomic) NSMutableArray *tasks;

@end

@implementation FTSerialPortCommunicator

#pragma mark - Public Interface

- (NSSet<id<FTSerialPortCommunicatorObserver>> *)observers {
    return self.weakObservers.setRepresentation;
}

- (void)addObserver:(id<FTSerialPortCommunicatorObserver>)observer {
    [self.weakObservers addObject:observer];
}

- (void)removeObserver:(id<FTSerialPortCommunicatorObserver>)observer {
    [self.weakObservers removeObject:observer];
}

- (void)configurationForPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(FTSerialPortConfiguration *configuration, NSError *error))completion {
    [self addTask:[FTSerialPortCommunicatorTask getConfigurationTaskWithPortNumber:portNumber completionHandler:completion]];
}

- (void)applyConfiguration:(FTSerialPortConfiguration *)configuration toPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion {
    
}

- (void)sendData:(NSData *)data toPortNumber:(FTSerialPortNumber)portNumber completion:(void(^)(NSError *error))completion {
    
}

#pragma mark - Internals

- (void)addTask:(FTSerialPortCommunicatorTask *)task {
    [self.tasks addObject:task];
    if (self.tasks.count == 1) {
        [self processTask:task];
    }
}

- (void)processTask:(FTSerialPortCommunicatorTask *)task {
    switch (task.type) {
        case FTSerialPortCommunicatorTaskTypeGetConfiguration: [self processGetConfigurationTask:task]; break;
        case FTSerialPortCommunicatorTaskTypeSetConfiguration: [self processSetConfigurationTask:task]; break;
        case FTSerialPortCommunicatorTaskTypeSendData: [self processSendDataTask:task]; break;
    }
}

- (void)processGetConfigurationTask:(FTSerialPortCommunicatorTask *)task {
    CBService *configurationService = [self.peripheral serviceWithUUIDString:FTServiceUUIDStringConfiguration];
    CBCharacteristic *characteristic;
    switch (task.portNumber) {
        case FTSerialPortNumberOne: characteristic = [configurationService characteristicForUUIDString:FTCharacteristicUUIDStringConfigurationPortOne]; break;
        case FTSerialPortNumberTwo: characteristic = [configurationService characteristicForUUIDString:FTCharacteristicUUIDStringConfigurationPortTwo]; break;
        case FTSerialPortNumberThree: characteristic = [configurationService characteristicForUUIDString:FTCharacteristicUUIDStringConfigurationPortThree]; break;
    }
    [self.peripheral readValueForCharacteristic:characteristic];
}

- (void)processSetConfigurationTask:(FTSerialPortCommunicatorTask *)task {
    
}

- (void)processSendDataTask:(FTSerialPortCommunicatorTask *)task {
    
}

#pragma mark - Accessors

- (NSHashTable *)weakObservers {
    if (!_weakObservers) {
        _weakObservers = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    }
    return _weakObservers;
}

@end
