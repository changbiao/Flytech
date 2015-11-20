//
//  FTBLEAvailabilityAdapter.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTCentralManagerDelegateProxy.h"
#import "FTBLEAvailability.h"

@class FTFlytech;

@interface FTBLEAvailabilityAdapter : NSObject <FTCentralManagerStateDelegate>

@property (weak, nonatomic, readonly) FTFlytech *flytech;
@property (copy, nonatomic, readonly) NSSet<id<FTBLEAvailabilityObserver>> *availabilityObservers;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFlytech:(FTFlytech *)flytech NS_DESIGNATED_INITIALIZER;

- (void)addAvailabilityObserver:(id<FTBLEAvailabilityObserver>)availabilityObserver;
- (void)removeAvailabilityObserver:(id<FTBLEAvailabilityObserver>)availabilityObserver;

- (FTBLEAvailability)availabilityForCentralManagerState:(CBCentralManagerState)centralManagerState;

@end
