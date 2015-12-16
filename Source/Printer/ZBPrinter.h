//
//  ZBPrinter.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZBPrinterPageBuilder;

typedef void(^ZBPrinterDefaultCompletionHandler)(NSError * _Nullable error);
typedef void(^ZBPrinterPageBuilderBlock)(ZBPrinterPageBuilder *pageBuilder);

/*!
 *  @const ZBPrinterFullPageWidth
 *  @discussion The full width of a "page" or print area = 576 points.
 */
extern NSUInteger const ZBPrinterFullPageWidth;

/*!
 *  @const ZBPrinterDefaultFeedBeforeCutting
 *  @discussion The default length that the printer will feed before cutting after a print = 130 points.
 */
extern NSUInteger const ZBPrinterDefaultFeedBeforeCutting;

/*!
 *  @const ZBPrinterSpaceBetweenLinesFraction
 *  @discussion The fraction of the character height that will be used as spacing between lines = 1/3.
 */
extern double const ZBPrinterSpaceBetweenLinesFraction;

/*!
 *  @enum ZBPrinterCharacterFont
 *  @discussion The character fonts that are available to use on the printer.
 *  @constant ZBPrinterCharacterFont24x12 A character font that is 24 tall by 12 wide in points.
 *  @constant ZBPrinterCharacterFont16x8 A character font that is 16 tall by 8 wide in points.
 */
typedef NS_ENUM(NSUInteger, ZBPrinterCharacterFont) {
    ZBPrinterCharacterFont24x12 = 0,
    ZBPrinterCharacterFont16x8 = 1
};

/*!
 *  @enum ZBPrinterPaperCutMode
 *  @discussion Represents the mode that the printer will use to cut the paper.
 *  @constant ZBPrinterPaperCutModePartial Cuts the paper partially.
 *  @constant ZBPrinterPaperCutModeFull Fully cuts the paper.
 */
typedef NS_ENUM(NSUInteger, ZBPrinterPaperCutMode) {
    ZBPrinterPaperCutModePartial,
    ZBPrinterPaperCutModeFull
};

/*!
 *  @enum ZBPrinterCharacterPrintDirection
 *  @discussion The direction in which the characters should be printed.
 *  @constant ZBPrinterCharacterPrintDirectionLeftToRight Left to right.
 *  @constant ZBPrinterCharacterPrintDirectionBottomToTop Bottom to top.
 *  @constant ZBPrinterCharacterPrintDirectionRightToLeft Right to left.
 *  @constant ZBPrinterCharacterPrintDirectionTopToBottom Top to bottom.
 */
typedef NS_ENUM(NSUInteger, ZBPrinterCharacterPrintDirection) {
    ZBPrinterCharacterPrintDirectionLeftToRight = 0,
    ZBPrinterCharacterPrintDirectionBottomToTop = 1,
    ZBPrinterCharacterPrintDirectionRightToLeft = 2,
    ZBPrinterCharacterPrintDirectionTopToBottom = 3
};

/*!
 *  @enum ZBPrinterAlignment
 *  @discussion The alignment that the printer should use when positioning text and printable elements.
 *  @constant ZBPrinterAlignmentLeft Left
 *  @constant ZBPrinterAlignmentCenter Center
 *  @constant ZBPrinterAlignmentRight Right
 */
typedef NS_ENUM(NSUInteger, ZBPrinterAlignment) {
    ZBPrinterAlignmentLeft = 48,
    ZBPrinterAlignmentCenter = 49,
    ZBPrinterAlignmentRight = 50
};

/*!
 *  @class ZBPrinter
 *  @discussion Objects of this class represent the printers inside Zeeba stands and are used to communicate with them.
 */
@interface ZBPrinter : NSObject

/*!
 *  @method printTestMaterialWithCompletion:
 *  @discussion Performs a test print.
 *  @param completion A handler that is called when the printing completes.
 */
- (void)printTestMaterialWithCompletion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method printWithPageBuilder:completion:
 *  @discussion The go-to method for easy but advanced printing. Add all the printing components needed in the builder block
 *      and they will be passed onto the printer in the most optimal way.
 *  @param builder A block in which you compose your content by adding components to the page builder object.
 *  @param completion A handler that is called once the printing completes.
 */
- (void)printWithPageBuilder:(ZBPrinterPageBuilderBlock)builder completion:(ZBPrinterDefaultCompletionHandler)completion;

/*!
 *  @method init
 *  @discussion Unavailable. ZBPrinter objects should only ever be accessed through FTStand objects.
 */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
