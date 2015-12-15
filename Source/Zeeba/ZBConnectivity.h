//
//  ZBConnectivity.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 22/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZBZeeba;
@class ZBStand;

typedef NS_ENUM(NSUInteger, ZBConnectivity) {
    ZBConnectivityNone,
    ZBConnectivityDisconnected,
    ZBConnectivityConnecting,
    ZBConnectivityConnected,
    ZBConnectivityDisconnecting
};

@protocol ZBConnectivityObserver <NSObject>

- (void)zeeba:(ZBZeeba *)zeeba disconnectedStand:(ZBStand *)stand;

@end

@interface ZBConnectivityTools : NSObject

+ (NSString *)descriptionForConnectivity:(ZBConnectivity)connectivity;

- (instancetype)init NS_UNAVAILABLE;

@end
