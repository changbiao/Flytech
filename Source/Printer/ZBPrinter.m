//
//  ZBPrinter.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinter.h"
#import "ZBPrinter+Private.h"
#import "ZBPrinter+HexCmd.h"
#import "NSData+ZBHex.h"
#import "ZBPrinter+Advanced.h"
#import "ZBPrinterTestMaterialFactory.h"
#import "ZBPrinterCommandDataFactory.h"

NSUInteger const ZBPrinterFullPageWidth = 576;
NSUInteger const ZBPrinterDefaultFeedBeforeCutting = 130;
double const ZBPrinterSpaceBetweenLinesFraction = 1.0 / 3;

@implementation ZBPrinter

#pragma mark - Public Interface

- (void)printTestMaterialWithCompletion:(ZBPrinterDefaultCompletionHandler)completion {
    [self printWithPageBuilder:[ZBPrinterTestMaterialFactory testMaterialPageBuilderBlock] completion:completion];
}

- (void)printWithPageBuilder:(ZBPrinterPageBuilderBlock)builder completion:(ZBPrinterDefaultCompletionHandler)completion {
    if (!builder) {
        if (completion) {
            completion(nil);
        }
    }
    ZBPrinterPageBuilder *pageBuilder = [ZBPrinterPageBuilder new];
    builder(pageBuilder);
    NSMutableData *commandData = [NSMutableData data];
    [commandData appendData:[ZBPrinterCommandDataFactory commandDataForInitializeHardware]];
    [commandData appendData:[ZBPrinterCommandDataFactory commandDataForSelectPageMode]];
    [commandData appendData:pageBuilder.commandData];
    [commandData appendData:[ZBPrinterCommandDataFactory commandDataForPrintReturningToStandardMode]];
    [commandData appendData:[ZBPrinterCommandDataFactory commandDataForCutPaperAfterFeedingForwardBy:ZBPrinterDefaultFeedBeforeCutting mode:ZBPrinterPaperCutModePartial]];
    [self addSendDataTaskWithData:commandData completion:completion];
}

#pragma mark - Internals

- (NSUInteger)heightForText:(NSString *)text withCharacterFont:(ZBPrinterCharacterFont)characterFont verticalCharacterScale:(NSUInteger)vcs horizontalCharacterScale:(NSUInteger)hcs constrainedToWidth:(NSUInteger)width {
    double scaledCharacterWidth = (characterFont == ZBPrinterCharacterFont24x12 ? 12 : 8) * hcs;
    NSUInteger lineSpacing = [self lineHeightForCharacterFont:characterFont withVerticalCharacterScale:vcs];
    double characterPerLineInColumn = floor(width / scaledCharacterWidth);
    double numberOfLines = ceil(text.length / characterPerLineInColumn);
    return numberOfLines * lineSpacing - [self spaceBetweenLinesForCharacterFont:characterFont withScale:vcs];
}

- (NSUInteger)lineHeightForCharacterFont:(ZBPrinterCharacterFont)characterFont withVerticalCharacterScale:(NSUInteger)vcs {
    return [self heightForCharacterFont:characterFont withScale:vcs] + [self spaceBetweenLinesForCharacterFont:characterFont withScale:vcs];
}

- (NSUInteger)spaceBetweenLinesForCharacterFont:(ZBPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    NSUInteger scaledCharacterHeight = [self heightForCharacterFont:characterFont withScale:scale];
    return ceil(scaledCharacterHeight * ZBPrinterSpaceBetweenLinesFraction);
}

- (NSUInteger)heightForCharacterFont:(ZBPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    return [self heightForCharacterFont:characterFont] * scale;
}

- (NSUInteger)heightForCharacterFont:(ZBPrinterCharacterFont)characterFont {
    switch (characterFont) {
        case ZBPrinterCharacterFont24x12: return 24; break;
        case ZBPrinterCharacterFont16x8: return 16; break;
    }
}

@end
