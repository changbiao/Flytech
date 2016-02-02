//
//  ZBPrinterColumnsContent.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 18/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBPrinterContent.h"

@interface ZBPrinterColumnsContentColumn : NSObject

@property (assign, nonatomic) double widthFraction;
@property (assign, nonatomic) ZBPrinterContent *content;

+ (instancetype)columnsContentColumnWithWidthFraction:(double)widthFraction content:(ZBPrinterContent *)content;

@end

@interface ZBPrinterColumnsContent : ZBPrinterContent

@property (assign, nonatomic, readonly) NSUInteger height;
@property (strong, nonatomic) NSArray *columns;
@property (assign, nonatomic) NSUInteger horizontalPadding;

+ (instancetype)columnsContentWithWidth:(NSUInteger)width columns:(NSArray *)columns horizontalPadding:(NSUInteger)horizontalPadding;

@end
