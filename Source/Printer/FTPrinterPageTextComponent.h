//
//  FTPrinterPageTextComponent.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPrinter+Advanced.h"
#import "FTPrinterPageComponent.h"

@interface FTPrinterPageTextComponent : FTPrinterPageComponent

@property (assign, nonatomic) FTPrinterCharacterFont characterFont;
@property (assign, nonatomic) NSUInteger scale;
@property (assign, nonatomic) FTPrinterAlignment alignment;
@property (copy, nonatomic) NSString *text;

+ (instancetype)pageTextComponentWithWidth:(NSUInteger)width text:(NSString *)text characterFont:(FTPrinterCharacterFont)characterFont scale:(NSUInteger)scale alignment:(FTPrinterAlignment)alignment;
+ (instancetype)pageTextComponentWithText:(NSString *)text characterFont:(FTPrinterCharacterFont)characterFont scale:(NSUInteger)scale alignment:(FTPrinterAlignment)alignment;

@end
