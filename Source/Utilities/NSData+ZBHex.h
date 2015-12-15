//
//  NSData+ZBHex.h
//  Zeeba
//
//  Created by Rasmus Hummelmose on 10/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZBHex)

+ (instancetype)dataWithHex:(NSString *)hexString;

- (NSString *)hexRepresentation;

@end

@interface NSMutableData (ZBHex)

+ (instancetype)dataWithHex:(NSString *)hexString;
- (void)appendHex:(NSString *)hexString;

@end