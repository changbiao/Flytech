//
//  ZBPrinterPageBuilder+Optimization.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 16/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterPageBuilder+Optimization.h"
#import <objc/runtime.h>

@implementation ZBPrinterPageBuilder (Optimization)

#pragma mark - Accessors

- (ZBPrinterCharacterFont)currentCharacterFont {
    return [objc_getAssociatedObject(self, @selector(currentCharacterFont)) unsignedIntegerValue];
}

- (NSUInteger)currentCharacterScale {
    return [objc_getAssociatedObject(self, @selector(currentCharacterScale)) unsignedIntegerValue];
}

- (NSUInteger)currentLineSpacing {
    return [objc_getAssociatedObject(self, @selector(currentLineSpacing)) unsignedIntegerValue];
}

#pragma mark - Mutators

- (void)setCurrentCharacterFont:(ZBPrinterCharacterFont)currentCharacterFont {
    objc_setAssociatedObject(self, @selector(currentCharacterFont), @(currentCharacterFont), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setCurrentCharacterScale:(NSUInteger)currenctCharacterScale {
    objc_setAssociatedObject(self, @selector(currentCharacterScale), @(currenctCharacterScale), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setCurrentLineSpacing:(NSUInteger)currentLineSpacing {
    objc_setAssociatedObject(self, @selector(currentLineSpacing), @(currentLineSpacing), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
