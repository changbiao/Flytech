//
//  NSData+FTTrim.m
//  Flytech
//
//  Created by Rasmus Hummelmose on 07/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "NSData+FTTrim.h"

@implementation NSData (FTTrim)

- (NSData *)dataByTrimmingZeroBytes {
    NSMutableData *leadingZeroTrimmedData = [NSMutableData dataWithData:[self trimLeadingZeroBytesOfData:self]];
    NSData *reversedLeadingZeroTrimmedData = [self reverseData:leadingZeroTrimmedData];
    NSData *trimmedReversedData = [self trimLeadingZeroBytesOfData:reversedLeadingZeroTrimmedData];
    NSData *trimmedData = [self reverseData:trimmedReversedData];
    
    return trimmedData;
}

- (NSData *)trimLeadingZeroBytesOfData:(NSData *)data {
    NSMutableData *leadingZeroTrimmedData = [NSMutableData data];
    const char *bytes = data.bytes;
    for (NSUInteger index = 0; index < data.length; index++) {
        const char byte = bytes[index];
        if (leadingZeroTrimmedData.length || byte != 0x00) {
            [leadingZeroTrimmedData appendBytes:&byte length:1];
        }
    }

    return leadingZeroTrimmedData;
}

- (NSData *)reverseData:(NSData *)data {
    const char *bytes = data.bytes;
    int lastIndex = (int)data.length - 1;
    char *reversedBytes = calloc(sizeof(char), data.length);
    for (int i = 0; i < data.length; i++) {
        reversedBytes[lastIndex--] = bytes[i];
    }
    NSData *reversedData = [NSData dataWithBytes:reversedBytes length:data.length];
    free(reversedBytes);

    return reversedData;
}

@end
