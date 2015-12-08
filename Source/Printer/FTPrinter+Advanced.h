//
//  FTPrinter+Advanced.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 17/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter.h"
#import "FTPrinterFunctionSettings.h"

typedef void(^FTPrinterFunctionSettingsCompletionHandler)(FTPrinterFunctionSettings *functionSettings, NSError *error);

@interface FTPrinter (Advanced)

+ (NSData *)commandDataForInitializeHardware;
+ (NSData *)commandDataForSelectPageMode;
+ (NSData *)commandDataForPrintAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height;
+ (NSData *)commandDataForLineSpacingSet:(NSUInteger)lineSpacing;
+ (NSData *)commandDataForSpecifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale;
+ (NSData *)commandDataForSpecifyHorizontalAbsolutePosition:(NSUInteger)hap;
+ (NSData *)commandDataForSpecifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap;
+ (NSData *)commandDataForPrintText:(NSString *)text;
+ (NSData *)commandDataForPrintReturningToStandardMode;
+ (NSData *)commandDataForCutPaperAfterFeedingForwardBy:(NSUInteger)forward mode:(FTPrinterPaperCutMode)mode;
+ (NSData *)commandDataForSelectCharacterFont:(FTPrinterCharacterFont)characterFont;

- (void)send512ZeroBytesWithCompletion:(FTPrinterDefaultCompletionHandler)completion;
- (void)initializeHardwareWithCompletion:(FTPrinterDefaultCompletionHandler)completion;
- (void)enablePrinter:(BOOL)enable completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)setPrinterModeWithCharacterFont:(FTPrinterCharacterFont)characterFont bold:(BOOL)bold doubleHeight:(BOOL)doubleHeight doubleWidth:(BOOL)doubleWidth completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)functionSettingsWithCompletion:(FTPrinterFunctionSettingsCompletionHandler)completion;
- (void)setFunctionSettings:(FTPrinterFunctionSettings *)functionSettings storing:(BOOL)storing completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)enableAutomaticStatusBackForChangingDrawerSensorStatus:(BOOL)cdss printerInformation:(BOOL)printerInfo errorStatus:(BOOL)es paperSensorInformation:(BOOL)psi presenterInformation:(BOOL)presenterInfo completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)cutPaperAfterFeedingForwardBy:(NSUInteger)forward mode:(FTPrinterPaperCutMode)mode completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)lineFeedWithCompletion:(FTPrinterDefaultCompletionHandler)completion;
- (void)printFeedingForwardBy:(NSUInteger)forward completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)selectPageModeWithCompletion:(FTPrinterDefaultCompletionHandler)completion;
- (void)printAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)printReturningToStandardModeWithCompletion:(FTPrinterDefaultCompletionHandler)completion;
- (void)specifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)lineSpacingSet:(NSUInteger)lineSpacing completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)specifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)specifyCharacterPrintDirectionInPageMode:(FTPrinterCharacterPrintDirection)cpd completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)printText:(NSString *)text completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)setAlignment:(FTPrinterAlignment)alignment completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)setFlipEnabled:(BOOL)enableFlip completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)selectCharacterFont:(FTPrinterCharacterFont)characterFont completion:(FTPrinterDefaultCompletionHandler)completion;
- (void)specifyHorizontalAbsolutePosition:(NSUInteger)hap completion:(FTPrinterDefaultCompletionHandler)completion;

@end
