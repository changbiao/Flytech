//
//  FTPrinter.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTPrinterPageBuilder;

static NSUInteger const FTPrinterFullPageWidth = 576;
static NSUInteger const FTPrinterDefaultFeedBeforeCutting = 130;
static double const FTPrinterSpaceBetweenLinesFraction = 1.0 / 3;

typedef NS_ENUM(NSUInteger, FTPrinterCharacterFont) {
    FTPrinterCharacterFont24x12 = 0,
    FTPrinterCharacterFont16x8 = 1
};

typedef NS_ENUM(NSUInteger, FTPrinterPaperCutMode) {
    FTPrinterPaperCutModePartial,
    FTPrinterPaperCutModeFull
};

typedef NS_ENUM(NSUInteger, FTPrinterCharacterPrintDirection) {
    FTPrinterCharacterPrintDirectionLeftToRight = 0,
    FTPrinterCharacterPrintDirectionBottomToTop = 1,
    FTPrinterCharacterPrintDirectionRightToLeft = 2,
    FTPrinterCharacterPrintDirectionTopToBottom = 3
};

typedef NS_ENUM(NSUInteger, FTPrinterAlignment) {
    FTPrinterAlignmentLeft = 48,
    FTPrinterAlignmentCenter = 49,
    FTPrinterAlignmentRight = 50
};

typedef void(^FTPrinterDefaultCompletionHandler)(NSError *error);
typedef void(^FTPrinterPageBuilderBlock)(FTPrinterPageBuilder *pageBuilder);

@interface FTPrinter : NSObject

- (void)printTestMaterialWithCompletion:(FTPrinterDefaultCompletionHandler)completionHandler;
- (void)printWithPageBuilder:(FTPrinterPageBuilderBlock)builder completion:(FTPrinterDefaultCompletionHandler)completionHandler;

@end
