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
#import "ZBPrinterCommandDataFactory.h"

@implementation ZBPrinter (Advanced)

#pragma mark - Public Interface

ZBPrinterModeSettings ZBPrinterModeSettingsMake(ZBPrinterCharacterFont characterFont, BOOL bold, BOOL doubleHeight, BOOL doubleWidth) {
    ZBPrinterModeSettings printerModeSettings;
    printerModeSettings.characterFont = characterFont;
    printerModeSettings.bold = bold;
    printerModeSettings.doubleHeight = doubleHeight;
    printerModeSettings.doubleWidth = doubleWidth;
    return printerModeSettings;
}

ZBPrinterAutomaticStatusBackSettings ZBPrinterAutomaticStatusBackSettingsMake(BOOL changingDrawerSensorStatus, BOOL printerInformation, BOOL errorStatus, BOOL paperSensorInformation, BOOL presenterInformation) {
    ZBPrinterAutomaticStatusBackSettings automaticStatusBackSettings;
    automaticStatusBackSettings.changingDrawerSensorStatus = changingDrawerSensorStatus;
    automaticStatusBackSettings.printerInformation = printerInformation;
    automaticStatusBackSettings.errorStatus = errorStatus;
    automaticStatusBackSettings.paperSensorInformation = paperSensorInformation;
    automaticStatusBackSettings.presenterInformation = presenterInformation;
    return automaticStatusBackSettings;
}

- (void)sendData:(NSData *)data completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:data completion:completion];
}

- (void)printText:(NSString *)text completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForPrintText:text] completion:completion];
}

- (void)lineFeedWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForLineFeed] completion:completion];
}

- (void)printReturningToStandardModeWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForPrintReturningToStandardMode] completion:completion];
}

- (void)pageModeDataPrintWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForPageModePrint] completion:completion];
}

- (void)printFeedingForwardBy:(NSUInteger)forward completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForPrintFeedingForwardBy:forward] completion:completion];
}

- (void)lineSpacingSet:(NSUInteger)lineSpacing completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForLineSpacingSet:lineSpacing] completion:completion];
}

- (void)setPrinterModeWithSettings:(ZBPrinterModeSettings)printerModeSettings completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSetPrinterModeWithSettings:printerModeSettings] completion:completion];
}

- (void)selectCharacterFont:(ZBPrinterCharacterFont)characterFont completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSelectCharacterFont:characterFont] completion:completion];
}

- (void)specifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSpecifyCharacterScaleVertically:verticalScale horizontally:horizontalScale] completion:completion];
}

- (void)setFlipEnabled:(BOOL)enableFlip completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSetFlipEnabled:enableFlip] completion:completion];
}

- (void)selectPageModeWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSelectPageMode] completion:completion];
}

- (void)setAlignment:(ZBPrinterAlignment)alignment completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSetAlignment:alignment] completion:completion];
}

- (void)specifyCharacterPrintDirectionInPageMode:(ZBPrinterCharacterPrintDirection)cpd completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSpecifyCharacterPrintDirectionInPageMode:cpd] completion:completion];
}

- (void)printAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForPrintAreaSetInPageModeWithX:x y:y width:width height:height] completion:completion];
}

- (void)specifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSpecifyVerticalAbsolutePositionInPageMode:vap] completion:completion];
}

- (void)specifyHorizontalAbsolutePosition:(NSUInteger)hap completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSpecifyHorizontalAbsolutePosition:hap] completion:completion];
}

- (void)macroDefinitionStartStopWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForMacroDefinitionStartStop] completion:completion];
}

- (void)macroExecutionWithExecutionCount:(NSUInteger)executionCount inBetweenDelayIn100ms:(NSUInteger)ibdi100ms completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForMacroExecutionWithExecutionCount:executionCount inBetweenDelayIn100ms:ibdi100ms] completion:completion];
}

- (void)enablePrinter:(BOOL)enable completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForEnablePrinter:enable] completion:completion];
}

- (void)initializeHardwareWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForInitializeHardware] completion:completion];
}

- (void)cutPaperAfterFeedingForwardBy:(NSUInteger)forward mode:(ZBPrinterPaperCutMode)mode completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForCutPaperAfterFeedingForwardBy:forward mode:mode] completion:completion];
}

- (void)setFunctionSettings:(ZBPrinterFunctionSettings *)functionSettings storing:(BOOL)storing completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSetFunctionSettings:functionSettings storing:storing] completion:completion];
}

- (void)functionSettingsWithCompletion:(ZBPrinterFunctionSettingsCompletionHandler)completion {
    ZBPrinterTaskGetFunctionSettings *task = [ZBPrinterTaskGetFunctionSettings new];
    task.completion = completion;
    [self addTask:task];
}

- (void)setAutomaticStatusBackWithSettings:(ZBPrinterAutomaticStatusBackSettings)automaticStatusBackSettings completion:(ZBPrinterDefaultCompletionHandler)completion {
    [self addSendDataTaskWithData:[ZBPrinterCommandDataFactory commandDataForSetAutomaticStatusBackWithSettings:automaticStatusBackSettings] completion:completion];
}

@end
