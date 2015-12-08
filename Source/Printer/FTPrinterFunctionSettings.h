//
//  FTPrinterFunctionSettings.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 23/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FTPrinterPeripheralDevice) {
    FTPrinterPeripheralDevicePesenterEnabled = 0,
    FTPrinterPeripheralDeviceDrawerWinderEnabled = 1,
    FTPrinterPeripheralDeviceDrawerEnabled = 2,
    FTPrinterPeripheralDeviceDisabled = 3
};

typedef NS_ENUM(NSUInteger, FTPrinterMarkSensor) {
    FTPrinterMarkSensorPaper = 0,
    FTPrinterMarkSensorOption = 1
};

typedef NS_ENUM(NSUInteger, FTPrinterDivisionDriveMethod) {
    FTPrinterDivisionDriveMethodFixed = 0,
    FTPrinterDivisionDriveMethodDynamic = 1
};

typedef NS_ENUM(NSUInteger, FTPrinterNumberOfDots) {
    FTPrinterNumberOfDots72,
    FTPrinterNumberOfDots144,
    FTPrinterNumberOfDots288
};

typedef NS_ENUM(NSUInteger, FTPrinterPrintSpeed) {
    FTPrinterPrintSpeedNormal = 1,
    FTPrinterPrintSpeedHigh = 0
};

typedef NS_ENUM(NSUInteger, FTPrinterThermalPaper) {
    FTPrinterThermalPaperTF50KSE2D = 0,
    FTPrinterThermalPaperTP50KJR = 1,
    FTPrinterThermalPaperPD160R63 = 3,
    FTPrinterThermalPaperTL69KSLH = 4,
    FTPrinterThermalPaperP220VBB1 = 5,
    FTPrinterThermalPaperP300 = 6,
    FTPrinterThermalPaperP350 = 7,
    FTPrinterThermalPaperKIP370 = 8,
    FTPrinterThermalPaperKIP470 = 9,
    FTPrinterThermalPaperPD160RN = 10,
    FTPrinterThermalPaperAF50KSE = 11,
    FTPrinterThermalPaperAlpha90034 = 12,
    FTPrinterThermalPaperKT55F20 = 13,
    FTPrinterThermalPaperF5041 = 14,
    FTPrinterThermalPaperKF50 = 15,
    FTPrinterThermalPaperAP50KSD = 16,
    FTPrinterThermalPaperKPR440 = 17,
    FTPrinterThermalPaperAP50KSFZ = 18,
    FTPrinterThermalPaperP5045 = 19,
    FTPrinterThermalPaperHW54E = 20,
    FTPrinterThermalPaperTL69KSHW76B = 21,
    FTPrinterThermalPaperDTM9502 = 22
};

typedef NS_ENUM(NSUInteger, FTPrinterCharacterSetType) {
    FTPrinterCharacterSetTypeExtendedGraphics,
    FTPrinterCharacterSetTypeKatakana1,
    FTPrinterCharacterSetTypeCodepage1252,
    FTPrinterCharacterSetTypeUserPage,
    FTPrinterCharacterSetTypeKatakana2,
    FTPrinterCharacterSetTypeBlankPage
};

@interface FTPrinterFunctionSettings : NSObject

@property (copy, nonatomic, readonly) NSData *dataRepresentation;
@property (assign, nonatomic) BOOL autoCutterEnabled;
@property (assign, nonatomic) FTPrinterPeripheralDevice peripheralDevice;
@property (assign, nonatomic) FTPrinterMarkSensor markSensor;
@property (assign, nonatomic) BOOL paperNearEndSensorEnabled;
@property (assign, nonatomic) FTPrinterDivisionDriveMethod divisionDriveMethod;
@property (assign, nonatomic) FTPrinterNumberOfDots numberOfDots;
@property (assign, nonatomic) FTPrinterPrintSpeed printSpeed;
@property (assign, nonatomic) BOOL markModeEnabled;
@property (assign, nonatomic) FTPrinterThermalPaper thermalPaper;
@property (assign, nonatomic) NSUInteger printingDensity;
@property (assign, nonatomic) BOOL automaticStatusResponseEnabled;
@property (assign, nonatomic) BOOL discardPrintUponErrorEnabled;
@property (assign, nonatomic) BOOL CRModeInParallelCommunicationEnabled;
@property (assign, nonatomic) BOOL printerStopUponPaperNearEndEnabled;
@property (assign, nonatomic) BOOL initializeAfterPaperSettingEnabled;
@property (assign, nonatomic) NSUInteger autoLoadingPaperFeedingLength;
@property (assign, nonatomic) NSInteger markPositionCorrection;
@property (assign, nonatomic) NSUInteger markDetectionMaximumFeedingLength;
@property (assign, nonatomic, readonly) FTPrinterCharacterSetType characterSetType;
@property (assign, nonatomic) NSUInteger characterSet;

+ (BOOL)validateDataForInitialization:(NSData *)data;
+ (NSString *)stringForPeripheralDevice:(FTPrinterPeripheralDevice)peripheralDevice;
+ (NSString *)stringForMarkSensor:(FTPrinterMarkSensor)markSensor;
+ (NSString *)stringForDivisionDriveMethod:(FTPrinterDivisionDriveMethod)divisionDriveMethod;
+ (NSString *)stringForNumberOfDots:(FTPrinterNumberOfDots)numberOfDots;
+ (NSString *)stringForPrintSpeed:(FTPrinterPrintSpeed)printSpeed;
+ (NSString *)stringForThermalPaper:(FTPrinterThermalPaper)thermalPaper;
+ (NSString *)stringForCharacterSetType:(FTPrinterCharacterSetType)characterSetType;

- (instancetype)initWithData:(NSData *)data;

@end
