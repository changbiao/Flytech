//
//  ZBPrinter+Advanced.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 17/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinter.h"
#import "ZBPrinterFunctionSettings.h"

typedef void(^ZBPrinterFunctionSettingsCompletionHandler)(ZBPrinterFunctionSettings *functionSettings, NSError *error);

@interface ZBPrinter (Advanced)

+ (NSData *)commandDataForInitializeHardware;
+ (NSData *)commandDataForSelectPageMode;
+ (NSData *)commandDataForPrintAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height;
+ (NSData *)commandDataForLineSpacingSet:(NSUInteger)lineSpacing;
+ (NSData *)commandDataForSpecifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale;
+ (NSData *)commandDataForSpecifyHorizontalAbsolutePosition:(NSUInteger)hap;
+ (NSData *)commandDataForSpecifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap;
+ (NSData *)commandDataForPrintText:(NSString *)text;
+ (NSData *)commandDataForPrintReturningToStandardMode;
+ (NSData *)commandDataForCutPaperAZBerFeedingForwardBy:(NSUInteger)forward mode:(ZBPrinterPaperCutMode)mode;
+ (NSData *)commandDataForSelectCharacterFont:(ZBPrinterCharacterFont)characterFont;
+ (NSData *)commandDataForMacroDefinitionStartStop;
+ (NSData *)commandDataForMacroExecutionWithExecutionCount:(NSUInteger)executionCount inBetweenDelayIn100ms:(NSUInteger)ibdi100ms;
+ (NSData *)commandDataForPageModeDataPrint;

- (void)send512ZeroBytesWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)initializeHardwareWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)enablePrinter:(BOOL)enable completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)setPrinterModeWithCharacterFont:(ZBPrinterCharacterFont)characterFont bold:(BOOL)bold doubleHeight:(BOOL)doubleHeight doubleWidth:(BOOL)doubleWidth completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)functionSettingsWithCompletion:(ZBPrinterFunctionSettingsCompletionHandler)completion;
- (void)setFunctionSettings:(ZBPrinterFunctionSettings *)functionSettings storing:(BOOL)storing completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)enableAutomaticStatusBackForChangingDrawerSensorStatus:(BOOL)cdss printerInformation:(BOOL)printerInfo errorStatus:(BOOL)es paperSensorInformation:(BOOL)psi presenterInformation:(BOOL)presenterInfo completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)cutPaperAZBerFeedingForwardBy:(NSUInteger)forward mode:(ZBPrinterPaperCutMode)mode completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)lineFeedWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)printFeedingForwardBy:(NSUInteger)forward completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)selectPageModeWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)printAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)printReturningToStandardModeWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)specifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)lineSpacingSet:(NSUInteger)lineSpacing completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)specifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)specifyCharacterPrintDirectionInPageMode:(ZBPrinterCharacterPrintDirection)cpd completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)printText:(NSString *)text completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)setAlignment:(ZBPrinterAlignment)alignment completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)setFlipEnabled:(BOOL)enableFlip completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)selectCharacterFont:(ZBPrinterCharacterFont)characterFont completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)specifyHorizontalAbsolutePosition:(NSUInteger)hap completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)macroDefinitionStartStopWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)macroExecutionWithExecutionCount:(NSUInteger)executionCount inBetweenDelayIn100ms:(NSUInteger)ibdi100ms completion:(ZBPrinterDefaultCompletionHandler)completion;
- (void)pageModeDataPrintWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;

@end
