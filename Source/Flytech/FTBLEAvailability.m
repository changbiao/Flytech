//
//  FTBLEAvailability.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTBLEAvailability.h"

@implementation FTBLEAvailabilityTools

#pragma mark - Public Interface

+ (NSString *)descriptionForAvailability:(FTBLEAvailability)availability {
    NSString *state = availability == FTBLEAvailabilityAvailable ? @"YES" : @"NO";
    NSString *unavailabilityCause = [self stringForUnavailabilityCauseFromAvailability:availability];
    return [NSString stringWithFormat:@"Available: %@ | Unavailability cause: %@", state, unavailabilityCause];
}

#pragma mark - Internals

+ (NSString *)stringForUnavailabilityCauseFromAvailability:(FTBLEAvailability)availability {
    switch (availability) {
        case FTBLEAvailabilityUnavailableOff: return @"Off"; break;
        case FTBLEAvailabilityUnavailableResetting: return @"Resetting"; break;
        case FTBLEAvailabilityUnavailableUnsupported: return @"Unsupported"; break;
        case FTBLEAvailabilityUnavailableUnauthorized: return @"Unauthorized"; break;
        default: return @"None"; break;
    }
}

@end
