//
//  ZBBLEAvailability.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZBZeeba;

typedef NS_ENUM(NSInteger, ZBBLEAvailability) {
    ZBBLEAvailabilityAvailable = 1,
    ZBBLEAvailabilityUnavailable = -1,
    ZBBLEAvailabilityUnavailableOff = -2,
    ZBBLEAvailabilityUnavailableResetting = -3,
    ZBBLEAvailabilityUnavailableUnsupported = -4,
    ZBBLEAvailabilityUnavailableUnauthorized = -5
};

@protocol ZBBLEAvailabilityObserver <NSObject>

- (void)zeeba:(ZBZeeba *)zeeba availabilityChanged:(ZBBLEAvailability)availability;

@end

@interface ZBBLEAvailabilityTools: NSObject

+ (NSString *)descriptionForAvailability:(ZBBLEAvailability)availability;

- (instancetype)init NS_UNAVAILABLE;

@end
