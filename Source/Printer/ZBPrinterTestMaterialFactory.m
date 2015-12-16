//
//  ZBPrinterTestMaterialFactory.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 15/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterTestMaterialFactory.h"
#import "ZBPrinterPageBuilder.h"

@implementation ZBPrinterTestMaterialFactory

#pragma mark - Public Interface

+ (ZBPrinterPageBuilderBlock)testMaterialPageBuilderBlock {
    id testMaterialPageBuilderBlock = ^(ZBPrinterPageBuilder *pageBuilder) {
        pageBuilder.verticalPageComponentPadding = 25;
        [pageBuilder addPageComponentWithText:@"Zeeba Example" font:ZBPrinterCharacterFont16x8 scale:3 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"Zeeba Street 1\nLondon" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"You were served by Mr. Zeeba" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addHorizontalLinePageComponent];
        for (NSUInteger index = 0; index < 2; index++) {
            ZBPrinterPageTextComponent *quantityTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"1" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
            ZBPrinterPageTextComponent *nameTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Zeeba Product" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
            ZBPrinterPageTextComponent *priceTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"10.00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
            NSArray *lineItemColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 10.0 textComponent:quantityTextComponent],
                                          [ZBPrinterPageColumn pageColumnWithWidthFraction:6 / 10.0 textComponent:nameTextComponent],
                                          [ZBPrinterPageColumn pageColumnWithWidthFraction:3 / 10.0 textComponent:priceTextComponent] ];
            [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:lineItemColumns horizontalPadding:20]];
        }
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *subtotalTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Subtotal" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
        ZBPrinterPageTextComponent *subtotalValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"16.67" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *subtotalColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:subtotalTitleTextComponent],
                                      [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:subtotalValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:subtotalColumns horizontalPadding:20]];
        ZBPrinterPageTextComponent *taxTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"VAT" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
        ZBPrinterPageTextComponent *taxValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"3.33" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *taxColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:taxTitleTextComponent],
                                 [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:taxValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:taxColumns horizontalPadding:20]];
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *totalTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Total" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
        ZBPrinterPageTextComponent *totalValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"20.00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *totalColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:totalTitleTextComponent],
                                   [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:totalValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:totalColumns horizontalPadding:20]];
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *cashTransactionTitleComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Cash" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
        ZBPrinterPageTextComponent *cashTransactionValueComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"20.00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *cashTransactionColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cashTransactionTitleComponent],
                                             [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cashTransactionValueComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:cashTransactionColumns horizontalPadding:20]];
    };
    return testMaterialPageBuilderBlock;
}

@end
