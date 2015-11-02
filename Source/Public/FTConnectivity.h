//
//  FTConnectivity.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 22/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTFlytech;
@class FTStand;

typedef NS_ENUM(NSUInteger, FTConnectivity) {
    FTConnectivityNone,
    FTConnectivityDisconnected,
    FTConnectivityConnecting,
    FTConnectivityConnected,
    FTConnectivityDisconnecting
};

@protocol FTConnectivityObserver <NSObject>

- (void)flytech:(FTFlytech *)flytech disconnectedStand:(FTStand *)stand;

@end

@interface FTConnectivityTools : NSObject

+ (NSString *)descriptionForConnectivity:(FTConnectivity)connectivity;

- (instancetype)init NS_UNAVAILABLE;

@end
