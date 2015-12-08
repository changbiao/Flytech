//
//  NSString+FTWordWrap.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 08/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FTWordWrap)

- (NSArray<NSString *> *)linesByWordWrappingToMaxCharactersPerLine:(NSUInteger)mcpl;

@end
