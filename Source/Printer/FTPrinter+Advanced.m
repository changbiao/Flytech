//
//  FTPrinter+Advanced.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 17/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter+Advanced.h"
#import "FTPrinter+Private.h"
#import "NSData+FTHex.h"
#import "FTPrinter+HexCmd.h"
#import "FTDebugging.h"

@implementation FTPrinter (Advanced)

#pragma mark - Public Interface

+ (NSData *)commandDataForInitializeHardware {
    return [NSData dataWithHex:FTPrinterHexCmdPrinterInitialize];
}

+ (NSData *)commandDataForSelectPageMode {
    return [NSData dataWithHex:FTPrinterHexCmdPageModeSelect];
}

+ (NSData *)commandDataForPrintAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdPrintAreaSetInPageMode];
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
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdLineSpacingSet];
    unsigned char lineSpacingByte = lineSpacing;
    [command appendBytes:&lineSpacingByte length:sizeof(lineSpacingByte)];
    return command;
}

+ (NSData *)commandDataForSpecifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdCharacterSizeSpecify];
    unsigned char scaleByte = (verticalScale - 1) | ((horizontalScale - 1) << 4);
    [command appendBytes:&scaleByte length:sizeof(scaleByte)];
    return command;
}

+ (NSData *)commandDataForSpecifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdVerticalAbsolutePositionSpecifyInPageMode];
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
    return [NSData dataWithHex:FTPrinterHexCmdPrintReturningToStandardModeOrMarkedPaperPrintFormFeeding];
}

+ (NSData *)commandDataForCutPaperAfterFeedingForwardBy:(NSUInteger)forward mode:(FTPrinterPaperCutMode)mode {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdPaperCut];
    unsigned char modeByte;
    switch (mode) {
        case FTPrinterPaperCutModeFull: modeByte = forward > 0 ? 65 : 0; break;
        case FTPrinterPaperCutModePartial: modeByte = forward > 0 ? 66 : 1; break;
    }
    [command appendBytes:&modeByte length:sizeof(modeByte)];
    if (forward > 0) {
        unsigned char forwardByte = forward;
        [command appendBytes:&forwardByte length:sizeof(forwardByte)];
    }
    return command;
}

+ (NSData *)commandDataForSelectCharacterFont:(FTPrinterCharacterFont)characterFont {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdCharacterFontSelect];
    unsigned char characterFontByte = characterFont;
    [command appendBytes:&characterFontByte length:sizeof(characterFontByte)];
    return command;
}

+ (NSData *)commandDataForSpecifyHorizontalAbsolutePosition:(NSUInteger)hap {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdAbsolutePositionSpecify];
    unsigned char hapByte = hap % 255;
    unsigned char hapMultiplierByte = floor(hap / 255.0);
    [command appendBytes:&hapByte length:sizeof(hapByte)];
    [command appendBytes:&hapMultiplierByte length:sizeof(hapMultiplierByte)];
    return command;
}

- (void)send512ZeroBytesWithCompletion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[NSData dataWithHex:FTPrinterHexCmd512ZeroBytes] completion:completion];
}

- (void)initializeHardwareWithCompletion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForInitializeHardware] completion:completion];
}

- (void)enablePrinter:(BOOL)enable completion:(FTPrinterDefaultCompletionHandler)completion {
    unsigned char value = enable;
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdPeripheralEquipmentSelection];
    [command appendBytes:&value length:sizeof(value)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)setPrinterModeWithCharacterFont:(FTPrinterCharacterFont)characterFont bold:(BOOL)bold doubleHeight:(BOOL)doubleHeight doubleWidth:(BOOL)doubleWidth completion:(FTPrinterDefaultCompletionHandler)completion {
    unsigned char mode = 0x00;
    switch (characterFont) {
        case FTPrinterCharacterFont24x12: break;
        case FTPrinterCharacterFont16x8: mode = mode | 0x01;
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
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdPrintModeSelect];
    [command appendBytes:&mode length:sizeof(mode)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)functionSettingsWithCompletion:(FTPrinterFunctionSettingsCompletionHandler)completion {
    FTPrinterTaskGetFunctionSettings *task = [FTPrinterTaskGetFunctionSettings new];
    task.completionHandler = completion;
    [self addTask:task];
}

- (void)setFunctionSettings:(FTPrinterFunctionSettings *)functionSettings storing:(BOOL)storing completion:(FTPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdFunctionSettingsChange];
    unsigned char functionByte = storing ? 0x80 : 0x00;
    [command appendBytes:&functionByte length:sizeof(functionByte)];
    [command appendData:functionSettings.dataRepresentation];
    unsigned char endByte = 0x00;
    [command appendBytes:&endByte length:sizeof(endByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)enableAutomaticStatusBackForChangingDrawerSensorStatus:(BOOL)cdss printerInformation:(BOOL)printerInfo errorStatus:(BOOL)es paperSensorInformation:(BOOL)psi presenterInformation:(BOOL)presenterInfo completion:(FTPrinterDefaultCompletionHandler)completion {
    unsigned char automaticStatusBack = 0x00;
    automaticStatusBack |= cdss;
    automaticStatusBack |= printerInfo << 1;
    automaticStatusBack |= es << 2;
    automaticStatusBack |= psi << 3;
    automaticStatusBack |= presenterInfo << 4;
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdAutomaticStatusBackEnableDisable];
    [command appendBytes:&automaticStatusBack length:sizeof(automaticStatusBack)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)cutPaperAfterFeedingForwardBy:(NSUInteger)forward mode:(FTPrinterPaperCutMode)mode completion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForCutPaperAfterFeedingForwardBy:forward mode:mode] completion:completion];
}

- (void)lineFeedWithCompletion:(FTPrinterDefaultCompletionHandler)completion {
    NSData *command = [NSData dataWithHex:FTPrinterHexCmdLineFeed];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)printFeedingForwardBy:(NSUInteger)forward completion:(FTPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdPrintAndFeedForward];
    unsigned char forwardByte = forward;
    [command appendBytes:&forwardByte length:sizeof(forwardByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)selectPageModeWithCompletion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSelectPageMode] completion:completion];
}

- (void)printAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height completion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForPrintAreaSetInPageModeWithX:x y:y width:width height:height] completion:completion];
}

- (void)printReturningToStandardModeWithCompletion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForPrintReturningToStandardMode] completion:completion];
}

- (void)specifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale completion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSpecifyCharacterScaleVertically:verticalScale horizontally:horizontalScale] completion:completion];
}

- (void)lineSpacingSet:(NSUInteger)lineSpacing completion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForLineSpacingSet:lineSpacing] completion:completion];
}

- (void)specifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap completion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSpecifyVerticalAbsolutePositionInPageMode:vap] completion:completion];
}

- (void)specifyCharacterPrintDirectionInPageMode:(FTPrinterCharacterPrintDirection)cpd completion:(FTPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdCharacterPrintDirectionSpecifyInPageMade];
    unsigned char characterPrintDirectionByte = cpd;
    [command appendBytes:&characterPrintDirectionByte length:sizeof(characterPrintDirectionByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)printText:(NSString *)text completion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForPrintText:text] completion:completion];
}

- (void)setAlignment:(FTPrinterAlignment)alignment completion:(FTPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdAlignment];
    unsigned char alignmentByte = alignment;
    [command appendBytes:&alignmentByte length:sizeof(alignmentByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)setFlipEnabled:(BOOL)enableFlip completion:(FTPrinterDefaultCompletionHandler)completion {
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdInversionFlipPrintingSpecifyCancel];
    unsigned char flipEnabledByte = enableFlip;
    [command appendBytes:&flipEnabledByte length:sizeof(flipEnabledByte)];
    [self addSendDataTaskWithData:command completion:completion];
}

- (void)selectCharacterFont:(FTPrinterCharacterFont)characterFont completion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSelectCharacterFont:characterFont] completion:completion];
}

- (void)specifyHorizontalAbsolutePosition:(NSUInteger)hap completion:(FTPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[[self class] commandDataForSpecifyHorizontalAbsolutePosition:hap] completion:completion];
}

@end
