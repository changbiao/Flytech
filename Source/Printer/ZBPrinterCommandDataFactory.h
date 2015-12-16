//
//  ZBPrinterCommandDataFactory.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 15/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBPrinter.h"
#import "ZBPrinter+Advanced.h"

@class ZBPrinterFunctionSettings;

/*!
 *  @class ZBPrinterCommandDataFactory
 *  @discussion This class provides various class level functions to construct command data to send forth to the printers.
 *  @see The SEIKO SII printer documentation that comes bundled with the SDK.
 */
@interface ZBPrinterCommandDataFactory : NSObject

/*!
 *  @method commandDataForPrintText:
 *  @discussion Converts the given text string to UTF8 data.
 *  @param text The text to convert.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) printText:completion:]
 */
+ (NSData *)commandDataForPrintText:(NSString *)text;

/*!
 *  @method commandDataForLineFeed
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) lineFeedWithCompletion:]
 */
+ (NSData *)commandDataForLineFeed;

/*!
 *  @method commandDataForPrintReturningToStandardMode
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) printReturningToStandardModeWithCompletion:]
 */
+ (NSData *)commandDataForPrintReturningToStandardMode;

/*!
 *  @method commandDataForPageModePrint
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) pageModePrintWithCompletion:]
 */
+ (NSData *)commandDataForPageModePrint;

/*!
 *  @method commandDataForPrintFeedingForwardBy:
 *  @param forward The number of points that the printer should feed forward after printing.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) printFeedingForwardBy:completion:]
 */
+ (NSData *)commandDataForPrintFeedingForwardBy:(NSUInteger)forward;

/*!
 *  @method commandDataForLineSpacingSet:
 *  @param lineSpacing The line spacing in points.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) lineSpacingSet:completion:]
 */
+ (NSData *)commandDataForLineSpacingSet:(NSUInteger)lineSpacing;

/*!
 *  @method commandDataForSetPrinterModeWithSettings:
 *  @param printerModeSettings The printer mode settings.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) setPrinterModeWithSettings:completion:]
 */
+ (NSData *)commandDataForSetPrinterModeWithSettings:(ZBPrinterModeSettings)printerModeSettings;

/*!
 *  @method commandDataForSelectCharacterFont:
 *  @param characterFont The character font.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) selectCharacterFont:completion:]
 */
+ (NSData *)commandDataForSelectCharacterFont:(ZBPrinterCharacterFont)characterFont;

/*!
 *  @method commandDataForSpecifyCharacterScaleVertically:horizontally:
 *  @param verticalScale The character scale vertically, where 1 is the original scale.
 *  @param horizontalScale The character scale horizontall, where 1 is the original scale.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) specifyCharacterScaleVertically:horizontally:completion:]
 */
+ (NSData *)commandDataForSpecifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale;

/*!
 *  @method commandDataForSetFlipEnabled:
 *  @param enableFlip Whether or not to enable character flipping.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) setFlipEnabled:completion:]
 */
+ (NSData *)commandDataForSetFlipEnabled:(BOOL)enableFlip;

/*!
 *  @method commandDataForSelectPageMode
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) selectPageModeWithCompletion:]
 */
+ (NSData *)commandDataForSelectPageMode;

/*!
 *  @method commandDataForSetAlignment:
 *  @param alignment The alignment to set. This is only effective when in standard mode.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) setAlignment:completion:]
 */
+ (NSData *)commandDataForSetAlignment:(ZBPrinterAlignment)alignment;

/*!
 *  @method commandDataForSpecifyCharacterPrintDirectionInPageMode:
 *  @param cpd The character print direction to specify.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) specifyCharacterPrintDirectionInPageMode:completion:]
 */
+ (NSData *)commandDataForSpecifyCharacterPrintDirectionInPageMode:(ZBPrinterCharacterPrintDirection)cpd;

/*!
 *  @method commandDataForPrintAreaSetInPageModeWithX:y:width:height:
 *  @param x The x-coordinate of the point of origin.
 *  @param y The y-coordinate of the point of origin.
 *  @param width The width of the print area in points.
 *  @param height The height of the print area in point
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) printAreaSetInPageModeWithX:y:width:height:completion:]
 */
+ (NSData *)commandDataForPrintAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height;

/*!
 *  @method commandDataForSpecifyVerticalAbsolutePositionInPageMode:
 *  @param vap The vertical absolute position.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) specifyVerticalAbsolutePositionInPageMode:completion:]
 */
+ (NSData *)commandDataForSpecifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap;

/*!
 *  @method commandDataForSpecifyHorizontalAbsolutePosition:
 *  @param hap The horizontal absolute position.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) specifyHorizontalAbsolutePosition:completion:]
 */
+ (NSData *)commandDataForSpecifyHorizontalAbsolutePosition:(NSUInteger)hap;

/*!
 *  @method commandDataForMacroDefinitionStartStop
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) macroDefinitionStartStopWithCompletion:]
 */
+ (NSData *)commandDataForMacroDefinitionStartStop;

/*!
 *  @method commandDataForMacroExecutionWithExecutionCount:inBetweenDelayIn100ms:
 *  @param executionCount The number of times the macro should be executed.
 *  @param ibdi100ms The amount of time in 100ms the printer should wait in between the executions.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) macroExecutionWithExecutionCount:inBetweenDelayIn100ms:completion:]
 */
+ (NSData *)commandDataForMacroExecutionWithExecutionCount:(NSUInteger)executionCount inBetweenDelayIn100ms:(NSUInteger)ibdi100ms;

/*!
 *  @method commandDataForEnablePrinter:
 *  @param enable Whether or not the printer should be enabled. By default the printer is enabled already.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) enablePrinter:completion:]
 */
+ (NSData *)commandDataForEnablePrinter:(BOOL)enable;

/*!
 *  @method commandDataForInitializeHardware
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) initializeHardwareWithCompletion:]
 */
+ (NSData *)commandDataForInitializeHardware;

/*!
 *  @method commandDataForCutPaperAfterFeedingForwardBy:mode:
 *  @param forward The length in points to feed forward by before cutting.
 *  @param mode The kind of cutting technique to use, partial or full.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) cutPaperAfterFeedingForwardBy:mode:completion:]
 */
+ (NSData *)commandDataForCutPaperAfterFeedingForwardBy:(NSUInteger)forward mode:(ZBPrinterPaperCutMode)mode;

/*!
 *  @method commandDataForSetFunctionSettings:storing:
 *  @param functionSettings The function settings to set on the printer.
 *  @param storing Whether or not the settings should be stored in the printer.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) setFunctionSettings:storing:completion:]
 */
+ (NSData *)commandDataForSetFunctionSettings:(ZBPrinterFunctionSettings *)functionSettings storing:(BOOL)storing;

/*!
 *  @method commandDataForGetFunctionSettings
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) functionSettingsWithCompletion:]
 */
+ (NSData *)commandDataForFunctionSettings;

/*!
 *  @method commandDataForSetAutomaticStatusBackWithSettings:
 *  @param automaticStatusBackSettings The settings to apply to the printer for which status updates it should send automatically.
 *  @returns The command data.
 *  @seealso -[ZBPrinter(Advanced) setAutomaticStatusBackWithSettings:completion:]
 */
+ (NSData *)commandDataForSetAutomaticStatusBackWithSettings:(ZBPrinterAutomaticStatusBackSettings)automaticStatusBackSettings;

/*!
 *  @method init
 *  @discussion Unavailable. All commands are available through class methods.
 */
- (instancetype)init NS_UNAVAILABLE;

@end
