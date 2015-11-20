//
//  FTPrinter+Private.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter+Private.h"
#import <objc/runtime.h>
#import "FTDebugging.h"

typedef NS_ENUM(NSUInteger, FTPrinterResponseType) {
    FTPrinterResponseTypeUnknown,
    FTPrinterResponseTypeStatusUpdate
};

@implementation FTPrinter (Private)

#pragma mark - Life Cycle

- (instancetype)initWithSerialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator portNumber:(FTSerialPortNumber)portNumber {
    self = [super init];
    if (self) {
        self.serialPortCommunicator = serialPortCommunicator;
        [self.serialPortCommunicator addObserver:self];
        self.portNumber = portNumber;
    }
    return self;
}

#pragma mark - FTSerialPortCommunicatorObserver

- (void)serialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator receivedData:(NSData *)data fromPortNumber:(FTSerialPortNumber)portNumber {
    if (portNumber != self.portNumber) {
        return;
    }
    FTLog(@"Received data: %@ from printer", data);
    switch ([self determineResponseTypeForData:data]) {
        case FTPrinterResponseTypeStatusUpdate: FTLog(@"Data is status update"); break;
        case FTPrinterResponseTypeUnknown: FTLog(@"Data is of unknown type"); break;
    }
}

#pragma mark - Internals

- (FTPrinterResponseType)determineResponseTypeForData:(NSData *)data {
    if ([self dataIsStatusUpdate:data]) {
        return FTPrinterResponseTypeStatusUpdate;
    }
    return FTPrinterResponseTypeUnknown;
}

- (BOOL)dataIsStatusUpdate:(NSData *)data {
    if (data.length != 4) {
        return NO;
    }
    unsigned char printerMechanismInformation;
    [data getBytes:&printerMechanismInformation range:NSMakeRange(0, 1)];
    if (((printerMechanismInformation ^ 0x81) & 0x91) != 0x91) {
        return NO;
    }
    unsigned char errorInformation;
    [data getBytes:&errorInformation range:NSMakeRange(1, 1)];
    if (((errorInformation ^ 0x90) & 0x90) != 0x90) {
        return NO;
    }
    unsigned char paperSensorInformation;
    [data getBytes:&paperSensorInformation range:NSMakeRange(2, 1)];
    if (((paperSensorInformation ^ 0x90) & 0x90) != 0x90) {
        return NO;
    }
    unsigned char presenterInformation;
    [data getBytes:&presenterInformation range:NSMakeRange(3, 1)];
    if (((presenterInformation ^ 0x90) & 0x90) != 0x90) {
        return NO;
    }
    return YES;
}

#pragma mark - Accessors

- (FTSerialPortCommunicator *)serialPortCommunicator {
    return objc_getAssociatedObject(self, @selector(serialPortCommunicator));
}

- (FTSerialPortNumber)portNumber {
    return [objc_getAssociatedObject(self, @selector(portNumber)) unsignedIntegerValue];
}

#pragma mark - Mutators

- (void)setSerialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator {
    objc_setAssociatedObject(self, @selector(serialPortCommunicator), serialPortCommunicator, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setPortNumber:(FTSerialPortNumber)portNumber {
    objc_setAssociatedObject(self, @selector(portNumber), @(portNumber), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
