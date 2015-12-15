//
//  NSMutableData+ZBPrepend.m
//  Zeeba
//
//  Created by Rasmus Hummelmose on 10/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "NSMutableData+ZBPrepend.h"

@implementation NSMutableData (ZBPrepend)

- (void)prependBytes:(const void *)bytes length:(NSUInteger)length {
    NSData *dataToPrepend = [NSData dataWithBytes:bytes length:length];
    [self prependData:dataToPrepend];
}

- (void)prependData:(NSData *)data {
    NSMutableData *concatenation = [NSMutableData dataWithData:data];
    [concatenation appendData:self];
    [self setData:concatenation];
}

@end
