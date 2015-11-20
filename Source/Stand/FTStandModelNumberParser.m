//
//  FTStandModelNumberParser.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 29/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTStandModelNumberParser.h"

static NSString * const FTStandModelNumberStringModelNumber = @"Model Number";

@implementation FTStandModelNumberParser

+ (FTStandModel)standModelForModelNumberString:(NSString *)modelNumberString {
    if ([modelNumberString isEqualToString:FTStandModelNumberStringModelNumber]) {
        return FTStandModelT605;
    }
    return FTStandModelUnknown;
}

@end
