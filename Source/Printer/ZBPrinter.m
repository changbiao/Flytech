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
        pageBuilder.verticalPageComponentPadding = 30;
        [pageBuilder addPageComponentWithText:@"Wallmob A/S" font:ZBPrinterCharacterFont16x8 scale:3 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"Volmers Plads 4\n7100 Vejle" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"CVR: 34624364\nTlf.: 71997540\nE-mail: hello@wallmob.com" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"You were served by Rasmus" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
        ZBPrinterPageTextComponent *dateTimeTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Dec 08, 2015 13:27" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *orderIdTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Order ID: 95028E22" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *dateTimeOrderIdColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:dateTimeTextComponent],
                                             [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:orderIdTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:dateTimeOrderIdColumns horizontalPadding:20]];
        [pageBuilder addPageComponentWithText:@"Store ID: Head Office" font:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"Register ID: Rasmus' iPad Mini" font:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addHorizontalLinePageComponent];
        for (NSUInteger index = 0; index < 5; index++) {
            ZBPrinterPageTextComponent *quantityTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"300" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
            ZBPrinterPageTextComponent *nameTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"There are many variations of available articles" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
            ZBPrinterPageTextComponent *priceTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"2.099,50" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
            NSArray *lineItemColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 10.0 textComponent:quantityTextComponent],
                                          [ZBPrinterPageColumn pageColumnWithWidthFraction:6 / 10.0 textComponent:nameTextComponent],
                                          [ZBPrinterPageColumn pageColumnWithWidthFraction:3 / 10.0 textComponent:priceTextComponent] ];
            [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:lineItemColumns horizontalPadding:20]];
        }
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *subtotalTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Subtotal" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *subtotalValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"12.877,30" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *subtotalColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:subtotalTitleTextComponent],
                                      [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:subtotalValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:subtotalColumns horizontalPadding:20]];
        ZBPrinterPageTextComponent *taxTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"VAT" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *taxValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"3.445,20" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *taxColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:taxTitleTextComponent],
                                 [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:taxValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:taxColumns horizontalPadding:20]];
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *totalTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Total" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *totalValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"31.334,40" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *totalColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:totalTitleTextComponent],
                                   [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:totalValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:totalColumns horizontalPadding:20]];
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *cashTransactionTitleComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Cash" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *cashTransactionValueComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"1.334,40" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *cashTransactionColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cashTransactionTitleComponent],
                                             [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cashTransactionValueComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:cashTransactionColumns horizontalPadding:20]];
        ZBPrinterPageTextComponent *cardTransactionTitleComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Card" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeZB];
        ZBPrinterPageTextComponent *cardTransactionValueComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"30.000,00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *cardTransactionColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cardTransactionTitleComponent],
                                             [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cardTransactionValueComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:cardTransactionColumns horizontalPadding:20]];
        [pageBuilder addHorizontalLinePageComponent];
        [pageBuilder addPageComponentWithText:@"Thank you for shopping with Wallmob.\nWe look forward to welcoming you to our store again.\nMerry christmas!" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
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
