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

@implementation ZBPrinter

#pragma mark - Public Interface

- (void)printTestMaterialWithCompletion:(ZBPrintCompletionHandler)completionHandler {
    [self printWithPageBuilder:^(ZBPrinterPageBuilder *pageBuilder) {
        pageBuilder.verticalPageComponentPadding = 25;
        [pageBuilder addPageComponentWithText:@"Zeeba Example" font:ZBPrinterCharacterFont16x8 scale:3 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"Zeeba Street 1\nLondon" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"You were served by Mr. Zeeba" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addHorizontalLinePageComponent];
        for (NSUInteger index = 0; index < 2; index++) {
            ZBPrinterPageTextComponent *quantityTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"1" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
            ZBPrinterPageTextComponent *nameTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Zeeba Product" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
            ZBPrinterPageTextComponent *priceTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"10.00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
            NSArray *lineItemColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 10.0 textComponent:quantityTextComponent],
                                          [ZBPrinterPageColumn pageColumnWithWidthFraction:6 / 10.0 textComponent:nameTextComponent],
                                          [ZBPrinterPageColumn pageColumnWithWidthFraction:3 / 10.0 textComponent:priceTextComponent] ];
            [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:lineItemColumns horizontalPadding:20]];
        }
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *subtotalTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Subtotal" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *subtotalValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"16.67" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *subtotalColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:subtotalTitleTextComponent],
                                      [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:subtotalValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:subtotalColumns horizontalPadding:20]];
        ZBPrinterPageTextComponent *taxTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"VAT" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *taxValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"3.33" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *taxColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:taxTitleTextComponent],
                                 [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:taxValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:taxColumns horizontalPadding:20]];
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *totalTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Total" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *totalValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"20.00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *totalColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:totalTitleTextComponent],
                                   [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:totalValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:totalColumns horizontalPadding:20]];
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *cashTransactionTitleComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Cash" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *cashTransactionValueComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"20.00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *cashTransactionColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cashTransactionTitleComponent],
                                             [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cashTransactionValueComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:cashTransactionColumns horizontalPadding:20]];
    } completion:completionHandler];
}

- (void)printWithPageBuilder:(ZBPrinterPageBuilderBlock)builder completion:(ZBPrinterDefaultCompletionHandler)completionHandler {
    if (!builder) {
        if (completionHandler) {
            completionHandler(nil);
        }
    }
    ZBPrinterPageBuilder *pageBuilder = [ZBPrinterPageBuilder new];
    builder(pageBuilder);
    NSMutableData *commandData = [NSMutableData data];
    [commandData appendData:[[self class] commandDataForInitializeHardware]];
    [commandData appendData:[[self class] commandDataForSelectPageMode]];
    [commandData appendData:pageBuilder.commandData];
    [commandData appendData:[[self class] commandDataForPrintReturningToStandardMode]];
    [commandData appendData:[[self class] commandDataForCutPaperAZBerFeedingForwardBy:ZBPrinterDefaultFeedBeforeCutting mode:ZBPrinterPaperCutModePartial]];
    [self addSendDataTaskWithData:commandData completion:completionHandler];
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
