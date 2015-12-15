//
//  ZBConnectivity.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 22/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBConnectivity.h"

@implementation ZBConnectivityTools

#pragma mark - Public Interface

+ (NSString *)descriptionForConnectivity:(ZBConnectivity)connectivity {
    switch (connectivity) {
        case ZBConnectivityNone: return @"None"; break;
        case ZBConnectivityConnected: return @"Connected"; break;
        case ZBConnectivityConnecting: return @"Connecting"; break;
        case ZBConnectivityDisconnected: return @"Disconnected"; break;
        case ZBConnectivityDisconnecting: return @"Disconnecting"; break;
    }
}

@end
