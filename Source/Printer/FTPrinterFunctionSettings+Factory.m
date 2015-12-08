//
//  FTPrinterFunctionSettings+Factory.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 26/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinterFunctionSettings+Factory.h"

@implementation FTPrinterFunctionSettings (Factory)

#pragma mark - Public Interface

+ (instancetype)functionSettingsForStandModel:(FTStandModel)standModel {
    switch (standModel) {
        case FTStandModelT605: return [self functionSettingsForStandModelT605]; break;
        case FTStandModelUnknown: return [self defaultFunctionSettings]; break;
    }
}

#pragma mark - Internals

+ (instancetype)defaultFunctionSettings {
    FTPrinterFunctionSettings *functionSettings = [FTPrinterFunctionSettings new];
    functionSettings.autoCutterEnabled = YES;
    functionSettings.peripheralDevice = FTPrinterPeripheralDeviceDrawerEnabled;
    functionSettings.markSensor = FTPrinterMarkSensorOption;
    functionSettings.paperNearEndSensorEnabled = YES;
    functionSettings.divisionDriveMethod = FTPrinterDivisionDriveMethodDynamic;
    functionSettings.numberOfDots = FTPrinterNumberOfDots144;
    functionSettings.printSpeed = FTPrinterPrintSpeedNormal;
    functionSettings.markModeEnabled = NO;
    functionSettings.thermalPaper = FTPrinterThermalPaperTF50KSE2D;
    functionSettings.printingDensity = 100;
    functionSettings.automaticStatusResponseEnabled = NO;
    functionSettings.discardPrintUponErrorEnabled = NO;
    functionSettings.CRModeInParallelCommunicationEnabled = NO;
    functionSettings.printerStopUponPaperNearEndEnabled = NO;
    functionSettings.initializeAfterPaperSettingEnabled = YES;
    functionSettings.autoLoadingPaperFeedingLength = 80;
    functionSettings.markPositionCorrection = 0;
    functionSettings.markDetectionMaximumFeedingLength = 500;
    functionSettings.characterSet = 255;
    return functionSettings;
}

+ (instancetype)functionSettingsForStandModelT605 {
    return [self defaultFunctionSettings];
}

@end
