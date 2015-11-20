//
//  NSString+FTHex.m
//  Flytech
//
//  Created by Rasmus Hummelmose on 11/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "NSString+FTHex.h"

@implementation NSString (FTHex)

- (NSUInteger)hexLength {
    NSString *cleanHexString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return ceil(cleanHexString.length / 2);
}

@end
