//
//  NSData+FTHex.m
//  Flytech
//
//  Created by Rasmus Hummelmose on 10/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "NSData+FTHex.h"

@implementation NSData (FTHex)

+ (instancetype)dataWithHex:(NSString *)hexString {
    NSString *cleanHexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data = [NSMutableData dataWithCapacity:ceil(cleanHexString.length / 2)];
    unsigned char wholeByte;
    char byteChars[3] = {'\0','\0','\0'};
    for (NSUInteger iterator = 0; iterator < [cleanHexString length] / 2; iterator++) {
        byteChars[0] = [cleanHexString characterAtIndex:iterator * 2];
        byteChars[1] = [cleanHexString characterAtIndex:iterator * 2 + 1];
        wholeByte = strtol(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

- (NSString *)hexRepresentation {
    NSUInteger capacity = self.length * 2;
    NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
    const unsigned char *buf = self.bytes;
    NSInteger i;
    for (i = 0; i < self.length; ++i) {
        [sbuf appendFormat:@"%02lX", (unsigned long)buf[i]];
    }
    return [sbuf uppercaseString];
}

@end


@implementation NSMutableData (FTHex)

+ (instancetype)dataWithHex:(NSString *)hexString {
    return [self dataWithData:[super dataWithHex:hexString]];
}

- (void)appendHex:(NSString *)hexString {
    NSString *cleanHexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data = [NSMutableData dataWithCapacity:ceil(cleanHexString.length / 2)];
    unsigned char wholeByte;
    char byteChars[3] = {'\0','\0','\0'};
    for (NSUInteger iterator = 0; iterator < [cleanHexString length] / 2; iterator++) {
        byteChars[0] = [cleanHexString characterAtIndex:iterator * 2];
        byteChars[1] = [cleanHexString characterAtIndex:iterator * 2 + 1];
        wholeByte = strtol(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    [self appendData:data];
}

@end