//
//  ZBPrinterPageColumnsComponent.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBPrinterPageComponent.h"
#import "ZBPrinterPageTextComponent.h"

@interface ZBPrinterPageColumn : NSObject

@property (assign, nonatomic) double widthFraction;
@property (strong, nonatomic) ZBPrinterPageTextComponent *textComponent;

+ (instancetype)pageColumnWithWidthFraction:(double)widthFraction textComponent:(ZBPrinterPageTextComponent *)textComponent;

@end

@interface ZBPrinterPageColumnsComponent : ZBPrinterPageComponent

@property (copy, nonatomic) NSArray *columns;
@property (assign, nonatomic) NSUInteger horizontalPadding;

+ (instancetype)pageColumnsComponentWithWidth:(NSUInteger)width columns:(NSArray *)columns horizontalPadding:(NSUInteger)horizontalPadding;

@end
