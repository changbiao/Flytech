//
//  FTPrinterStatusUpdate.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 26/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinterStatusUpdate.h"

@interface FTPrinterStatusUpdate ()

@property (copy, nonatomic) NSData *data;

@end

@implementation FTPrinterStatusUpdate

#pragma mark - Public Class Interface

+ (BOOL)validateDataForInitialization:(NSData *)data {
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

+ (NSString *)stringForPaperFeedMotorDriveStatus:(FTPrinterStatusPaperFeedMotorDrive)paperFeedMotorDriveStatus {
    switch (paperFeedMotorDriveStatus) {
        case FTPrinterStatusPaperFeedMotorDriveStop: return @"Stop"; break;
        case FTPrinterStatusPaperFeedMotorDriveWork: return @"Work"; break;
    }
}

+ (NSString *)stringForDrawerSensorStatus:(FTPrinterStatusDrawerSensor)drawerSensorStatus {
    switch (drawerSensorStatus) {
        case FTPrinterStatusDrawerSensorLow: return @"Low"; break;
        case FTPrinterStatusDrawerSensorHigh: return @"High"; break;
    }
}

#pragma mark - Initialization

- (instancetype)initWithData:(NSData *)data {
    self = [[self class] validateDataForInitialization:data] ? [super init] : nil;
    if (self) {
        self.data = data;
        [self setPropertiesAccordingToData:data];
    }
    return self;
}

#pragma mark - Data Parsing

- (void)setPropertiesAccordingToData:(NSData *)data {
    unsigned char printerMechanismInformation;
    [data getBytes:&printerMechanismInformation range:NSMakeRange(0, 1)];
    [self setPrinterMechanismInformationPropertiesAccordingToByte:printerMechanismInformation];
    unsigned char errorInformation;
    [data getBytes:&errorInformation range:NSMakeRange(1, 1)];
    [self setErrorInformationPropertiesAccordingToByte:errorInformation];
    unsigned char paperSensorInformation;
    [data getBytes:&paperSensorInformation range:NSMakeRange(2, 1)];
    [self setPaperSensorInformationPropertiesAccordingToByte:paperSensorInformation];
    unsigned char presenterInformation;
    [data getBytes:&presenterInformation range:NSMakeRange(3, 1)];
    [self setPresenterInformationPropertiesAccordingToByte:presenterInformation];
}

- (void)setPrinterMechanismInformationPropertiesAccordingToByte:(unsigned char)byte {
    self.paperFeedMotorDriveStatus = (byte >> 1) & 0x01;
    self.drawerSensorStatus = (byte >> 2) & 0x01;
    self.coverOpen = (byte >> 5) & 0x01;
    self.paperFeedingBySwitch = (byte >> 6) & 0x01;
}

- (void)setErrorInformationPropertiesAccordingToByte:(unsigned char)byte {
    self.paperJammedWhileDetectingMark = (byte >> 2) & 0x01;
    self.autoCutterErrorEncountered = (byte >> 3) & 0x01;
    self.headOrVoltageErrorEncountered = (byte >> 5) & 0x01;
    self.willRecoverFromErrorAutomatically = (byte >> 6) & 0x01;
}

- (void)setPaperSensorInformationPropertiesAccordingToByte:(unsigned char)byte {
    self.paperNearEndDetected = byte & 0x01;
    self.outOfPaperDetected = (byte >> 2) & 0x01;
    self.markDetected = (byte >> 6) & 0x01;
}

- (void)setPresenterInformationPropertiesAccordingToByte:(unsigned char)byte {
    self.paperDetected = byte & 0x01;
    self.paperFeedErrorEncountered = (byte >> 2) & 0x01;
    self.paperJamErrorEncountered = (byte >> 5) & 0x01;
}

#pragma mark - Overrides

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"Status Update Data: %@\n", self.data];
    [description appendFormat:@"%@\n", [self descriptionForPrinterMechanismInformation]];
    [description appendFormat:@"%@\n", [self descriptionForErrorInformation]];
    [description appendFormat:@"%@\n", [self descriptionForPaperSensorInformation]];
    [description appendFormat:@"%@", [self descriptionForPresenterInformation]];
    return description;
}

#pragma mark - Description Helpers

- (NSString *)descriptionForPrinterMechanismInformation {
    NSString *paperFeedMotorDriveStatus = [[self class] stringForPaperFeedMotorDriveStatus:self.paperFeedMotorDriveStatus];
    NSString *drawerSensorStatus = [[self class] stringForDrawerSensorStatus:self.drawerSensorStatus];
    NSString *coverOpen = self.coverOpen ? @"YES" : @"NO";
    NSString *paperFeedingBySwitch = self.paperFeedingBySwitch ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"Paper mechanism information | Paper feed motor drive status: %@, Drawer sensor status: %@, Cover open: %@, Paper feeding by switch: %@", paperFeedMotorDriveStatus, drawerSensorStatus, coverOpen, paperFeedingBySwitch];
}

- (NSString *)descriptionForErrorInformation {
    NSString *paperJammedWhileDetectingMark = self.paperJammedWhileDetectingMark ? @"YES" : @"NO";
    NSString *autoCutterErrorEncountered = self.autoCutterErrorEncountered ? @"YES" : @"NO";
    NSString *headOrVoltageErrorEncountered = self.headOrVoltageErrorEncountered ? @"YES" : @"NO";
    NSString *willRecoverFromErrorAutomatically = self.willRecoverFromErrorAutomatically ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"Error information | Paper jammed while detecting mark: %@, Auto cutter error encountered: %@, Head or voltage error encountered: %@, Will recover from error automatically: %@", paperJammedWhileDetectingMark, autoCutterErrorEncountered, headOrVoltageErrorEncountered, willRecoverFromErrorAutomatically];
}

- (NSString *)descriptionForPaperSensorInformation {
    NSString *paperNearEndDetected = self.paperNearEndDetected ? @"YES" : @"NO";
    NSString *outOfPaperDetected = self.outOfPaperDetected ? @"YES" : @"NO";
    NSString *markDetected = self.markDetected ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"Paper sensor information | Paper near end detected: %@, Out of paper detected: %@, Mark detected: %@", paperNearEndDetected, outOfPaperDetected, markDetected];
}

- (NSString *)descriptionForPresenterInformation {
    NSString *paperDetected = self.paperDetected ? @"YES" : @"NO";
    NSString *paperFeedErrorEncountered = self.paperFeedErrorEncountered ? @"YES" : @"NO";
    NSString *paperJamErrorEncountered = self.paperJamErrorEncountered ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"Presenter information | Paper detected: %@, Paper feed error encountered: %@, Paper jam error encountered: %@", paperDetected, paperFeedErrorEncountered, paperJamErrorEncountered];
}

@end
