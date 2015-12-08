//
//  FTPrinter.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter.h"
#import "FTPrinter+Private.h"
#import "FTPrinter+HexCmd.h"
#import "NSData+FTHex.h"
#import "FTPrinter+Advanced.h"

@implementation FTPrinter

#pragma mark - Public Interface

- (void)printTestMaterialWithCompletion:(FTPrintCompletionHandler)completionHandler {
    [self initializeHardwareWithCompletion:nil];
    [self selectPageModeWithCompletion:nil];
    FTPrinterCharacterFont characterFont = FTPrinterCharacterFont24x12;
    NSUInteger horizontalPadding = 20;
    NSUInteger scale = 1;
    NSUInteger lineSpacing = [self lineHeightForCharacterFont:characterFont withVerticalCharacterScale:scale];
    
    NSString *column1Text = @"300";
    double column1WidthFraction = 1.0 / 10;
    NSUInteger column1Width = FTPrinterFullPageWidth * column1WidthFraction;
    NSUInteger column1Height = [self heightForText:column1Text withCharacterFont:characterFont verticalCharacterScale:scale horizontalCharacterScale:scale constrainedToWidth:column1Width];
    [self printAreaSetInPageModeWithX:0 y:0 width:column1Width height:column1Height completion:nil];
    [self lineSpacingSet:lineSpacing completion:nil];
    [self specifyCharacterScaleVertically:scale horizontally:scale completion:nil];
    [self specifyVerticalAbsolutePositionInPageMode:[self heightForCharacterFont:characterFont withScale:scale] completion:nil];
    [self printText:column1Text completion:nil];
    
    NSString *column2Text = @"There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour.";
    double column2WidthFraction = 6.0 / 10;
    NSUInteger column2Width = FTPrinterFullPageWidth * column2WidthFraction;
    NSUInteger column2Height = [self heightForText:column2Text withCharacterFont:characterFont verticalCharacterScale:scale horizontalCharacterScale:scale constrainedToWidth:column2Width];
    [self printAreaSetInPageModeWithX:column1Width + horizontalPadding y:0 width:column2Width height:column2Height completion:nil];
    [self lineSpacingSet:lineSpacing completion:nil];
    [self specifyCharacterScaleVertically:scale horizontally:scale completion:nil];
    [self specifyVerticalAbsolutePositionInPageMode:[self heightForCharacterFont:characterFont withScale:scale] completion:nil];
    [self printText:column2Text completion:nil];
    
    NSString *column3Text = @"4.000,00";
    double column3WidthFraction = 4.0 / 10;
    NSUInteger column3Width = FTPrinterFullPageWidth * column3WidthFraction;
    NSUInteger column3Height = [self heightForText:column3Text withCharacterFont:characterFont verticalCharacterScale:scale horizontalCharacterScale:scale constrainedToWidth:column3Width];
    [self printAreaSetInPageModeWithX:column1Width + horizontalPadding + column2Width + horizontalPadding y:0 width:column3Width height:column3Height completion:nil];
    [self lineSpacingSet:lineSpacing completion:nil];
    [self specifyCharacterScaleVertically:scale horizontally:scale completion:nil];
    [self specifyVerticalAbsolutePositionInPageMode:[self heightForCharacterFont:characterFont withScale:scale] completion:nil];
    [self setAlignment:FTPrinterAlignmentRight completion:nil];
    [self printText:column3Text completion:nil];
    
    [self printReturningToStandardModeWithCompletion:nil];
    [self cutPaperAfterFeedingForwardBy:FTPrinterDefaultFeedBeforeCutting mode:FTPrinterPaperCutModePartial completion:nil];
}

- (void)printWithPageBuilder:(FTPrinterPageBuilderBlock)builder completion:(FTPrinterDefaultCompletionHandler)completionHandler {
    if (!builder) {
        if (completionHandler) {
            completionHandler(nil);
        }
    }
    FTPrinterPageBuilder *pageBuilder = [FTPrinterPageBuilder new];
    builder(pageBuilder);
    NSMutableData *commandData = [NSMutableData data];
    [commandData appendData:[[self class] commandDataForInitializeHardware]];
    [commandData appendData:[[self class] commandDataForSelectPageMode]];
    [commandData appendData:pageBuilder.commandData];
    [commandData appendData:[[self class] commandDataForPrintReturningToStandardMode]];
    [commandData appendData:[[self class] commandDataForCutPaperAfterFeedingForwardBy:FTPrinterDefaultFeedBeforeCutting mode:FTPrinterPaperCutModePartial]];
    [self addSendDataTaskWithData:commandData completion:completionHandler];
}

#pragma mark - Internals

- (NSUInteger)heightForText:(NSString *)text withCharacterFont:(FTPrinterCharacterFont)characterFont verticalCharacterScale:(NSUInteger)vcs horizontalCharacterScale:(NSUInteger)hcs constrainedToWidth:(NSUInteger)width {
    double scaledCharacterWidth = (characterFont == FTPrinterCharacterFont24x12 ? 12 : 8) * hcs;
    NSUInteger lineSpacing = [self lineHeightForCharacterFont:characterFont withVerticalCharacterScale:vcs];
    double characterPerLineInColumn = floor(width / scaledCharacterWidth);
    double numberOfLines = ceil(text.length / characterPerLineInColumn);
    return numberOfLines * lineSpacing - [self spaceBetweenLinesForCharacterFont:characterFont withScale:vcs];
}

- (NSUInteger)lineHeightForCharacterFont:(FTPrinterCharacterFont)characterFont withVerticalCharacterScale:(NSUInteger)vcs {
    return [self heightForCharacterFont:characterFont withScale:vcs] + [self spaceBetweenLinesForCharacterFont:characterFont withScale:vcs];
}

- (NSUInteger)spaceBetweenLinesForCharacterFont:(FTPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    NSUInteger scaledCharacterHeight = [self heightForCharacterFont:characterFont withScale:scale];
    return ceil(scaledCharacterHeight * FTPrinterSpaceBetweenLinesFraction);
}

- (NSUInteger)heightForCharacterFont:(FTPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    return [self heightForCharacterFont:characterFont] * scale;
}

- (NSUInteger)heightForCharacterFont:(FTPrinterCharacterFont)characterFont {
    switch (characterFont) {
        case FTPrinterCharacterFont24x12: return 24; break;
        case FTPrinterCharacterFont16x8: return 16; break;
    }
}

@end
