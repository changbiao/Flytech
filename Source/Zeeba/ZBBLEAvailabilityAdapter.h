//
//  ZBBLEAvailabilityAdapter.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBCentralManagerDelegateProxy.h"
#import "ZBBLEAvailability.h"

@class ZBZeeba;

@interface ZBBLEAvailabilityAdapter : NSObject <ZBCentralManagerStateDelegate>

@property (weak, nonatomic, readonly) ZBZeeba *zeeba;
@property (copy, nonatomic, readonly) NSSet<id<ZBBLEAvailabilityObserver>> *availabilityObservers;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithZeeba:(ZBZeeba *)zeeba NS_DESIGNATED_INITIALIZER;

- (void)addAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver;
- (void)removeAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver;

- (ZBBLEAvailability)availabilityForCentralManagerState:(CBCentralManagerState)centralManagerState;

@end
