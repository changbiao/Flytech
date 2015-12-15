//
//  ZBStandModelNumberParser.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 29/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBStandModelNumberParser.h"

static NSString * const ZBStandModelNumberStringModelNumber = @"Model Number";

@implementation ZBStandModelNumberParser

+ (ZBStandModel)standModelForModelNumberString:(NSString *)modelNumberString {
    if ([modelNumberString isEqualToString:ZBStandModelNumberStringModelNumber]) {
        return ZBStandModelT605;
    }
    return ZBStandModelUnknown;
}

@end
