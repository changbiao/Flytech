//
//  FTStand+Private.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTStand+Private.h"
#import <objc/runtime.h>
#import "FTStandModelNumberParser.h"

@interface FTStand ()

@property (assign, nonatomic) FTStandModel model;
@property (copy, nonatomic) NSString *firmwareRevision;

@end

@implementation FTStand (Private)

#pragma mark - Life Cycle

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    self = [self initWithIdentifier:peripheral.identifier];
    if (self) {
        self.peripheral = peripheral;
    }
    return self;
}

#pragma mark - Private Interface

- (void)prepareForUseWithCompletion:(void (^)(NSError *error))completionHandler {
    self.peripheralController = [FTPeripheralController new];
    self.peripheralController.peripheral = self.peripheral;
    [self.peripheralController prepareForUseWithCompletion:^(NSString *modelNumber, NSString *firmwareRevision, FTSerialPortCommunicator *serialPortCommunicator, NSError *error) {
        NSLog(@"Peripheral controller prepared for use with model number: %@, firmware revision: %@, serial port communicator: %@, error: %@", modelNumber, firmwareRevision, serialPortCommunicator, error);
        if (error) {
            completionHandler(error);
            return;
        }
        self.model = [FTStandModelNumberParser standModelForModelNumberString:modelNumber];
        self.firmwareRevision = firmwareRevision;
        self.serialPortCommunicator = serialPortCommunicator;
    }];
}

#pragma mark - Accessors

- (CBPeripheral *)peripheral {
    return objc_getAssociatedObject(self, @selector(peripheral));
}

- (FTPeripheralController *)peripheralController {
    return objc_getAssociatedObject(self, @selector(peripheralController));
}

- (FTSerialPortCommunicator *)serialPortCommunicator {
    return objc_getAssociatedObject(self, @selector(serialPortCommunicator));
}

#pragma mark - Mutators

- (void)setPeripheral:(CBPeripheral *)peripheral {
    objc_setAssociatedObject(self, @selector(peripheral), peripheral, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPeripheralController:(FTPeripheralController *)peripheralController {
    objc_setAssociatedObject(self, @selector(peripheralController), peripheralController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSerialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator {
    objc_setAssociatedObject(self, @selector(serialPortCommunicator), serialPortCommunicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
