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

extern NSTimeInterval const ZBTimeoutInfinity;

typedef void(^ZBDiscoveryHandler)(ZBStand *discoveredStand);
typedef void(^ZBDiscoveryCompletionHandler)(NSArray<ZBStand *>  * _Nullable discoveredStands, NSError * _Nullable error);
typedef void(^ZBConnectCompletionHandler)(ZBStand *stand, NSError * _Nullable error);

@interface ZBZeeba : NSObject

/**
 The objects that are subscribed to receive changes to availability.
 */
@property (copy, nonatomic, readonly) NSSet<id<ZBBLEAvailabilityObserver>> *availabilityObservers;

/**
 The objects that are subscribed to receive changes to connectivity.
 */
@property (copy, nonatomic, readonly) NSSet<id<ZBConnectivityObserver>> *connectivityObservers;

/**
 The current availability of Bluetooth Low Energy.
 */
@property (assign, nonatomic, readonly) ZBBLEAvailability availability;

/**
 The Zeeba stands that are currently connecting, connected or disconnecting.
 */
@property (copy, nonatomic, readonly) NSSet<ZBStand *> *stands;

/**
 The Zeeba stands that are currently connected.
 */
@property (copy, nonatomic, readonly) NSSet<ZBStand *> *connectedStands;

/**
 Starts the underlying Bluetooth stack, after which point the observers will receive updates and method calls can be made.
 */
- (void)startWithZeebaSDKKey:(NSString *)zeebaSDKKey;

/**
 Stops the underlying Bluetooth stack.
 */
- (void)stop;

/**
 Add an availability observer that will receive changes to BLE availability.
 @param availabilityObserver The availability observer to add.
 @see start
 */
- (void)addAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver;

/**
 Remove an availability observer that should no longer receive changes to BLE availability.
 @param availabilityObserver The availability observer to remove.
 */
- (void)removeAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver;

/**
 Add a connectivity observer that will receive changes to connectivity for managed Zeeba stands.
 @param connectivityObserver The connectivity observer to add.
 */
- (void)addConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver;

/**
 Remove a connectivity observer that should no longer receive changes to connectivity for managed Zeeba stands.
 @param connectivityObserver The connectivity observer to remove.
 */
- (void)removeConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver;

/**
 Discover Zeeba stands within range.
 @param timeout The number of seconds for which the scan will proceed before calling the completion handler.
 @param discoveryHandler A handler that is called each time a new Zeeba stand is discovered, with the stand passed as the only argument.
 @param completionHandler A handler that is called when discovery ends, with the discovered stands and an optional error as arguments.
 */
- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discoveryHandler:(nullable ZBDiscoveryHandler)discoveryHandler completionHandler:(ZBDiscoveryCompletionHandler)completionHandler;

/**
 Stops an active discovery, causing its completionHandler to be called with the discovered stands.
 */
- (void)stopDiscovery;

/**
 Connects to a stand with a given timeout and completion handler.
 @param stand The stand that should be connected to.
 @param timeout The timeout for the stand connection attempt. Use ZBTimeoutInfinity to disable timeout.
 @param completionHandler A completion handler that will be called after the connection attempt with the stand and an optional error.
 */
- (void)connectStand:(ZBStand *)stand timeout:(NSTimeInterval)timeout completionHandler:(ZBConnectCompletionHandler)completionHandler;

/**
 Disconnects from a connected stand or interrupts an active connection attempt.
 @param stand The stand that should be disconnected from.
 */
- (void)disconnectStand:(ZBStand *)stand;

@end

NS_ASSUME_NONNULL_END
