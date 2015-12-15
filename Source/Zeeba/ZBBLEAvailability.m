//
//  ZBBLEAvailability.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBBLEAvailability.h"

@implementation ZBBLEAvailabilityTools

#pragma mark - Public Interface

+ (NSString *)descriptionForAvailability:(ZBBLEAvailability)availability {
    NSString *state = availability == ZBBLEAvailabilityAvailable ? @"YES" : @"NO";
    NSString *unavailabilityCause = [self stringForUnavailabilityCauseFromAvailability:availability];
    return [NSString stringWithFormat:@"Available: %@ | Unavailability cause: %@", state, unavailabilityCause];
}

#pragma mark - Internals

+ (NSString *)stringForUnavailabilityCauseFromAvailability:(ZBBLEAvailability)availability {
    switch (availability) {
        case ZBBLEAvailabilityUnavailableOff: return @"Off"; break;
        case ZBBLEAvailabilityUnavailableResetting: return @"Resetting"; break;
        case ZBBLEAvailabilityUnavailableUnsupported: return @"Unsupported"; break;
        case ZBBLEAvailabilityUnavailableUnauthorized: return @"Unauthorized"; break;
        default: return @"None"; break;
    }
}

@end
