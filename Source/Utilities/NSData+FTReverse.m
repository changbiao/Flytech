//
//  NSData+FTReverse.m
//  Flytech
//
//  Created by Rasmus Hummelmose on 05/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "NSData+FTReverse.h"

@implementation NSData (FTReverse)

- (NSData *)reverse {
    const char *bytes = self.bytes;
    int lastIndex = (int)self.length - 1;
    char *reversedBytes = calloc(sizeof(char), self.length);
    for (int i = 0; i < self.length; i++) {
        reversedBytes[lastIndex--] = bytes[i];
    }
    NSData *reversedData = [NSData dataWithBytes:reversedBytes length:self.length];
    free(reversedBytes);

    return reversedData;
}

@end
