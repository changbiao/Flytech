//
//  ZBPrinterFunctionSettings+Factory.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 26/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterFunctionSettings+Factory.h"

@implementation ZBPrinterFunctionSettings (Factory)

#pragma mark - Public Interface

+ (instancetype)functionSettingsForStandModel:(ZBStandModel)standModel {
    switch (standModel) {
        case ZBStandModelT605: return [self functionSettingsForStandModelT605]; break;
        case ZBStandModelUnknown: return [self defaultFunctionSettings]; break;
    }
}

#pragma mark - Internals

+ (instancetype)defaultFunctionSettings {
    ZBPrinterFunctionSettings *functionSettings = [ZBPrinterFunctionSettings new];
    functionSettings.autoCutterEnabled = YES;
    functionSettings.peripheralDevice = ZBPrinterPeripheralDeviceDrawerEnabled;
    functionSettings.markSensor = ZBPrinterMarkSensorOption;
    functionSettings.paperNearEndSensorEnabled = YES;
    functionSettings.divisionDriveMethod = ZBPrinterDivisionDriveMethodDynamic;
    functionSettings.numberOfDots = ZBPrinterNumberOfDots144;
    functionSettings.printSpeed = ZBPrinterPrintSpeedNormal;
    functionSettings.markModeEnabled = NO;
    functionSettings.thermalPaper = ZBPrinterThermalPaperTF50KSE2D;
    functionSettings.printingDensity = 100;
    functionSettings.automaticStatusResponseEnabled = NO;
    functionSettings.discardPrintUponErrorEnabled = NO;
    functionSettings.CRModeInParallelCommunicationEnabled = NO;
    functionSettings.printerStopUponPaperNearEndEnabled = NO;
    functionSettings.initializeAZBerPaperSettingEnabled = YES;
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
