//
//  FTFlytech+SharedInstance.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTFlytech+SharedInstance.h"

@implementation FTFlytech (SharedInstance)

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static FTFlytech *sharedObject = nil;
    if (sharedObject) {
        return sharedObject;
    }
    dispatch_once(&pred, ^{
        sharedObject = [FTFlytech alloc];
        sharedObject = [sharedObject init];
    });
    return sharedObject;
}

@end
