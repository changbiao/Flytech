//
//  ZBPrinterPageBuilder.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBPrinter.h"
#import "ZBPrinterPageComponent.h"
#import "ZBPrinterPageTextComponent.h"
#import "ZBPrinterPageColumnsComponent.h"

@interface ZBPrinterPageBuilder : NSObject

@property (copy, nonatomic, readonly) NSData *commandData;
@property (strong, nonatomic, readonly) NSMutableArray *pageComponents;
@property (assign, nonatomic) NSUInteger verticalPageComponentPadding;
@property (assign, nonatomic) ZBPrinterCharacterFont currentCharacterFont;
@property (assign, nonatomic) NSUInteger currenctCharacterScale;
@property (assign, nonatomic) NSUInteger currentLineSpacing;
@property (assign, nonatomic) NSUInteger currentVerticalAbsolutePosition;
@property (assign, nonatomic) NSUInteger currentHorizontalAbsolutePosition;

- (void)addPageComponent:(ZBPrinterPageComponent *)pageComponent;
- (void)addPageComponentWithText:(NSString *)text font:(ZBPrinterCharacterFont)font scale:(NSUInteger)scale alignment:(ZBPrinterAlignment)alignment;
- (void)addHorizontalLinePageComponent;

@end
