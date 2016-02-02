//
//  ZBPrinterColumnsContent.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 18/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterColumnsContent.h"

@implementation ZBPrinterColumnsContentColumn

#pragma mark - Public Interface

+ (instancetype)columnsContentColumnWithWidthFraction:(double)widthFraction content:(ZBPrinterContent *)content {
    ZBPrinterColumnsContentColumn *column = [ZBPrinterColumnsContentColumn new];
    column.widthFraction = widthFraction;
    column.content = content;
    return column;
}

@end

@implementation ZBPrinterColumnsContent

#pragma mark - Public Interface

@dynamic height;

+ (instancetype)columnsContentWithWidth:(NSUInteger)width columns:(NSArray *)columns horizontalPadding:(NSUInteger)horizontalPadding {
    ZBPrinterColumnsContent *columnsContent = [ZBPrinterColumnsContent new];
    columnsContent.width = width;
    columnsContent.columns = columns;
    columnsContent.horizontalPadding = horizontalPadding;
    return columnsContent;
}

- (NSUInteger)height {
    NSUInteger tallestColumnHeight = 0;
    for (ZBPrinterColumnsContentColumn *column in self.columns) {
        column.content.width = self.width * column.widthFraction;
        NSUInteger columnHeight = column.content.height;
        if (columnHeight > tallestColumnHeight) {
            tallestColumnHeight = columnHeight;
        }
    }
    return tallestColumnHeight;
}

- (NSData *)commandData {
    NSMutableData *commandData = [NSMutableData data];
    
    return commandData;
}

/*
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
*/

@end
