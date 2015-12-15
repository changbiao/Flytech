//
//  NSData+ZBDescriptionBits.m
//  Zeeba
//
//  Created by Rasmus Hummelmose on 08/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "NSData+ZBDescriptionBits.h"

@implementation NSData (ZBDescriptionBits)

- (NSString *)descriptionWithBits {
    NSMutableString *bits = [NSMutableString string];
    const char *bytes = self.bytes;
    NSUInteger length = self.length;
    for (NSUInteger index = 0; index < length; index++) {
        char byte = bytes[index];
        char bitArray[9];
        bitArray[8] = 0;
        NSUInteger bitIndex = 8;
        while (bitIndex > 0) {
            if (byte & 0x01) {
                bitArray[--bitIndex] = '1';
            } else {
                bitArray[--bitIndex] = '0';
            }
            byte >>= 1;
        }
        NSString *bitString = [[NSString alloc] initWithCString:bitArray encoding:NSASCIIStringEncoding];
        [bits appendFormat:@"%@ ", bitString];
    }

    return [self.description stringByAppendingFormat:@" Bits: %@", bits];
}

@end
