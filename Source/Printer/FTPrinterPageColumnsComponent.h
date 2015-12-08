//
//  FTPrinterPageColumnsComponent.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPrinterPageComponent.h"
#import "FTPrinterPageTextComponent.h"

@interface FTPrinterPageColumn : NSObject

@property (assign, nonatomic) double widthFraction;
@property (strong, nonatomic) FTPrinterPageTextComponent *textComponent;

+ (instancetype)pageColumnWithWidthFraction:(double)widthFraction textComponent:(FTPrinterPageTextComponent *)textComponent;

@end

@interface FTPrinterPageColumnsComponent : FTPrinterPageComponent

@property (copy, nonatomic) NSArray *columns;
@property (assign, nonatomic) NSUInteger horizontalPadding;

+ (instancetype)pageColumnsComponentWithWidth:(NSUInteger)width columns:(NSArray *)columns horizontalPadding:(NSUInteger)horizontalPadding;

@end
