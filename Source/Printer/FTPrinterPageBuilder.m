//
//  FTPrinterPageBuilder.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinterPageBuilder.h"
#import "FTPrinterPageTextComponent.h"

@interface FTPrinterPageBuilder ()

@property (strong, nonatomic, readwrite) NSMutableArray *pageComponents;

@end

@implementation FTPrinterPageBuilder

#pragma mark - Public Interface

- (NSData *)commandData {
    NSMutableData *commandData = [NSMutableData data];
    NSUInteger verticalOffset = 0;
    for (FTPrinterPageComponent *pageComponent in self.pageComponents) {
        [commandData appendData:[pageComponent commandDataWithStartingPoint:FTPrinterPagePointMake(0, verticalOffset)]];
        verticalOffset += pageComponent.height;
        if (pageComponent != self.pageComponents.lastObject) {
            verticalOffset += self.verticalPageComponentPadding;
        }
    }
    return commandData;
}

- (void)addPageComponent:(FTPrinterPageComponent *)pageComponent {
    [self.pageComponents addObject:pageComponent];
}

- (void)addPageComponentWithText:(NSString *)text font:(FTPrinterCharacterFont)font scale:(NSUInteger)scale alignment:(FTPrinterAlignment)alignment {
    FTPrinterPageTextComponent *pageTextComponent = [FTPrinterPageTextComponent new];
    pageTextComponent.width = FTPrinterFullPageWidth;
    pageTextComponent.text = text;
    pageTextComponent.characterFont = font;
    pageTextComponent.scale = scale;
    pageTextComponent.alignment = alignment;
    [self.pageComponents addObject:pageTextComponent];
}

- (void)addHorizontalLinePageComponent {
    FTPrinterPageTextComponent *pageTextComponent = [FTPrinterPageTextComponent new];
    pageTextComponent.width = FTPrinterFullPageWidth;
    pageTextComponent.text = @"________________________________________________________________________ ";
    pageTextComponent.characterFont = FTPrinterCharacterFont16x8;
    pageTextComponent.scale = 1;
    pageTextComponent.alignment = FTPrinterAlignmentLeft;
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
