//
//  NSData+ZBTrim.h
//  Zeeba
//
//  Created by Rasmus Hummelmose on 07/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZBTrim)

- (NSData *)dataByTrimmingZeroBytes;

@end
