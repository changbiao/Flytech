//
//  ZBBLEAvailabilityAdapter.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBBLEAvailabilityAdapter.h"

@interface ZBBLEAvailabilityAdapter ()

@property (weak, nonatomic) ZBZeeba *zeeba;
@property (assign, nonatomic) BOOL didObserveAvailability;
@property (assign, nonatomic) ZBBLEAvailability lastObservedAvailability;
@property (strong, nonatomic) NSHashTable *weakAvailabilityObservers;

@end

@implementation ZBBLEAvailabilityAdapter

#pragma mark - Object Life Cycle

- (instancetype)init {
    [NSException raise:NSGenericException format:@"Disabled. Use +[[%@ alloc] %@] instead", NSStringFromClass([self class]), NSStringFromSelector(@selector(initWithZeeba:))];
    return nil;
}

- (instancetype)initWithZeeba:(ZBZeeba *)zeeba {
    self = [super init];
    if (self) {
        self.zeeba = zeeba;
    }
    return self;
}

#pragma mark - Public Interface

- (NSSet<id<ZBBLEAvailabilityObserver>> *)availabilityObservers {
    return self.weakAvailabilityObservers.setRepresentation;
}

- (void)addAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver {
    [self.weakAvailabilityObservers addObject:availabilityObserver];
}

- (void)removeAvailabilityObserver:(id<ZBBLEAvailabilityObserver>)availabilityObserver {
    [self.weakAvailabilityObservers removeObject:availabilityObserver];
}

- (ZBBLEAvailability)availabilityForCentralManagerState:(CBCentralManagerState)centralManagerState {
    switch (centralManagerState) {
        case CBCentralManagerStatePoweredOn: return ZBBLEAvailabilityAvailable; break;
        case CBCentralManagerStateUnknown: return ZBBLEAvailabilityUnavailable; break;
        case CBCentralManagerStatePoweredOff: return ZBBLEAvailabilityUnavailableOff; break;
        case CBCentralManagerStateResetting: return ZBBLEAvailabilityUnavailableResetting; break;
        case CBCentralManagerStateUnauthorized: return ZBBLEAvailabilityUnavailableUnauthorized; break;
        case CBCentralManagerStateUnsupported: return ZBBLEAvailabilityUnavailableUnsupported; break;
    }
}

#pragma mark - ZBCentralManagerStateDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    dispatch_async(dispatch_get_main_queue(), ^{
        ZBBLEAvailability newAvailability = [self availabilityForCentralManagerState:central.state];
        if (!self.didObserveAvailability || newAvailability != self.lastObservedAvailability) {
            self.didObserveAvailability = YES;
            self.lastObservedAvailability = newAvailability;
            for (id<ZBBLEAvailabilityObserver> availabilityObserver in self.weakAvailabilityObservers) {
                [availabilityObserver zeeba:self.zeeba availabilityChanged:newAvailability];
            }
        }
    });
}

#pragma mark - Accessors

- (NSHashTable *)weakAvailabilityObservers {
    if (!_weakAvailabilityObservers) {
        _weakAvailabilityObservers = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    }
    return _weakAvailabilityObservers;
}

@end
