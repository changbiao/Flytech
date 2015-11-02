//
//  FTConnectivity.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 22/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTConnectivity.h"

@implementation FTConnectivityTools

#pragma mark - Public Interface

+ (NSString *)descriptionForConnectivity:(FTConnectivity)connectivity {
    switch (connectivity) {
        case FTConnectivityNone: return @"None"; break;
        case FTConnectivityConnected: return @"Connected"; break;
        case FTConnectivityConnecting: return @"Connecting"; break;
        case FTConnectivityDisconnected: return @"Disconnected"; break;
        case FTConnectivityDisconnecting: return @"Disconnecting"; break;
    }
}

@end
