//
//  FTBLEAvailability.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTFlytech;

typedef NS_ENUM(NSInteger, FTBLEAvailability) {
    FTBLEAvailabilityAvailable = 1,
    FTBLEAvailabilityUnavailable = -1,
    FTBLEAvailabilityUnavailableOff = -2,
    FTBLEAvailabilityUnavailableResetting = -3,
    FTBLEAvailabilityUnavailableUnsupported = -4,
    FTBLEAvailabilityUnavailableUnauthorized = -5
};

@protocol FTBLEAvailabilityObserver <NSObject>

- (void)flytech:(FTFlytech *)flytech availabilityChanged:(FTBLEAvailability)availability;

@end

@interface FTBLEAvailabilityTools: NSObject

+ (NSString *)descriptionForAvailability:(FTBLEAvailability)availability;

- (instancetype)init NS_UNAVAILABLE;

@end
