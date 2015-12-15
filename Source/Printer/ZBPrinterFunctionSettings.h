//
//  ZBPrinterFunctionSettings.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 23/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZBPrinterPeripheralDevice) {
    ZBPrinterPeripheralDevicePesenterEnabled = 0,
    ZBPrinterPeripheralDeviceDrawerWinderEnabled = 1,
    ZBPrinterPeripheralDeviceDrawerEnabled = 2,
    ZBPrinterPeripheralDeviceDisabled = 3
};

typedef NS_ENUM(NSUInteger, ZBPrinterMarkSensor) {
    ZBPrinterMarkSensorPaper = 0,
    ZBPrinterMarkSensorOption = 1
};

typedef NS_ENUM(NSUInteger, ZBPrinterDivisionDriveMethod) {
    ZBPrinterDivisionDriveMethodFixed = 0,
    ZBPrinterDivisionDriveMethodDynamic = 1
};

typedef NS_ENUM(NSUInteger, ZBPrinterNumberOfDots) {
    ZBPrinterNumberOfDots72,
    ZBPrinterNumberOfDots144,
    ZBPrinterNumberOfDots288
};

typedef NS_ENUM(NSUInteger, ZBPrinterPrintSpeed) {
    ZBPrinterPrintSpeedNormal = 1,
    ZBPrinterPrintSpeedHigh = 0
};

typedef NS_ENUM(NSUInteger, ZBPrinterThermalPaper) {
    ZBPrinterThermalPaperTF50KSE2D = 0,
    ZBPrinterThermalPaperTP50KJR = 1,
    ZBPrinterThermalPaperPD160R63 = 3,
    ZBPrinterThermalPaperTL69KSLH = 4,
    ZBPrinterThermalPaperP220VBB1 = 5,
    ZBPrinterThermalPaperP300 = 6,
    ZBPrinterThermalPaperP350 = 7,
    ZBPrinterThermalPaperKIP370 = 8,
    ZBPrinterThermalPaperKIP470 = 9,
    ZBPrinterThermalPaperPD160RN = 10,
    ZBPrinterThermalPaperAF50KSE = 11,
    ZBPrinterThermalPaperAlpha90034 = 12,
    ZBPrinterThermalPaperKT55F20 = 13,
    ZBPrinterThermalPaperF5041 = 14,
    ZBPrinterThermalPaperKF50 = 15,
    ZBPrinterThermalPaperAP50KSD = 16,
    ZBPrinterThermalPaperKPR440 = 17,
    ZBPrinterThermalPaperAP50KSFZ = 18,
    ZBPrinterThermalPaperP5045 = 19,
    ZBPrinterThermalPaperHW54E = 20,
    ZBPrinterThermalPaperTL69KSHW76B = 21,
    ZBPrinterThermalPaperDTM9502 = 22
};

typedef NS_ENUM(NSUInteger, ZBPrinterCharacterSetType) {
    ZBPrinterCharacterSetTypeExtendedGraphics,
    ZBPrinterCharacterSetTypeKatakana1,
    ZBPrinterCharacterSetTypeCodepage1252,
    ZBPrinterCharacterSetTypeUserPage,
    ZBPrinterCharacterSetTypeKatakana2,
    ZBPrinterCharacterSetTypeBlankPage
};

@interface ZBPrinterFunctionSettings : NSObject

@property (copy, nonatomic, readonly) NSData *dataRepresentation;
@property (assign, nonatomic) BOOL autoCutterEnabled;
@property (assign, nonatomic) ZBPrinterPeripheralDevice peripheralDevice;
@property (assign, nonatomic) ZBPrinterMarkSensor markSensor;
@property (assign, nonatomic) BOOL paperNearEndSensorEnabled;
@property (assign, nonatomic) ZBPrinterDivisionDriveMethod divisionDriveMethod;
@property (assign, nonatomic) ZBPrinterNumberOfDots numberOfDots;
@property (assign, nonatomic) ZBPrinterPrintSpeed printSpeed;
@property (assign, nonatomic) BOOL markModeEnabled;
@property (assign, nonatomic) ZBPrinterThermalPaper thermalPaper;
@property (assign, nonatomic) NSUInteger printingDensity;
@property (assign, nonatomic) BOOL automaticStatusResponseEnabled;
@property (assign, nonatomic) BOOL discardPrintUponErrorEnabled;
@property (assign, nonatomic) BOOL CRModeInParallelCommunicationEnabled;
@property (assign, nonatomic) BOOL printerStopUponPaperNearEndEnabled;
@property (assign, nonatomic) BOOL initializeAZBerPaperSettingEnabled;
@property (assign, nonatomic) NSUInteger autoLoadingPaperFeedingLength;
@property (assign, nonatomic) NSInteger markPositionCorrection;
@property (assign, nonatomic) NSUInteger markDetectionMaximumFeedingLength;
@property (assign, nonatomic, readonly) ZBPrinterCharacterSetType characterSetType;
@property (assign, nonatomic) NSUInteger characterSet;

+ (BOOL)validateDataForInitialization:(NSData *)data;
+ (NSString *)stringForPeripheralDevice:(ZBPrinterPeripheralDevice)peripheralDevice;
+ (NSString *)stringForMarkSensor:(ZBPrinterMarkSensor)markSensor;
+ (NSString *)stringForDivisionDriveMethod:(ZBPrinterDivisionDriveMethod)divisionDriveMethod;
+ (NSString *)stringForNumberOfDots:(ZBPrinterNumberOfDots)numberOfDots;
+ (NSString *)stringForPrintSpeed:(ZBPrinterPrintSpeed)printSpeed;
+ (NSString *)stringForThermalPaper:(ZBPrinterThermalPaper)thermalPaper;
+ (NSString *)stringForCharacterSetType:(ZBPrinterCharacterSetType)characterSetType;

- (instancetype)initWithData:(NSData *)data;

@end
