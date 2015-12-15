//
//  ZBZeeba+SharedInstance.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBZeeba+SharedInstance.h"

@implementation ZBZeeba (SharedInstance)

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static ZBZeeba *sharedObject = nil;
    if (sharedObject) {
        return sharedObject;
    }
    dispatch_once(&pred, ^{
        sharedObject = [ZBZeeba alloc];
        sharedObject = [sharedObject init];
    });
    return sharedObject;
}

@end
