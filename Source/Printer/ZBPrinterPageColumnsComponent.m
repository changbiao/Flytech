//
//  ZBPrinterPageColumnsComponent.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterPageColumnsComponent.h"

@implementation ZBPrinterPageColumn

#pragma mark - Public Interface

+ (instancetype)pageColumnWithWidthFraction:(double)widthFraction textComponent:(ZBPrinterPageTextComponent *)textComponent {
    ZBPrinterPageColumn *pageColumn = [ZBPrinterPageColumn new];
    pageColumn.widthFraction = widthFraction;
    pageColumn.textComponent = textComponent;
    return pageColumn;
}

@end

@implementation ZBPrinterPageColumnsComponent

#pragma mark - Public Interface

+ (instancetype)pageColumnsComponentWithWidth:(NSUInteger)width columns:(NSArray *)columns horizontalPadding:(NSUInteger)horizontalPadding {
    ZBPrinterPageColumnsComponent *pageColumnsComponent = [ZBPrinterPageColumnsComponent new];
    pageColumnsComponent.width = width;
    pageColumnsComponent.columns = columns;
    pageColumnsComponent.horizontalPadding = horizontalPadding;
    return pageColumnsComponent;
}

#pragma mark - ZBPrinterPageComponent

- (NSUInteger)height {
    NSUInteger tallestColumnHeight = 0;
    for (ZBPrinterPageColumn *column in self.columns) {
        column.textComponent.width = self.width * column.widthFraction;
        NSUInteger columnHeight = column.textComponent.height;
        if (columnHeight > tallestColumnHeight) {
            tallestColumnHeight = columnHeight;
        }
    }
    return tallestColumnHeight;
}

- (NSData *)commandDataWithStartingPoint:(ZBPrinterPagePoint)startingPoint pageBuilder:(ZBPrinterPageBuilder *)pageBuilder {
    NSMutableData *commandData = [NSMutableData data];
    NSUInteger horizontalOffset = startingPoint.x;
    for (ZBPrinterPageColumn *column in self.columns) {
        column.textComponent.width = (self.width - self.horizontalPadding * (self.columns.count - 1)) * column.widthFraction;
        [commandData appendData:[column.textComponent commandDataWithStartingPoint:ZBPrinterPagePointMake(horizontalOffset, startingPoint.y) pageBuilder:pageBuilder]];
        if (column != self.columns.lastObject) {
            horizontalOffset += column.textComponent.width + self.horizontalPadding;
        }
    }
    return commandData;
}

@end
