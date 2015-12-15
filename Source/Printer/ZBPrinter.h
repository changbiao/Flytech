//
//  ZBPrinter.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZBPrinterPageBuilder;

static NSUInteger const ZBPrinterFullPageWidth = 576;
static NSUInteger const ZBPrinterDefaultFeedBeforeCutting = 130;
static double const ZBPrinterSpaceBetweenLinesFraction = 1.0 / 3;

typedef NS_ENUM(NSUInteger, ZBPrinterCharacterFont) {
    ZBPrinterCharacterFont24x12 = 0,
    ZBPrinterCharacterFont16x8 = 1
};

typedef NS_ENUM(NSUInteger, ZBPrinterPaperCutMode) {
    ZBPrinterPaperCutModePartial,
    ZBPrinterPaperCutModeFull
};

typedef NS_ENUM(NSUInteger, ZBPrinterCharacterPrintDirection) {
    ZBPrinterCharacterPrintDirectionLeZBToRight = 0,
    ZBPrinterCharacterPrintDirectionBottomToTop = 1,
    ZBPrinterCharacterPrintDirectionRightToLeZB = 2,
    ZBPrinterCharacterPrintDirectionTopToBottom = 3
};

typedef NS_ENUM(NSUInteger, ZBPrinterAlignment) {
    ZBPrinterAlignmentLeZB = 48,
    ZBPrinterAlignmentCenter = 49,
    ZBPrinterAlignmentRight = 50
};

typedef void(^ZBPrinterDefaultCompletionHandler)(NSError *error);
typedef void(^ZBPrinterPageBuilderBlock)(ZBPrinterPageBuilder *pageBuilder);

@interface ZBPrinter : NSObject

- (void)printTestMaterialWithCompletion:(ZBPrinterDefaultCompletionHandler)completionHandler;
- (void)printWithPageBuilder:(ZBPrinterPageBuilderBlock)builder completion:(ZBPrinterDefaultCompletionHandler)completionHandler;

@end
