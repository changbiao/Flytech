//
//  FTFlytech.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTBLEAvailability.h"

NS_ASSUME_NONNULL_BEGIN

@class FTFlytech;
@class FTStand;
@protocol FTConnectivityObserver;

extern NSTimeInterval const FTTimeoutInfinity;

typedef void(^FTDiscoveryHandler)(FTStand *discoveredStand);
typedef void(^FTDiscoveryCompletionHandler)(NSArray<FTStand *>  * _Nullable discoveredStands, NSError * _Nullable error);
typedef void(^FTConnectCompletionHandler)(FTStand *stand, NSError * _Nullable error);

@interface FTFlytech : NSObject

/**
 The objects that are subscribed to receive changes to availability.
 */
@property (copy, nonatomic, readonly) NSSet<id<FTBLEAvailabilityObserver>> *availabilityObservers;

/**
 The objects that are subscribed to receive changes to connectivity.
 */
@property (copy, nonatomic, readonly) NSSet<id<FTConnectivityObserver>> *connectivityObservers;

/**
 The current availability of Bluetooth Low Energy.
 */
@property (assign, nonatomic, readonly) FTBLEAvailability availability;

/**
 The Flytech stands that are currently connecting, connected or disconnecting.
 */
@property (copy, nonatomic, readonly) NSSet<FTStand *> *stands;

/**
 The Flytech stands that are currently connected.
 */
@property (copy, nonatomic, readonly) NSSet<FTStand *> *connectedStands;

/**
 Starts the underlying Bluetooth stack, after which point the observers will receive updates and method calls can be made.
 */
- (void)start;

/**
 Stops the underlying Bluetooth stack.
 */
- (void)stop;

/**
 Add an availability observer that will receive changes to BLE availability.
 @param availabilityObserver The availability observer to add.
 @see start
 */
- (void)addAvailabilityObserver:(id<FTBLEAvailabilityObserver>)availabilityObserver;

/**
 Remove an availability observer that should no longer receive changes to BLE availability.
 @param availabilityObserver The availability observer to remove.
 */
- (void)removeAvailabilityObserver:(id<FTBLEAvailabilityObserver>)availabilityObserver;

/**
 Add a connectivity observer that will receive changes to connectivity for managed Flytech stands.
 @param connectivityObserver The connectivity observer to add.
 */
- (void)addConnectivityObserver:(id<FTConnectivityObserver>)connectivityObserver;

/**
 Remove a connectivity observer that should no longer receive changes to connectivity for managed Flytech stands.
 @param connectivityObserver The connectivity observer to remove.
 */
- (void)removeConnectivityObserver:(id<FTConnectivityObserver>)connectivityObserver;

/**
 Discover Flytech stands within range.
 @param timeout The number of seconds for which the scan will proceed before calling the completion handler.
 @param discoveryHandler A handler that is called each time a new Flytech stand is discovered, with the stand passed as the only argument.
 @param completionHandler A handler that is called when discovery ends, with the discovered stands and an optional error as arguments.
 */
- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discoveryHandler:(nullable FTDiscoveryHandler)discoveryHandler completionHandler:(FTDiscoveryCompletionHandler)completionHandler;

/**
 Stops an active discovery, causing its completionHandler to be called with the discovered stands.
 */
- (void)stopDiscovery;

/**
 Connects to a stand with a given timeout and completion handler.
 @param stand The stand that should be connected to.
 @param timeout The timeout for the stand connection attempt. Use FTTimeoutInfinity to disable timeout.
 @param completionHandler A completion handler that will be called after the connection attempt with the stand and an optional error.
 */
- (void)connectStand:(FTStand *)stand timeout:(NSTimeInterval)timeout completionHandler:(FTConnectCompletionHandler)completionHandler;

/**
 Disconnects from a connected stand or interrupts an active connection attempt.
 @param stand The stand that should be disconnected from.
 */
- (void)disconnectStand:(FTStand *)stand;

@end

NS_ASSUME_NONNULL_END
