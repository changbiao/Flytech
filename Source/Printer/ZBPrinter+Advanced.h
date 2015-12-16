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

/*!
 *  @struct ZBPrinterModeSettings
 *  @discussion Argument container struct for the setPrinterModeWithSettings:completion: method.
 *  @field characterFont The character font.
 *  @field bold Whether or not the text should be bolded.
 *  @field doubleHeight Whether or not the text should be scaled 2x tall.
 *  @field doubleWidth Whether or not the text should be scaled 2x wide.
 */
struct ZBPrinterModeSettings {
    ZBPrinterCharacterFont characterFont;
    BOOL bold;
    BOOL doubleHeight;
    BOOL doubleWidth;
};
typedef struct ZBPrinterModeSettings ZBPrinterModeSettings;

/*!
 *  @function ZBPrinterModeSettingsMake
 *  @discussion ZBPrinterModeSettings factory function.
 *  @see ZBPrinterModeSettings
 */
ZBPrinterModeSettings ZBPrinterModeSettingsMake(ZBPrinterCharacterFont characterFont, BOOL bold, BOOL doubleHeight, BOOL doubleWidth);

/*!
 *  @struct
 *  @discussion Argument container struct for the setAutomaticStatusBackWithSettings:completion: method.
 *  @field changingDrawerSensorStatus Whether status updates should be sent upon changes sensed by the drawer senser.
 *  @field printerInformation Whether status updates should be sent upon changes to printer information.
 *  @field errorStatus Whether status updates should be sent when errors are encountered or no longer encountered.
 *  @field paperSensorInformation Whether status updates should be sent when changes are sensed by the paper sensor.
 *  @field presenterInformation Whether status updates should be sent when changes are sensed by the presenter.
 */
struct ZBPrinterAutomaticStatusBackSettings {
    BOOL changingDrawerSensorStatus;
    BOOL printerInformation;
    BOOL errorStatus;
    BOOL paperSensorInformation;
    BOOL presenterInformation;
};
typedef struct ZBPrinterAutomaticStatusBackSettings ZBPrinterAutomaticStatusBackSettings;

/*!
 *  @function ZBPrinterAutomaticStatusBackSettingsMake
 *  @discussion ZBPrinterAutomaticStatusBackSettings factory function.
 *  @see ZBPrinterAutomaticStatusBackSettings
 */
ZBPrinterAutomaticStatusBackSettings ZBPrinterAutomaticStatusBackSettingsMake(BOOL changingDrawerSensorStatus, BOOL printerInformation, BOOL errorStatus, BOOL paperSensorInformation, BOOL presenterInformation);

/*!
 *  @category ZBPrinter(Advanced)
 *  @discussion Use the functionality available in this category if you're in need of advanced printer usage.
 *      All data sent to the printer will be queued and as such it isn't necessary to wait for each call to
 *      complete before sending the next.
 */
@interface ZBPrinter (Advanced)

/*!
 *  @method sendData:completion:
 *  @discussion Sends binary data to the printer. For optimization purposes it one can chain commands into one large data stream.
 *  @param data The data to send.
 *  @param completion A handler that will be called once the call completes.
 *  @see ZBPrinterCommandDataFactory
 */
- (void)sendData:(NSData *)data completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method printText:completion:
 *  @discussion Converts the given text string to UTF8 data and sends it to the printer.
 *  @param text The text to send.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForPrintText:]
 */
- (void)printText:(NSString *)text completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method lineFeedWithCompletion:
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForLineFeed]
 */
- (void)lineFeedWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method printReturningToStandardModeWithCompletion:
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForPrintReturningToStandardModeWithCompletion:]
 */
- (void)printReturningToStandardModeWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method pageModeDataPrintWithCompletion:
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForPageModeDataPrintWithCompletion:]
 */
- (void)pageModeDataPrintWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method printFeedingForwardBy:completion:
 *  @param forward The number of points that the printer should feed forward after printing.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory printFeedingForwardBy:completion:]
 */
- (void)printFeedingForwardBy:(NSUInteger)forward completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method lineSpacingSet:completion:
 *  @param lineSpacing The line spacing in points.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForLineSpacingSet:]
 */
- (void)lineSpacingSet:(NSUInteger)lineSpacing completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method setPrinterModeWithSettings:completion:
 *  @param printerModeSettings The printer mode settings.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSetPrinterModeWithSettings:]
 */
- (void)setPrinterModeWithSettings:(ZBPrinterModeSettings)printerModeSettings completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method selectCharacterFont:completion:
 *  @param characterFont The character font.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSelectCharacterFont:]
 */
- (void)selectCharacterFont:(ZBPrinterCharacterFont)characterFont completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method specifyCharacterScaleVertically:horizontally:completion:
 *  @param verticalScale The character scale vertically, where 1 is the original scale.
 *  @param horizontalScale The character scale horizontall, where 1 is the original scale.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSpecifyCharacterScaleVertically:horizontally:]
 */
- (void)specifyCharacterScaleVertically:(NSUInteger)verticalScale horizontally:(NSUInteger)horizontalScale completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method setFlipEnabled:completion:
 *  @param enableFlip Whether or not to enable character flipping.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSetFlipEnabled:]
 */
- (void)setFlipEnabled:(BOOL)enableFlip completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method selectPageModeWithCompletion:
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSelectPageMode]
 */
- (void)selectPageModeWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method setAlignment:completion:
 *  @param alignment The alignment to set. This is only effective when in standard mode.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSetAlignment:]
 */
- (void)setAlignment:(ZBPrinterAlignment)alignment completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method specifyCharacterPrintDirectionInPageMode:completion:
 *  @param cpd The character print direction to specify.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSpecifyCharacterPrintDirectionInPageMode:]
 */
- (void)specifyCharacterPrintDirectionInPageMode:(ZBPrinterCharacterPrintDirection)cpd completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method printAreaSetInPageModeWithX:y:width:height:completion:
 *  @param x The x-coordinate of the point of origin.
 *  @param y The y-coordinate of the point of origin.
 *  @param width The width of the print area in points.
 *  @param height The height of the print area in points.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForPrintAreaSetInPageModeWithX:y:width:height:]
 */
- (void)printAreaSetInPageModeWithX:(NSUInteger)x y:(NSUInteger)y width:(NSUInteger)width height:(NSUInteger)height completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method specifyVerticalAbsolutePositionInPageMode:completion:
 *  @param vap The vertical absolute position.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSpecifyVerticalAbsolutePositionInPageMode:]
 */
- (void)specifyVerticalAbsolutePositionInPageMode:(NSUInteger)vap completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method specifyHorizontalAbsolutePosition:completion:
 *  @param hap The horizontal absolute position.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSpecifyHorizontalAbsolutePosition:]
 */
- (void)specifyHorizontalAbsolutePosition:(NSUInteger)hap completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method macroDefinitionStartStopWithCompletion:
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForMacroDefinitionStartStop]
 */
- (void)macroDefinitionStartStopWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method macroExecutionWithExecutionCount:inBetweenDelayIn100ms:completion:
 *  @param executionCount The number of times the macro should be executed.
 *  @param ibdi100ms The amount of time in 100ms the printer should wait in between the executions.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForMacroExecutionWithExecutionCount:inBetweenDelayIn100ms:]
 */
- (void)macroExecutionWithExecutionCount:(NSUInteger)executionCount inBetweenDelayIn100ms:(NSUInteger)ibdi100ms completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method enablePrinter:completion:
 *  @param enable Whether or not the printer should be enabled. By default the printer is enabled already.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForEnablePrinter:]
 */
- (void)enablePrinter:(BOOL)enable completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method initializeHardwareWithCompletion:
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForInitializeHardware]
 */
- (void)initializeHardwareWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method cutPaperAfterFeedingForwardBy:mode:completion:
 *  @param forward The length in points to feed forward by before cutting.
 *  @param mode The kind of cutting technique to use, partial or full.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForCutPaperAfterFeedingForwardBy:mode:]
 */
- (void)cutPaperAfterFeedingForwardBy:(NSUInteger)forward mode:(ZBPrinterPaperCutMode)mode completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method setFunctionSettings:storing:completion:
 *  @param functionSettings The function settings to set on the printer.
 *  @param storing Whether or not the settings should be stored in the printer.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSetFunctionSettings:storing:]
 */
- (void)setFunctionSettings:(ZBPrinterFunctionSettings *)functionSettings storing:(BOOL)storing completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method functionSettingsWithCompletion:
 *  @param completion A handler that will be called once the call completes, with an error or the settings currently active in the printer.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForFunctionSettings]
 */
- (void)functionSettingsWithCompletion:(ZBPrinterFunctionSettingsCompletionHandler)completion;

/*!
 *  @method setAutomaticStatusBackWithSettings:completion:
 *  @param automaticStatusBackSettings The settings to apply to the printer for which status updates it should send automatically.
 *  @param completion A handler that will be called once the call completes.
 *  @seealso +[ZBPrinterCommandDataFactory commandDataForSetAutomaticStatusBackWithSettings:]
 */
- (void)setAutomaticStatusBackWithSettings:(ZBPrinterAutomaticStatusBackSettings)automaticStatusBackSettings completion:(ZBPrinterDefaultCompletionHandler)completion;

@end
