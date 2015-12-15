//
//  ZBPrinterPageTextComponent.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBPrinter+Advanced.h"
#import "ZBPrinterPageComponent.h"

@interface ZBPrinterPageTextComponent : ZBPrinterPageComponent

@property (assign, nonatomic) ZBPrinterCharacterFont characterFont;
@property (assign, nonatomic) NSUInteger scale;
@property (assign, nonatomic) ZBPrinterAlignment alignment;
@property (copy, nonatomic) NSString *text;

+ (instancetype)pageTextComponentWithWidth:(NSUInteger)width text:(NSString *)text characterFont:(ZBPrinterCharacterFont)characterFont scale:(NSUInteger)scale alignment:(ZBPrinterAlignment)alignment;
+ (instancetype)pageTextComponentWithText:(NSString *)text characterFont:(ZBPrinterCharacterFont)characterFont scale:(NSUInteger)scale alignment:(ZBPrinterAlignment)alignment;

@end
