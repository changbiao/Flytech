//
//  NSData+FTTrim.h
//  Flytech
//
//  Created by Rasmus Hummelmose on 07/07/14.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (FTTrim)

- (NSData *)dataByTrimmingZeroBytes;

@end
