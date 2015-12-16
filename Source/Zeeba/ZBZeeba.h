//
//  ZBZeeba.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBBLEAvailability.h"

NS_ASSUME_NONNULL_BEGIN

@class ZBZeeba;
@class ZBStand;
@protocol ZBConnectivityObserver;

typedef void(^ZBDiscoveryHandler)(ZBStand *discoveredStand);
typedef void(^ZBDiscoveryCompletionHandler)(NSArray<ZBStand *>  * _Nullable discoveredStands, NSError * _Nullable error);
typedef void(^ZBConnectCompletionHandler)(ZBStand *stand, NSError * _Nullable error);

/*!
 *  @constant ZBTimeoutInfinity
 *  @discussion Pass this constant in order to disable timeout during stand connection or discovery.
 */
extern NSTimeInterval const ZBTimeoutInfinity;

/*!
 *  @class ZBZeeba
 *  @discussion The entry point class for interaction with the SDK.
 */
@interface ZBZeeba : NSObject

/*!
 *  @property availabilityObservers
 *  @discussion The objects that are subscribed to receive changes to availability.
 */
@property (copy, nonatomic, readonly) NSSet<id<ZBBLEAvailabilityObserver>> *availabilityObservers;

/*!
 *  @property connectivityObservers
 *  @discussion The objects that are subscribed to receive changes to connectivity.
 */
@property (copy, nonatomic, readonly) NSSet<id<ZBConnectivityObserver>> *connectivityObservers;

/*!
 *  @property availability
 *  @discussion The current availability of Bluetooth Low Energy.
 */
@property (assign, nonatomic, readonly) ZBBLEAvailability availability;

/*!
 *  @property stands
 *  @discussion The Zeeba stands that are currently connecting, connected or disconnecting.
 */
@property (copy, nonatomic, readonly) NSSet<ZBStand *> *stands;

/*!
 *  @property connectedStands
 *  @discussion The Zeeba stands that are currently connected.
 */
@property (copy, nonatomic, readonly) NSSet<ZBStand *> *connectedStands;

/*!
 *  @method startWithZeebaSDKKey:
 *  @discussion Starts the underlying Bluetooth stack, after which point the observers will receive updates and method calls can be made.
 *  @param zeebaSDKKey The SDK key you received for your organization.
 */
- (void)startWithZeebaSDKKey:(NSString *)zeebaSDKKey;

/*!
 *  @method stop
 *  @discussion Stops the underlying Bluetooth stack.
 */
- (void)stop;

/*!
 *  @method addAvailabilityObserver:
 *  @discussion Add an availability observer that will receive changes to BLE availability.
 *  @param availabilityObserver The availability observer to add.
 *  @see start
 */
- (void)addAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver;

/*!
 *  @method removeAvailabilityObserver:
 *  @discussion Remove an availability observer that should no longer receive changes to BLE availability.
 *  @param availabilityObserver The availability observer to remove.
 */
- (void)removeAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver;

/*!
 *  @method addConnectivityObserver:
 *  @discussion Add a connectivity observer that will receive changes to connectivity for managed Zeeba stands.
 *  @param connectivityObserver The connectivity observer to add.
 */
- (void)addConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver;

/*!
 *  @method removeConnectivityObserver:
 *  @discussion Remove a connectivity observer that should no longer receive changes to connectivity for managed Zeeba stands.
 *  @param connectivityObserver The connectivity observer to remove.
 */
- (void)removeConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver;

/*!
 *  @method discoverStandsWithTimeout:discovery:completion
 *  @discussion Discover Zeeba stands within range.
 *  @param timeout The number of seconds for which the scan will proceed before calling the completion handler.
 *  @param discovery A handler that is called each time a new Zeeba stand is discovered, with the stand passed as the only argument.
 *  @param completion A handler that is called when discovery ends, with the discovered stands and an optional error as arguments.
 */
- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discovery:(nullable ZBDiscoveryHandler)discovery completion:(ZBDiscoveryCompletionHandler)completion;

/*!
 *  @method stopDiscovery
 *  @discussion Stops an active discovery, causing its completion to be called with the discovered stands.
 */
- (void)stopDiscovery;

/*!
 *  @method connectStand:timeout:completion:
 *  @discussion Connects to a stand with a given timeout and completion handler.
 *  @param stand The stand that should be connected to.
 *  @param timeout The timeout for the stand connection attempt. Use ZBTimeoutInfinity to disable timeout.
 *  @param completion A completion handler that will be called after the connection attempt with the stand and an optional error.
 */
- (void)connectStand:(ZBStand *)stand timeout:(NSTimeInterval)timeout completion:(ZBConnectCompletionHandler)completion;

/*!
 *  @method disconnectStand:
 *  @discussion Disconnects from a connected stand or interrupts an active connection attempt.
 *  @param stand The stand that should be disconnected from.
 */
- (void)disconnectStand:(ZBStand *)stand;

@end

NS_ASSUME_NONNULL_END
