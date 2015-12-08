//
//  FTPrinterPageColumnsComponent.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinterPageColumnsComponent.h"

@implementation FTPrinterPageColumn

#pragma mark - Public Interface

+ (instancetype)pageColumnWithWidthFraction:(double)widthFraction textComponent:(FTPrinterPageTextComponent *)textComponent {
    FTPrinterPageColumn *pageColumn = [FTPrinterPageColumn new];
    pageColumn.widthFraction = widthFraction;
    pageColumn.textComponent = textComponent;
    return pageColumn;
}

@end

@implementation FTPrinterPageColumnsComponent

#pragma mark - Public Interface

+ (instancetype)pageColumnsComponentWithWidth:(NSUInteger)width columns:(NSArray *)columns horizontalPadding:(NSUInteger)horizontalPadding {
    FTPrinterPageColumnsComponent *pageColumnsComponent = [FTPrinterPageColumnsComponent new];
    pageColumnsComponent.width = width;
    pageColumnsComponent.columns = columns;
    pageColumnsComponent.horizontalPadding = horizontalPadding;
    return pageColumnsComponent;
}

#pragma mark - FTPrinterPageComponent

- (NSUInteger)height {
    NSUInteger tallestColumnHeight = 0;
    for (FTPrinterPageColumn *column in self.columns) {
        column.textComponent.width = self.width * column.widthFraction;
        NSUInteger columnHeight = column.textComponent.height;
        if (columnHeight > tallestColumnHeight) {
            tallestColumnHeight = columnHeight;
        }
    }
    return tallestColumnHeight;
}

- (NSData *)commandDataWithStartingPoint:(FTPrinterPagePoint)startingPoint {
    NSMutableData *commandData = [NSMutableData data];
    NSUInteger horizontalOffset = startingPoint.x;
    for (FTPrinterPageColumn *column in self.columns) {
        column.textComponent.width = (self.width - self.horizontalPadding * (self.columns.count - 1)) * column.widthFraction;
        [commandData appendData:[column.textComponent commandDataWithStartingPoint:FTPrinterPagePointMake(horizontalOffset, startingPoint.y)]];
        if (column != self.columns.lastObject) {
            horizontalOffset += column.textComponent.width + self.horizontalPadding;
        }
    }
    return commandData;
}

@end
