//
//  ZBPrinterPageBuilder.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterPageBuilder.h"
#import "ZBPrinterPageTextComponent.h"

@interface ZBPrinterPageBuilder ()

@property (strong, nonatomic, readwrite) NSMutableArray *pageComponents;

@end

@implementation ZBPrinterPageBuilder

#pragma mark - Public Interface

- (NSData *)commandData {
    NSMutableData *commandData = [NSMutableData data];
    NSUInteger verticalOffset = 0;
    for (ZBPrinterPageComponent *pageComponent in self.pageComponents) {
        [commandData appendData:[pageComponent commandDataWithStartingPoint:ZBPrinterPagePointMake(0, verticalOffset) pageBuilder:self]];
        verticalOffset += pageComponent.height;
        if (pageComponent != self.pageComponents.lastObject) {
            verticalOffset += self.verticalPageComponentPadding;
        }
    }
    return commandData;
}

- (void)addPageComponent:(ZBPrinterPageComponent *)pageComponent {
    [self.pageComponents addObject:pageComponent];
}

- (void)addPageComponentWithText:(NSString *)text font:(ZBPrinterCharacterFont)font scale:(NSUInteger)scale alignment:(ZBPrinterAlignment)alignment {
    ZBPrinterPageTextComponent *pageTextComponent = [ZBPrinterPageTextComponent new];
    pageTextComponent.width = ZBPrinterFullPageWidth;
    pageTextComponent.text = text;
    pageTextComponent.characterFont = font;
    pageTextComponent.scale = scale;
    pageTextComponent.alignment = alignment;
    [self.pageComponents addObject:pageTextComponent];
}

- (void)addHorizontalLinePageComponent {
    ZBPrinterPageTextComponent *pageTextComponent = [ZBPrinterPageTextComponent new];
    pageTextComponent.width = ZBPrinterFullPageWidth;
    pageTextComponent.text = @"________________________________________________________________________ ";
    pageTextComponent.characterFont = ZBPrinterCharacterFont16x8;
    pageTextComponent.scale = 1;
    pageTextComponent.alignment = ZBPrinterAlignmentLeZB;
    [self.pageComponents addObject:pageTextComponent];
}

#pragma mark - Accessors

- (NSMutableArray *)pageComponents {
    if (!_pageComponents) {
        _pageComponents = [NSMutableArray array];
    }
    return _pageComponents;
}

@end
