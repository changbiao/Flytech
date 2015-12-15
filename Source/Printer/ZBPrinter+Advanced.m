//
//  ZBPrinter+Advanced.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 17/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinter+Advanced.h"
#import "ZBPrinter+Private.h"
#import "NSData+ZBHex.h"
#import "ZBPrinter+HexCmd.h"
#import "ZBDebugging.h"

@implementation ZBPrinter (Advanced)

#pragma mark - Public Interface

+ (NSData *)commandDataForInitializeHardware {
    return [NSData dataWithHex:ZBPrinterHexCmdPrinterInitialize];
}

+ (NSData *)commandDataForSelectPageMode {
    return [NSData dataWithHex:ZBPrinterHexCmdPageModeSelect];
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

+ (NSData *)commandDataForLineSpacingSet:(NSUInteger)lineSpacing {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdLineSpacingSet];
    unsigned char lineSpacingByte = lineSpacing;
    [command appendBytes:&lineSpacingByte length:sizeof(lineSpacingByte)];
    return command;
}

+ (NSData *)commandDataForSpecifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdCharacterSizeSpecify];
    unsigned char scaleByte = (verticalScale - 1) | ((horizontalScale - 1) << 4);
    [command appendBytes:&scaleByte length:sizeof(scaleByte)];
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

+ (NSData *)commandDataForPrintText:(NSString *)text {
    return [text dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)commandDataForPrintReturningToStandardMode {
    return [NSData dataWithHex:ZBPrinterHexCmdPrintReturningToStandardModeOrMarkedPaperPrintFormFeeding];
}

+ (NSData *)commandDataForCutPaperAZBerFeedingForwardBy:(NSUInteger)forward mode:(ZBPrinterPaperCutMode)mode {
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

+ (NSData *)commandDataForSelectCharacterFont:(ZBPrinterCharacterFont)characterFont {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdCharacterFontSelect];
    unsigned char characterFontByte = characterFont;
    [command appendBytes:&characterFontByte length:sizeof(characterFontByte)];
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

+ (NSData *)commandDataForPageModeDataPrint {
    return [NSData dataWithHex:ZBPrinterHexCmdPageModeDataPrint];
}

- (void)send512ZeroBytesWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[NSData dataWithHex:ZBPrinterHexCmd512ZeroBytes] completion:completion];
}

- (void)initializeHardwareWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForInitializeHardware] completion:completion];
}

- (void)enablePrinter:(BOOL)enable completion:(ZBPrinterDefaultCompletionHandler)completion {
    unsigned char value = enable;
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdPeripheralEquipmentSelection];
    [command appendBytes:&value length:sizeof(value)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)setPrinterModeWithCharacterFont:(ZBPrinterCharacterFont)characterFont bold:(BOOL)bold doubleHeight:(BOOL)doubleHeight doubleWidth:(BOOL)doubleWidth completion:(ZBPrinterDefaultCompletionHandler)completion {
    unsigned char mode = 0x00;
    switch (characterFont) {
        case ZBPrinterCharacterFont24x12: break;
        case ZBPrinterCharacterFont16x8: mode = mode | 0x01;
    }
    if (bold) {
        mode = mode | 0x08;
    }
    if (doubleHeight) {
        mode = mode | 0x10;
    }
    if (doubleWidth) {
        mode = mode | 0x20;
    }
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdPrintModeSelect];
    [command appendBytes:&mode length:sizeof(mode)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)functionSettingsWithCompletion:(ZBPrinterFunctionSettingsCompletionHandler)completion {
    ZBPrinterTaskGetFunctionSettings *task = [ZBPrinterTaskGetFunctionSettings new];
    task.completionHandler = completion;
    [self addTask:task];
}

- (void)setFunctionSettings:(ZBPrinterFunctionSettings *)functionSettings storing:(BOOL)storing completion:(ZBPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdFunctionSettingsChange];
    unsigned char functionByte = storing ? 0x80 : 0x00;
    [command appendBytes:&functionByte length:sizeof(functionByte)];
    [command appendData:functionSettings.dataRepresentation];
    unsigned char endByte = 0x00;
    [command appendBytes:&endByte length:sizeof(endByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)enableAutomaticStatusBackForChangingDrawerSensorStatus:(BOOL)cdss printerInformation:(BOOL)printerInfo errorStatus:(BOOL)es paperSensorInformation:(BOOL)psi presenterInformation:(BOOL)presenterInfo completion:(ZBPrinterDefaultCompletionHandler)completion {
    unsigned char automaticStatusBack = 0x00;
    automaticStatusBack |= cdss;
    automaticStatusBack |= printerInfo << 1;
    automaticStatusBack |= es << 2;
    automaticStatusBack |= psi << 3;
    automaticStatusBack |= presenterInfo << 4;
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdAutomaticStatusBackEnableDisable];
    [command appendBytes:&automaticStatusBack length:sizeof(automaticStatusBack)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)cutPaperAZBerFeedingForwardBy:(NSUInteger)forward mode:(ZBPrinterPaperCutMode)mode completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForCutPaperAZBerFeedingForwardBy:forward mode:mode] completion:completion];
}

- (void)lineFeedWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    NSData *command = [NSData dataWithHex:ZBPrinterHexCmdLineFeed];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)printFeedingForwardBy:(NSUInteger)forward completion:(ZBPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdPrintAndFeedForward];
    unsigned char forwardByte = forward;
    [command appendBytes:&forwardByte length:sizeof(forwardByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)selectPageModeWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSelectPageMode] completion:completion];
}

- (void)printAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForPrintAreaSetInPageModeWithX:x y:y width:width height:height] completion:completion];
}

- (void)printReturningToStandardModeWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForPrintReturningToStandardMode] completion:completion];
}

- (void)specifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSpecifyCharacterScaleVertically:verticalScale horizontally:horizontalScale] completion:completion];
}

- (void)lineSpacingSet:(NSUInteger)lineSpacing completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForLineSpacingSet:lineSpacing] completion:completion];
}

- (void)specifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSpecifyVerticalAbsolutePositionInPageMode:vap] completion:completion];
}

- (void)specifyCharacterPrintDirectionInPageMode:(ZBPrinterCharacterPrintDirection)cpd completion:(ZBPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdCharacterPrintDirectionSpecifyInPageMade];
    unsigned char characterPrintDirectionByte = cpd;
    [command appendBytes:&characterPrintDirectionByte length:sizeof(characterPrintDirectionByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)printText:(NSString *)text completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForPrintText:text] completion:completion];
}

- (void)setAlignment:(ZBPrinterAlignment)alignment completion:(ZBPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdAlignment];
    unsigned char alignmentByte = alignment;
    [command appendBytes:&alignmentByte length:sizeof(alignmentByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)setFlipEnabled:(BOOL)enableFlip completion:(ZBPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:ZBPrinterHexCmdInversionFlipPrintingSpecifyCancel];
    unsigned char flipEnabledByte = enableFlip;
    [command appendBytes:&flipEnabledByte length:sizeof(flipEnabledByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)selectCharacterFont:(ZBPrinterCharacterFont)characterFont completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSelectCharacterFont:characterFont] completion:completion];
}

- (void)specifyHorizontalAbsolutePosition:(NSUInteger)hap completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSpecifyHorizontalAbsolutePosition:hap] completion:completion];
}

- (void)macroDefinitionStartStopWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForMacroDefinitionStartStop] completion:completion];
}

- (void)macroExecutionWithExecutionCount:(NSUInteger)executionCount inBetweenDelayIn100ms:(NSUInteger)ibdi100ms completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForMacroExecutionWithExecutionCount:executionCount inBetweenDelayIn100ms:ibdi100ms] completion:completion];
}

- (void)pageModeDataPrintWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForPageModeDataPrint] completion:completion];
}

@end
