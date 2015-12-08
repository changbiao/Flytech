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
#import "FTSerialPortConfigurator.h"
#import "FTPrinter+Private.h"
#import "FTPrinter+Advanced.h"
#import "FTDebugging.h"
#import "FTPrinterFunctionSettings+Factory.h"

@interface FTStand ()

@property (assign, nonatomic) FTStandModel model;
@property (copy, nonatomic) NSString *firmwareRevision;
@property (strong, nonatomic) FTSerialPortConfigurator *serialPortConfigurator;
@property (strong, nonatomic) FTPrinter *printer;

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
    self.prepareForUseCompletionHandler = completionHandler;
    [self.peripheralController prepareForUseWithCompletion:^(NSString *modelNumber, NSString *firmwareRevision, FTSerialPortCommunicator *serialPortCommunicator, NSError *error) {
        FTLog(@"Peripheral controller prepared for use with model number: %@, firmware revision: %@, serial port communicator: %@, error: %@", modelNumber, firmwareRevision, serialPortCommunicator, error);
        if (error) {
            completionHandler(error);
            return;
        }
        self.model = [FTStandModelNumberParser standModelForModelNumberString:modelNumber];
        self.firmwareRevision = firmwareRevision;
        self.serialPortCommunicator = serialPortCommunicator;
        [self.serialPortConfigurator applyConfigurationAppropriateForStandModel:self.model toSerialPortCommunicator:self.serialPortCommunicator completion:^(NSError *error) {
            if (error) {
                completionHandler(error);
                return;
            }
            [self initializePrinterWithCompletion:^(NSError *error) {
                if (error) {
                    completionHandler(error);
                    return;
                }
                [self ensurePrinterConfigurationWithCompletion:^(NSError *error) {
                    if (error) {
                        completionHandler(error);
                        return;
                    }
                    [self.printer enableAutomaticStatusBackForChangingDrawerSensorStatus:YES printerInformation:NO errorStatus:YES paperSensorInformation:YES presenterInformation:NO completion:completionHandler];
                }];
            }];
        }];
    }];
}

#pragma mark - Internals

- (FTSerialPortNumber)targetPortNumberForPrinterOnStandModel:(FTStandModel)model {
    switch (model) {
        case FTStandModelT605: return FTSerialPortNumberThree; break;
        case FTStandModelUnknown: return FTSerialPortNumberThree; break;
    }
}

- (void)initializePrinterWithCompletion:(void(^)(NSError *error))completion {
    self.printer = [[FTPrinter alloc] initWithSerialPortCommunicator:self.serialPortCommunicator portNumber:[self targetPortNumberForPrinterOnStandModel:self.model]];
    [self.printer send512ZeroBytesWithCompletion:nil]; // This is due to some bug on the logic board, the first many bytes received are lost.
    [self.printer initializeHardwareWithCompletion:completion];
}

- (void)ensurePrinterConfigurationWithCompletion:(void(^)(NSError *error))completion {
    FTPrinterFunctionSettings *appropriateFunctionSettings = [FTPrinterFunctionSettings functionSettingsForStandModel:self.model];
    [self.printer functionSettingsWithCompletion:^(FTPrinterFunctionSettings *functionSettings, NSError *error) {
        if (error) {
            completion(error);
            return;
        }
        functionSettings.automaticStatusResponseEnabled = NO;
        if ([functionSettings isEqual:appropriateFunctionSettings]) {
            completion(nil);
        } else {
            [self.printer setFunctionSettings:appropriateFunctionSettings storing:NO completion:completion];
        }
    }];
}

- (void)initializePrinterHardwareWithCompletion:(void(^)(NSError *error))completion {
    [self.printer initializeHardwareWithCompletion:completion];
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

- (void (^)(NSError *))prepareForUseCompletionHandler {
    return objc_getAssociatedObject(self, @selector(prepareForUseCompletionHandler));
}

- (FTSerialPortConfigurator *)serialPortConfigurator {
    id serialPortConfigurator = objc_getAssociatedObject(self, @selector(serialPortConfigurator));
    if (!serialPortConfigurator) {
        serialPortConfigurator = [FTSerialPortConfigurator new];
        self.serialPortConfigurator = serialPortConfigurator;
    }
    return serialPortConfigurator;
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

- (void)setPrepareForUseCompletionHandler:(void (^)(NSError *))prepareForUseCompletionHandler {
    objc_setAssociatedObject(self, @selector(prepareForUseCompletionHandler), prepareForUseCompletionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setSerialPortConfigurator:(FTSerialPortConfigurator *)serialPortConfigurator {
    objc_setAssociatedObject(self, @selector(serialPortConfigurator), serialPortConfigurator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
