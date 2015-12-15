//
//  ZBStand+Private.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBStand+Private.h"
#import <objc/runtime.h>
#import "ZBStandModelNumberParser.h"
#import "ZBSerialPortConfigurator.h"
#import "ZBPrinter+Private.h"
#import "ZBPrinter+Advanced.h"
#import "ZBDebugging.h"
#import "ZBPrinterFunctionSettings+Factory.h"

@interface ZBStand ()

@property (assign, nonatomic) ZBStandModel model;
@property (copy, nonatomic) NSString *firmwareRevision;
@property (strong, nonatomic) ZBSerialPortConfigurator *serialPortConfigurator;
@property (strong, nonatomic) ZBPrinter *printer;

@end

@implementation ZBStand (Private)

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
    self.peripheralController = [ZBPeripheralController new];
    self.peripheralController.peripheral = self.peripheral;
    self.prepareForUseCompletionHandler = completionHandler;
    [self.peripheralController prepareForUseWithCompletion:^(NSString *modelNumber, NSString *firmwareRevision, ZBSerialPortCommunicator *serialPortCommunicator, NSError *error) {
        ZBLog(@"Peripheral controller prepared for use with model number: %@, firmware revision: %@, serial port communicator: %@, error: %@", modelNumber, firmwareRevision, serialPortCommunicator, error);
        if (error) {
            completionHandler(error);
            return;
        }
        self.model = [ZBStandModelNumberParser standModelForModelNumberString:modelNumber];
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
                    [self.printer macroDefinitionStartStopWithCompletion:^(NSError *error) {
                        [self.printer printText:@"_" completion:^(NSError *error) {
                            [self.printer macroDefinitionStartStopWithCompletion:^(NSError *error) {
                                [self.printer enableAutomaticStatusBackForChangingDrawerSensorStatus:YES printerInformation:NO errorStatus:YES paperSensorInformation:YES presenterInformation:NO completion:completionHandler];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - Internals

- (ZBSerialPortNumber)targetPortNumberForPrinterOnStandModel:(ZBStandModel)model {
    switch (model) {
        case ZBStandModelT605: return ZBSerialPortNumberThree; break;
        case ZBStandModelUnknown: return ZBSerialPortNumberThree; break;
    }
}

- (void)initializePrinterWithCompletion:(void(^)(NSError *error))completion {
    self.printer = [[ZBPrinter alloc] initWithSerialPortCommunicator:self.serialPortCommunicator portNumber:[self targetPortNumberForPrinterOnStandModel:self.model]];
    [self.printer send512ZeroBytesWithCompletion:nil]; // This is due to some bug on the logic board, the first many bytes received are lost.
    [self.printer initializeHardwareWithCompletion:completion];
}

- (void)ensurePrinterConfigurationWithCompletion:(void(^)(NSError *error))completion {
    ZBPrinterFunctionSettings *appropriateFunctionSettings = [ZBPrinterFunctionSettings functionSettingsForStandModel:self.model];
    [self.printer functionSettingsWithCompletion:^(ZBPrinterFunctionSettings *functionSettings, NSError *error) {
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

- (ZBPeripheralController *)peripheralController {
    return objc_getAssociatedObject(self, @selector(peripheralController));
}

- (ZBSerialPortCommunicator *)serialPortCommunicator {
    return objc_getAssociatedObject(self, @selector(serialPortCommunicator));
}

- (void (^)(NSError *))prepareForUseCompletionHandler {
    return objc_getAssociatedObject(self, @selector(prepareForUseCompletionHandler));
}

- (ZBSerialPortConfigurator *)serialPortConfigurator {
    id serialPortConfigurator = objc_getAssociatedObject(self, @selector(serialPortConfigurator));
    if (!serialPortConfigurator) {
        serialPortConfigurator = [ZBSerialPortConfigurator new];
        self.serialPortConfigurator = serialPortConfigurator;
    }
    return serialPortConfigurator;
}

#pragma mark - Mutators

- (void)setPeripheral:(CBPeripheral *)peripheral {
    objc_setAssociatedObject(self, @selector(peripheral), peripheral, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPeripheralController:(ZBPeripheralController *)peripheralController {
    objc_setAssociatedObject(self, @selector(peripheralController), peripheralController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSerialPortCommunicator:(ZBSerialPortCommunicator *)serialPortCommunicator {
    objc_setAssociatedObject(self, @selector(serialPortCommunicator), serialPortCommunicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPrepareForUseCompletionHandler:(void (^)(NSError *))prepareForUseCompletionHandler {
    objc_setAssociatedObject(self, @selector(prepareForUseCompletionHandler), prepareForUseCompletionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setSerialPortConfigurator:(ZBSerialPortConfigurator *)serialPortConfigurator {
    objc_setAssociatedObject(self, @selector(serialPortConfigurator), serialPortConfigurator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
