//
//  ZBBLEAvailability.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZBZeeba;

/*!
 *  @enum ZBBLEAvailability
 *  @discussion Represents the current availability state of BLE (Bluetooth Low Energy).
 *  @constant ZBBLEAvailabilityAvailable BLE is available
 *  @constant ZBBLEAvailabilityUnavailable BLE is unavailable for unknown reasons
 *  @constant ZBBLEAvailabilityUnavailableOff BLE is unavailable because Bluetooth is turned off
 *  @constant ZBBLEAvailabilityUnavailableResetting BLE is unavailable because the Bluetooth stack is resetting
 *  @constant ZBBLEAvailabilityUnavailableUnsupported BLE is unavailable because the device doesn't support it
 *  @constant ZBBLEAvailabilityUnavailableUnauthorized BLE is unavailable because the application isn't allowed to use it
 */
typedef NS_ENUM(NSInteger, ZBBLEAvailability) {
    ZBBLEAvailabilityAvailable = 1,
    ZBBLEAvailabilityUnavailable = -1,
    ZBBLEAvailabilityUnavailableOff = -2,
    ZBBLEAvailabilityUnavailableResetting = -3,
    ZBBLEAvailabilityUnavailableUnsupported = -4,
    ZBBLEAvailabilityUnavailableUnauthorized = -5
};

/*!
 *  @protocol ZBBLEAvailabilityObserver
 *  @discussion Implement this protocol to be able to subscribe to updates about BLE availability.
 */
@protocol ZBBLEAvailabilityObserver <NSObject>

/*!
 *  @method zeeba:availabilityChanged:
 *  @discussion This method is called when the availability of BLE changes.
 *  @param zeeba The ZBZeeba object that observed the change.
 *  @param availability The new availability state.
 */
- (void)zeeba:(ZBZeeba *)zeeba availabilityChanged:(ZBBLEAvailability)availability;

@end

/*!
 *  @class ZBBLEAvailabilityTools
 *  @discussion Tools for transforming and working with ZBBLEAvailability values.
 */
@interface ZBBLEAvailabilityTools: NSObject

/*!
 *  @method descriptionForAvailability:
 *  @discussion Returns a human readable descriptive string of the passed ZBBLEAvailability value.
 *  @param availability The availability value.
 */
+ (NSString *)descriptionForAvailability:(ZBBLEAvailability)availability;

/*!
 *  @method init
 *  @discussion Unavailable. Tools are provided through class methods alone.
 */
- (instancetype)init NS_UNAVAILABLE;

@end
