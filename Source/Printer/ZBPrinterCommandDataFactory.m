//
//  ZBPrinterCommandDataFactory.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 15/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterCommandDataFactory.h"
#import "NSData+ZBHex.h"
#import "ZBPrinter+HexCmd.h"

@implementation ZBPrinterCommandDataFactory

#pragma mark - Public Interface

+ (NSData *)commandDataForPrintText:(NSString *)text {
    return [text dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)commandDataForLineFeed {
    return [NSData dataWithHex:ZBPrinterHexCmdLineFeed];
}

+ (NSData *)commandDataForPrintReturningToStandardMode {
    return [NSData dataWithHex:ZBPrinterHexCmdPrintReturningToStandardModeOrMarkedPaperPrintFormFeeding];
}

+ (NSData *)commandDataForPageModePrint {
    return [NSData dataWithHex:ZBPrinterHexCmdPageModeDataPrint];
}

+ (NSData *)commandDataForPrintFeedingForwardBy:(NSUInteger)forward {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdPrintAndFeedForward];
    unsigned char forwardByte = forward;
    [command appendBytes:&forwardByte length:sizeof(forwardByte)];
    return command;
}

+ (NSData *)commandDataForLineSpacingSet:(NSUInteger)lineSpacing {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdLineSpacingSet];
    unsigned char lineSpacingByte = lineSpacing;
    [command appendBytes:&lineSpacingByte length:sizeof(lineSpacingByte)];
    return command;
}

+ (NSData *)commandDataForSetPrinterModeWithSettings:(ZBPrinterModeSettings)printerModeSettings {
    unsigned char mode = 0x00;
    switch (printerModeSettings.characterFont) {
        case ZBPrinterCharacterFont24x12: break;
        case ZBPrinterCharacterFont16x8: mode = mode | 0x01;
    }
    if (printerModeSettings.bold) {
        mode = mode | 0x08;
    }
    if (printerModeSettings.doubleHeight) {
        mode = mode | 0x10;
    }
    if (printerModeSettings.doubleWidth) {
        mode = mode | 0x20;
    }
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdPrintModeSelect];
    [command appendBytes:&mode length:sizeof(mode)];
    return command;
}

+ (NSData *)commandDataForSelectCharacterFont:(ZBPrinterCharacterFont)characterFont {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdCharacterFontSelect];
    unsigned char characterFontByte = characterFont;
    [command appendBytes:&characterFontByte length:sizeof(characterFontByte)];
    return command;
}

+ (NSData *)commandDataForSpecifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdCharacterSizeSpecify];
    unsigned char scaleByte = (verticalScale - 1) | ((horizontalScale - 1) << 4);
    [command appendBytes:&scaleByte length:sizeof(scaleByte)];
    return command;
}

+ (NSData *)commandDataForSetFlipEnabled:(BOOL)enableFlip {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdInversionFlipPrintingSpecifyCancel];
    unsigned char flipEnabledByte = enableFlip;
    [command appendBytes:&flipEnabledByte length:sizeof(flipEnabledByte)];
    return command;
}

+ (NSData *)commandDataForSelectPageMode {
    return [NSData dataWithHex:ZBPrinterHexCmdPageModeSelect];
}

+ (NSData *)commandDataForSetAlignment:(ZBPrinterAlignment)alignment {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdAlignment];
    unsigned char alignmentByte = alignment;
    [command appendBytes:&alignmentByte length:sizeof(alignmentByte)];
    return command;
}

+ (NSData *)commandDataForSpecifyCharacterPrintDirectionInPageMode:(ZBPrinterCharacterPrintDirection)cpd {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdCharacterPrintDirectionSpecifyInPageMade];
    unsigned char characterPrintDirectionByte = cpd;
    [command appendBytes:&characterPrintDirectionByte length:sizeof(characterPrintDirectionByte)];
    return command;
}

+ (NSData *)commandDataForPrintAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdPrintAreaSetInPageMode];
    unsigned char xByte = x % 255;
    unsigned char xMultiplierByte = floor(x / 255.0);
    [command appendBytes:&xByte length:sizeof(xByte)];
    [command appendBytes:&xMultiplierByte length:sizeof(xMultiplierByte)];
    unsigned char yByte = y % 255;
    unsigned char yMultiplierByte = floor(y / 255.0);
    [command appendBytes:&yByte length:sizeof(yByte)];
    [command appendBytes:&yMultiplierByte length:sizeof(yMultiplierByte)];
    unsigned char widthByte = width % 255;
    unsigned char widthMultiplierByte = floor(width / 255.0);
    [command appendBytes:&widthByte length:sizeof(widthByte)];
    [command appendBytes:&widthMultiplierByte length:sizeof(widthMultiplierByte)];
    unsigned char heightByte = height % 255;
    unsigned char heightMultiplierByte = floor(height / 255.0);
    [command appendBytes:&heightByte length:sizeof(heightByte)];
    [command appendBytes:&heightMultiplierByte length:sizeof(heightMultiplierByte)];
    return command;
}

+ (NSData *)commandDataForSpecifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdVerticalAbsolutePositionSpecifyInPageMode];
    unsigned char vapByte = vap % 255;
    unsigned char vapMultiplierByte = floor(vap / 255.0);
    [command appendBytes:&vapByte length:sizeof(vapByte)];
    [command appendBytes:&vapMultiplierByte length:sizeof(vapMultiplierByte)];
    return command;
}

+ (NSData *)commandDataForSpecifyHorizontalAbsolutePosition:(NSUInteger)hap {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdAbsolutePositionSpecify];
    unsigned char hapByte = hap % 255;
    unsigned char hapMultiplierByte = floor(hap / 255.0);
    [command appendBytes:&hapByte length:sizeof(hapByte)];
    [command appendBytes:&hapMultiplierByte length:sizeof(hapMultiplierByte)];
    return command;
}

+ (NSData *)commandDataForMacroDefinitionStartStop {
    return [NSData dataWithHex:ZBPrinterHexCmdMacroDefinitionStartStop];
}

+ (NSData *)commandDataForMacroExecutionWithExecutionCount:(NSUInteger)executionCount inBetweenDelayIn100ms:(NSUInteger)ibdi100ms {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdMacroExecution];
    unsigned char executionCountByte = executionCount;
    unsigned char inBetweenDelayByte = ibdi100ms;
    unsigned char stopByte = 0;
    [command appendBytes:&executionCountByte length:sizeof(executionCountByte)];
    [command appendBytes:&inBetweenDelayByte length:sizeof(inBetweenDelayByte)];
    [command appendBytes:&stopByte length:sizeof(stopByte)];
    return command;
}

+ (NSData *)commandDataForEnablePrinter:(BOOL)enable {
    unsigned char value = enable;
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdPeripheralEquipmentSelection];
    [command appendBytes:&value length:sizeof(value)];
    return command;
}

+ (NSData *)commandDataForInitializeHardware {
    return [NSData dataWithHex:ZBPrinterHexCmdPrinterInitialize];
}

+ (NSData *)commandDataForCutPaperAfterFeedingForwardBy:(NSUInteger)forward mode:(ZBPrinterPaperCutMode)mode {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdPaperCut];
    unsigned char modeByte;
    switch (mode) {
        case ZBPrinterPaperCutModeFull: modeByte = forward > 0 ? 65 : 0; break;
        case ZBPrinterPaperCutModePartial: modeByte = forward > 0 ? 66 : 1; break;
    }
    [command appendBytes:&modeByte length:sizeof(modeByte)];
    if (forward > 0) {
        unsigned char forwardByte = forward;
        [command appendBytes:&forwardByte length:sizeof(forwardByte)];
    }
    return command;
}

+ (NSData *)commandDataForSetFunctionSettings:(ZBPrinterFunctionSettings *)functionSettings storing:(BOOL)storing {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdFunctionSettingsChange];
    unsigned char functionByte = storing ? 0x80 : 0x00;
    [command appendBytes:&functionByte length:sizeof(functionByte)];
    [command appendData:functionSettings.dataRepresentation];
    unsigned char endByte = 0x00;
    [command appendBytes:&endByte length:sizeof(endByte)];
    return command;
}

+ (NSData *)commandDataForFunctionSettings {
    return [NSData dataWithHex:ZBPrinterHexCmdFunctionSettingResponse];
}

+ (NSData *)commandDataForSetAutomaticStatusBackWithSettings:(ZBPrinterAutomaticStatusBackSettings)automaticStatusBackSettings {
    unsigned char automaticStatusBack = 0x00;
    automaticStatusBack |= automaticStatusBackSettings.changingDrawerSensorStatus;
    automaticStatusBack |= automaticStatusBackSettings.printerInformation << 1;
    automaticStatusBack |= automaticStatusBackSettings.errorStatus << 2;
    automaticStatusBack |= automaticStatusBackSettings.paperSensorInformation << 3;
    automaticStatusBack |= automaticStatusBackSettings.presenterInformation << 4;
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdAutomaticStatusBackEnableDisable];
    [command appendBytes:&automaticStatusBack length:sizeof(automaticStatusBack)];
    return command;
}

@end
