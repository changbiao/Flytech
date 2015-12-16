//
//  ZBPrinterFunctionSettings.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 23/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterFunctionSettings.h"
#import "ZBDebugging.h"
#import "NSData+ZBHex.h"

@implementation ZBPrinterFunctionSettings

#pragma mark - Public Class Interface

+ (BOOL)validateDataForInitialization:(NSData *)data {
    if (data.length != 80) {
        return NO;
    }
    const unsigned char *bytes = data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        if (bytes[i] >> 4 != 0x00) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)stringForPeripheralDevice:(ZBPrinterPeripheralDevice)peripheralDevice {
    switch (peripheralDevice) {
        case ZBPrinterPeripheralDeviceDisabled: return @"Disabled"; break;
        case ZBPrinterPeripheralDevicePesenterEnabled: return @"Presenter enabled"; break;
        case ZBPrinterPeripheralDeviceDrawerEnabled: return @"Drawer enabled"; break;
        case ZBPrinterPeripheralDeviceDrawerWinderEnabled: return @"Drawer/winder enabled"; break;
    }
}

+ (NSString *)stringForMarkSensor:(ZBPrinterMarkSensor)markSensor {
    switch (markSensor) {
        case ZBPrinterMarkSensorPaper: return @"Paper"; break;
        case ZBPrinterMarkSensorOption: return @"Option"; break;
    }
}

+ (NSString *)stringForDivisionDriveMethod:(ZBPrinterDivisionDriveMethod)divisionDriveMethod {
    switch (divisionDriveMethod) {
        case ZBPrinterDivisionDriveMethodDynamic: return @"Dynamic"; break;
        case ZBPrinterDivisionDriveMethodFixed: return @"Fixed"; break;
    }
}

+ (NSString *)stringForNumberOfDots:(ZBPrinterNumberOfDots)numberOfDots {
    switch (numberOfDots) {
        case ZBPrinterNumberOfDots72: return @"72"; break;
        case ZBPrinterNumberOfDots144: return @"144"; break;
        case ZBPrinterNumberOfDots288: return @"288"; break;
    }
}

+ (NSString *)stringForPrintSpeed:(ZBPrinterPrintSpeed)printSpeed {
    switch (printSpeed) {
        case ZBPrinterPrintSpeedNormal: return @"Normal"; break;
        case ZBPrinterPrintSpeedHigh: return @"High"; break;
    }
}

+ (NSString *)stringForThermalPaper:(ZBPrinterThermalPaper)thermalPaper {
    switch (thermalPaper) {
        case ZBPrinterThermalPaperAF50KSE: return @"AF50KSE"; break;
        case ZBPrinterThermalPaperAlpha90034: return @"Alpha90034"; break;
        case ZBPrinterThermalPaperAP50KSD: return @"AP50KSD"; break;
        case ZBPrinterThermalPaperAP50KSFZ: return @"AP50KSFZ"; break;
        case ZBPrinterThermalPaperDTM9502: return @"DTM9502"; break;
        case ZBPrinterThermalPaperF5041: return @"F5041"; break;
        case ZBPrinterThermalPaperHW54E: return @"HW54E"; break;
        case ZBPrinterThermalPaperKF50: return @"KF50"; break;
        case ZBPrinterThermalPaperKIP370: return @"KIP370"; break;
        case ZBPrinterThermalPaperKIP470: return @"KIP470"; break;
        case ZBPrinterThermalPaperKPR440: return @"KPR440"; break;
        case ZBPrinterThermalPaperKT55F20: return @"KT55F20"; break;
        case ZBPrinterThermalPaperP220VBB1: return @"P220VBB1"; break;
        case ZBPrinterThermalPaperP300: return @"P300"; break;
        case ZBPrinterThermalPaperP350: return @"P350"; break;
        case ZBPrinterThermalPaperP5045: return @"P5045"; break;
        case ZBPrinterThermalPaperPD160R63: return @"PD160R63"; break;
        case ZBPrinterThermalPaperPD160RN: return @"PD160RN"; break;
        case ZBPrinterThermalPaperTF50KSE2D: return @"TF50KSE2D"; break;
        case ZBPrinterThermalPaperTL69KSHW76B: return @"TL69KSHW76B"; break;
        case ZBPrinterThermalPaperTP50KJR: return @"TP50KJR"; break;
        case ZBPrinterThermalPaperTL69KSLH: return @"TL69KSLH"; break;
    }
}

+ (NSString *)stringForCharacterSetType:(ZBPrinterCharacterSetType)characterSetType {
    switch (characterSetType) {
        case ZBPrinterCharacterSetTypeBlankPage: return @"Blank page"; break;
        case ZBPrinterCharacterSetTypeCodepage1252: return @"Codepage 1252"; break;
        case ZBPrinterCharacterSetTypeExtendedGraphics: return @"Extended graphics"; break;
        case ZBPrinterCharacterSetTypeKatakana1: return @"Katakana 1"; break;
        case ZBPrinterCharacterSetTypeKatakana2: return @"Katakana 2"; break;
        case ZBPrinterCharacterSetTypeUserPage: return @"User page"; break;
    }
}

#pragma mark - Life Cycle

- (instancetype)initWithData:(NSData *)data {
    self = [ZBPrinterFunctionSettings validateDataForInitialization:data] ? [super init] : nil;
    if (self) {
        NSData *relevantData = [self extractDataFromResponseData:data];
        [self setPropertiesAccordingToData:relevantData];
    }
    return self;
}

#pragma mark - Public Interface

- (NSData *)dataRepresentation {
    NSMutableData *data = [NSMutableData dataWithCapacity:40];
    [data appendData:[self dataForSWDIP1]];
    [data appendData:[self dataForSWDIP2]];
    [data appendData:[self dataForSWDIP3]];
    [data appendData:[self dataForSWDIP4]];
    [data appendData:[self dataForSWDIP5]];
    [data appendData:[self dataForSWDIP6To7]];
    [data appendData:[self dataForSWDIP8To9]];
    [data appendData:[self dataForSWDIP10To11]];
    [data appendData:[self dataForSWDIP12To34]];
    [data appendData:[self dataForSWDIP35]];
    [data appendData:[self dataForSWDIP36To40]];
    return data;
}

- (ZBPrinterCharacterSetType)characterSetType {
    switch (self.characterSet) {
        case 0: return ZBPrinterCharacterSetTypeExtendedGraphics; break;
        case 1: return ZBPrinterCharacterSetTypeKatakana1; break;
        case 16: return ZBPrinterCharacterSetTypeCodepage1252; break;
        case 254: return ZBPrinterCharacterSetTypeKatakana2; break;
        case 255: return ZBPrinterCharacterSetTypeBlankPage; break;
        default: return ZBPrinterCharacterSetTypeUserPage;
    }
}

#pragma mark - Data Generation

- (NSData *)dataForSWDIP1 {
    unsigned char swdip1 = 0xC8;
    swdip1 |= !self.autoCutterEnabled;
    swdip1 |= self.peripheralDevice << 1;
    swdip1 |= self.markSensor << 4;
    swdip1 |= !self.paperNearEndSensorEnabled << 5;
    return [NSData dataWithBytes:&swdip1 length:sizeof(swdip1)];
}

- (NSData *)dataForSWDIP2 {
    unsigned char swdip2 = 0xE8;
    swdip2 |= self.divisionDriveMethod;
    swdip2 |= self.numberOfDots << 1;
    swdip2 |= self.printSpeed << 4;
    return [NSData dataWithBytes:&swdip2 length:sizeof(swdip2)];
}

- (NSData *)dataForSWDIP3 {
    unsigned char swdip3 = 0xC0;
    swdip3 |= !self.markModeEnabled;
    swdip3 |= self.thermalPaper << 1;
    return [NSData dataWithBytes:&swdip3 length:sizeof(swdip3)];
}

- (NSData *)dataForSWDIP4 {
    unsigned char swdip4 = self.printingDensity;
    return [NSData dataWithBytes:&swdip4 length:sizeof(swdip4)];
}

- (NSData *)dataForSWDIP5 {
    unsigned char swdip5 = 0xE0;
    swdip5 |= !self.automaticStatusResponseEnabled;
    swdip5 |= !self.discardPrintUponErrorEnabled << 1;
    swdip5 |= !self.CRModeInParallelCommunicationEnabled << 2;
    swdip5 |= !self.printerStopUponPaperNearEndEnabled << 3;
    swdip5 |= !self.initializeAfterPaperSettingEnabled << 4;
    return [NSData dataWithBytes:&swdip5 length:sizeof(swdip5)];
}

- (NSData *)dataForSWDIP6To7 {
    unsigned short swdip6To7 = self.autoLoadingPaperFeedingLength;
    return [NSData dataWithBytes:&swdip6To7 length:sizeof(swdip6To7)];
}

- (NSData *)dataForSWDIP8To9 {
    signed short swdip8To9 = self.markPositionCorrection;
    return [NSData dataWithBytes:&swdip8To9 length:sizeof(swdip8To9)];
}

- (NSData *)dataForSWDIP10To11 {
    unsigned short swdip10To11 = self.markDetectionMaximumFeedingLength;
    return [NSData dataWithBytes:&swdip10To11 length:sizeof(swdip10To11)];
}

- (NSData *)dataForSWDIP12To34 {
    return [NSData dataWithHex:@"96000500 2C01E803 2C018813 881304FF FFFFFFFF FFFFFF"];
}

- (NSData *)dataForSWDIP35 {
    unsigned char swdip35 = self.characterSet;
    return [NSData dataWithBytes:&swdip35 length:sizeof(swdip35)];
}

- (NSData *)dataForSWDIP36To40 {
    return [NSData dataWithHex:@"FFFFFFFF FF"];
}

#pragma mark - Parsing

- (NSData *)extractDataFromResponseData:(NSData *)data {
    NSMutableData *extractedData = [NSMutableData dataWithCapacity:40];
    NSData *remainingData = data;
    while (remainingData) {
        unsigned char lowFourBits;
        unsigned char highFourBits;
        [remainingData getBytes:&lowFourBits range:NSMakeRange(0, 1)];
        [remainingData getBytes:&highFourBits range:NSMakeRange(1, 1)];
        unsigned char resultingByte = lowFourBits | (highFourBits << 4);
        [extractedData appendBytes:&resultingByte length:sizeof(resultingByte)];
        remainingData = remainingData.length > 2 ? [remainingData subdataWithRange:NSMakeRange(2, remainingData.length - 2)] : nil;
    }
    return extractedData;
}

- (void)setPropertiesAccordingToData:(NSData *)data {
    unsigned char swdip1;
    [data getBytes:&swdip1 range:NSMakeRange(0, 1)];
    [self setSWDIP1PropertiesAccordingToByte:swdip1];
    unsigned char swdip2;
    [data getBytes:&swdip2 range:NSMakeRange(1, 1)];
    [self setSWDIP2PropertiesAccordingToByte:swdip2];
    unsigned char swdip3;
    [data getBytes:&swdip3 range:NSMakeRange(2, 1)];
    [self setSWDIP3PropertiesAccordingToByte:swdip3];
    unsigned char swdip4;
    [data getBytes:&swdip4 range:NSMakeRange(3, 1)];
    [self setSWDIP4PropertiesAccordingToByte:swdip4];
    unsigned char swdip5;
    [data getBytes:&swdip5 range:NSMakeRange(4, 1)];
    [self setSWDIP5PropertiesAccordingToByte:swdip5];
    unsigned char swip6To7[2];
    [data getBytes:swip6To7 range:NSMakeRange(5, 2)];
    [self setSWDIP6To7PropertiesAccordingToBytes:swip6To7];
    char swdip8To9[2];
    [data getBytes:swdip8To9 range:NSMakeRange(7, 2)];
    [self setSWDIP8To9PropertiesAccordingToBytes:swdip8To9];
    unsigned char swdip10To11[2];
    [data getBytes:swdip10To11 range:NSMakeRange(9, 2)];
    [self setSWDIP10To11PropertiesAccordingToBytes:swdip10To11];
    unsigned char swdip35;
    [data getBytes:&swdip35 range:NSMakeRange(34, 1)];
    [self setSWDIP35PropertiesAccordingToByte:swdip35];
}

- (void)setSWDIP1PropertiesAccordingToByte:(unsigned char)byte {
    self.autoCutterEnabled = (byte & 0x01) == 0;
    self.peripheralDevice = (byte >> 1) & 0x03;
    self.markSensor = (byte >> 3) & 0x01;
    self.paperNearEndSensorEnabled = (byte & 0x20) == 0;
}

- (void)setSWDIP2PropertiesAccordingToByte:(unsigned char)byte {
    self.divisionDriveMethod = byte & 0x01;
    unsigned char numberOfDots = (byte & 0x06) >> 1;
    switch (numberOfDots) {
        case 0x00: self.numberOfDots = ZBPrinterNumberOfDots72; break;
        case 0x01: self.numberOfDots = ZBPrinterNumberOfDots144; break;
        case 0x02: self.numberOfDots = ZBPrinterNumberOfDots288; break;
        case 0x03: self.numberOfDots = ZBPrinterNumberOfDots144; break;
    }
    self.printSpeed = (byte & 0x10) >> 4;
}

- (void)setSWDIP3PropertiesAccordingToByte:(unsigned char)byte {
    self.markModeEnabled = (byte & 0x01) == 0x00;
    self.thermalPaper = (byte & 0x3E) >> 1;
}

- (void)setSWDIP4PropertiesAccordingToByte:(unsigned char)byte {
    self.printingDensity = byte;
}

- (void)setSWDIP5PropertiesAccordingToByte:(unsigned char)byte {
    self.automaticStatusResponseEnabled = (byte & 0x01) == 0;
    self.discardPrintUponErrorEnabled = ((byte & 0x02) >> 1) == 0;
    self.CRModeInParallelCommunicationEnabled = ((byte & 0x04) >> 2) == 0;
    self.printerStopUponPaperNearEndEnabled = ((byte & 0x08) >> 3) == 0;
    self.initializeAfterPaperSettingEnabled = ((byte & 0x10) >> 4) == 0;
}

- (void)setSWDIP6To7PropertiesAccordingToBytes:(unsigned char[2])bytes {
    self.autoLoadingPaperFeedingLength = bytes[0] | bytes[1] << 8;
}

- (void)setSWDIP8To9PropertiesAccordingToBytes:(char[2])bytes {
    self.markPositionCorrection = bytes[0] | bytes[1] << 8;
}

- (void)setSWDIP10To11PropertiesAccordingToBytes:(unsigned char[2])bytes {
    self.markDetectionMaximumFeedingLength = bytes[0] | bytes[1] << 8;
}

- (void)setSWDIP35PropertiesAccordingToByte:(unsigned char)byte {
    self.characterSet = byte;
}

#pragma mark - Overrides

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"Function settings data: %@\n", self.dataRepresentation];
    [description appendFormat:@"%@\n", [self descriptionForSWDIP1]];
    [description appendFormat:@"%@\n", [self descriptionForSWDIP2]];
    [description appendFormat:@"%@\n", [self descriptionForSWDIP3]];
    [description appendFormat:@"%@\n", [self descriptionForSWDIP4]];
    [description appendFormat:@"%@\n", [self descriptionForSWDIP5]];
    [description appendFormat:@"%@\n", [self descriptionForSWDIP6To7]];
    [description appendFormat:@"%@\n", [self descriptionForSWDIP8To9]];
    [description appendFormat:@"%@\n", [self descriptionForSWDIP10To11]];
    [description appendFormat:@"%@\n", [self descriptionForSWDIP35]];
    return description;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    } else if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    ZBPrinterFunctionSettings *other = object;
    return [self.dataRepresentation isEqualToData:other.dataRepresentation];
}

#pragma mark - Description Helpers

- (NSString *)descriptionForSWDIP1 {
    NSString *autoCutterEnabled = [NSString stringWithFormat:@"Auto cutter enabled: %@", self.autoCutterEnabled ? @"YES" : @"NO"];
    NSString *peripheralDevice = [NSString stringWithFormat:@"Peripheral device: %@", [[self class] stringForPeripheralDevice:self.peripheralDevice]];
    NSString *markSensor = [NSString stringWithFormat:@"Mark sensor: %@", [[self class] stringForMarkSensor:self.markSensor]];
    NSString *paperNearEndSensorEnabled = [NSString stringWithFormat:@"Paper near end sensor enabled: %@", self.paperNearEndSensorEnabled ? @"YES" : @"NO"];
    NSArray *components = @[ autoCutterEnabled, peripheralDevice, markSensor, paperNearEndSensorEnabled ];
    return [NSString stringWithFormat:@"SWDIP1 | %@", [components componentsJoinedByString:@", "]];
}

- (NSString *)descriptionForSWDIP2 {
    NSString *divisionDriveMethod = [NSString stringWithFormat:@"Division drive method: %@", [[self class] stringForDivisionDriveMethod:self.divisionDriveMethod]];
    NSString *numberOfDots = [NSString stringWithFormat:@"Number of dots: %@", [[self class] stringForNumberOfDots:self.numberOfDots]];
    NSString *printSpeed = [NSString stringWithFormat:@"Print speed: %@", [[self class] stringForPrintSpeed:self.printSpeed]];
    NSArray *componenets = @[ divisionDriveMethod, numberOfDots, printSpeed ];
    return [NSString stringWithFormat:@"SWDIP2 | %@", [componenets componentsJoinedByString:@", "]];
}

- (NSString *)descriptionForSWDIP3 {
    NSString *markModeEnabled = [NSString stringWithFormat:@"Mark mode enabled: %@", self.markModeEnabled ? @"YES" : @"NO"];
    NSString *thermalPaper = [NSString stringWithFormat:@"Thermal paper: %@", [[self class] stringForThermalPaper:self.thermalPaper]];
    NSArray *components = @[ markModeEnabled, thermalPaper ];
    return [NSString stringWithFormat:@"SWDIP3 | %@", [components componentsJoinedByString:@", "]];
}

- (NSString *)descriptionForSWDIP4 {
    NSString *printingDensity = [NSString stringWithFormat:@"Printing density: %ld", (unsigned long)self.printingDensity];
    return [NSString stringWithFormat:@"SWDIP4 | %@", printingDensity];
}

- (NSString *)descriptionForSWDIP5 {
    NSString *automaticStatusResponseEnabled = [NSString stringWithFormat:@"Automatic status response enabled: %@", self.automaticStatusResponseEnabled ? @"YES" : @"NO"];
    NSString *discardPrintUponErrorEnabled = [NSString stringWithFormat:@"Discard print upon error enabled: %@", self.discardPrintUponErrorEnabled ? @"YES" : @"NO"];
    NSString *CRModeInParallelCommunicationEnabled = [NSString stringWithFormat:@"CR mode in parallel communication enabled: %@", self.CRModeInParallelCommunicationEnabled ? @"YES" : @"NO"];
    NSString *printerStopUponPaperNearEndEnabled = [NSString stringWithFormat:@"Printer stop upon paper near end enabled: %@", self.printerStopUponPaperNearEndEnabled ? @"YES" : @"NO"];
    NSString *initializeAfterPaperSettingEnabled = [NSString stringWithFormat:@"Initialize after paper setting enabled: %@", self.initializeAfterPaperSettingEnabled ? @"YES" : @"NO"];
    NSArray *components = @[ automaticStatusResponseEnabled, discardPrintUponErrorEnabled, CRModeInParallelCommunicationEnabled, printerStopUponPaperNearEndEnabled, initializeAfterPaperSettingEnabled ];
    return [NSString stringWithFormat:@"SWDIP5 | %@", [components componentsJoinedByString:@", "]];
}

- (NSString *)descriptionForSWDIP6To7 {
    NSString *autoLoadingPaperFeedLength = [NSString stringWithFormat:@"Auto loading paper feed length: %ld", (unsigned long)self.autoLoadingPaperFeedingLength];
    return [NSString stringWithFormat:@"SWDIP6 to 7 | %@", autoLoadingPaperFeedLength];
}

- (NSString *)descriptionForSWDIP8To9 {
    NSString *markPositionCorrection = [NSString stringWithFormat:@"Mark position correction: %ld", (long)self.markPositionCorrection];
    return [NSString stringWithFormat:@"SWDIP8 to 9 | %@", markPositionCorrection];
}

- (NSString *)descriptionForSWDIP10To11 {
    NSString *markDetectionMaximumFeedingLength = [NSString stringWithFormat:@"Mark detection maximum feeding length: %ld", (unsigned long)self.markDetectionMaximumFeedingLength];
    return [NSString stringWithFormat:@"SWDIP10 to 11 | %@", markDetectionMaximumFeedingLength];
}

- (NSString *)descriptionForSWDIP35 {
    NSString *characterSet = [NSString stringWithFormat:@"Character set: %ld (%@)", (unsigned long)self.characterSet, [[self class] stringForCharacterSetType:self.characterSetType]];
    return [NSString stringWithFormat:@"SWDIP35 | %@", characterSet];
}

@end
