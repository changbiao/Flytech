//
//  NSMutableData+ZBPrepend.h
//  Zeeba
//
//  Created by Rasmus Hummelmose on 10/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (ZBPrepend)

- (void)prependBytes:(const void *)bytes length:(NSUInteger)length;

- (void)prependData:(NSData *)data;

@end
