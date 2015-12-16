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

/*!
 *  @enum ZBConnectivity
 *  @constant ZBConnectivityNone No connectivity information for the stand is available yet.
 *  @constant ZBConnectivityDisconnected The stand is disconnected.
 *  @constant ZBConnectivityConnecting The stand is connecting.
 *  @constant ZBConnectivityConnected The stand is connected.
 *  @constant ZBConnectivityDisconnecting The stand is disconnecting.
 */
typedef NS_ENUM(NSUInteger, ZBConnectivity) {
    ZBConnectivityNone,
    ZBConnectivityDisconnected,
    ZBConnectivityConnecting,
    ZBConnectivityConnected,
    ZBConnectivityDisconnecting
};

/*!
 *  @protocol ZBConnectivityObserver
 *  @discussion Implement this protocol to be able to subscribe to updates about stand connectivity.
 */
@protocol ZBConnectivityObserver <NSObject>

/*!
 *  @method zeeba:disconnectedStand:
 *  @discussion This method is called on the observer when a stand has disconnected.
 *  @param zeeba The ZBZeeba object that observed the disconnect.
 *  @param stand The ZBStand that disconnected.
 */
- (void)zeeba:(ZBZeeba *)zeeba disconnectedStand:(ZBStand *)stand;

@end

/*!
 *  @class ZBConnectivityTools
 *  @discussion Tools for transforming and working with ZBConnectivity values.
 */
@interface ZBConnectivityTools : NSObject

/*!
 *  @method descriptionForConnectivity:
 *  @discussion Returns a human readable representation of the ZBConnectivity value.
 *  @param connectivity The connectivity value.
 */
+ (NSString *)descriptionForConnectivity:(ZBConnectivity)connectivity;

/*!
 *  @method init
 *  @discussion Unavailable. Tools are provided through class methods alone.
 */
- (instancetype)init NS_UNAVAILABLE;

@end
