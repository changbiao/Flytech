//
//  FTBLEAvailabilityAdapter.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTBLEAvailabilityAdapter.h"

@interface FTBLEAvailabilityAdapter ()

@property (weak, nonatomic) FTFlytech *flytech;
@property (assign, nonatomic) BOOL didObserveAvailability;
@property (assign, nonatomic) FTBLEAvailability lastObservedAvailability;
@property (strong, nonatomic) NSHashTable *weakAvailabilityObservers;

@end

@implementation FTBLEAvailabilityAdapter

#pragma mark - Object Life Cycle

- (instancetype)init {
    [NSException raise:NSGenericException format:@"Disabled. Use +[[%@ alloc] %@] instead", NSStringFromClass([self class]), NSStringFromSelector(@selector(initWithFlytech:))];
    return nil;
}

- (instancetype)initWithFlytech:(FTFlytech *)flytech {
    self = [super init];
    if (self) {
        self.flytech = flytech;
    }
    return self;
}

#pragma mark - Public Interface

- (NSSet<id<FTBLEAvailabilityObserver>> *)availabilityObservers {
    return self.weakAvailabilityObservers.setRepresentation;
}

- (void)addAvailabilityObserver:(id<FTBLEAvailabilityObserver>)availabilityObserver {
    [self.weakAvailabilityObservers addObject:availabilityObserver];
}

- (void)removeAvailabilityObserver:(id<FTBLEAvailabilityObserver>)availabilityObserver {
    [self.weakAvailabilityObservers removeObject:availabilityObserver];
}

- (FTBLEAvailability)availabilityForCentralManagerState:(CBCentralManagerState)centralManagerState {
    switch (centralManagerState) {
        case CBCentralManagerStatePoweredOn: return FTBLEAvailabilityAvailable; break;
        case CBCentralManagerStateUnknown: return FTBLEAvailabilityUnavailable; break;
        case CBCentralManagerStatePoweredOff: return FTBLEAvailabilityUnavailableOff; break;
        case CBCentralManagerStateResetting: return FTBLEAvailabilityUnavailableResetting; break;
        case CBCentralManagerStateUnauthorized: return FTBLEAvailabilityUnavailableUnauthorized; break;
        case CBCentralManagerStateUnsupported: return FTBLEAvailabilityUnavailableUnsupported; break;
    }
}

#pragma mark - FTCentralManagerStateDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    dispatch_async(dispatch_get_main_queue(), ^{
        FTBLEAvailability newAvailability = [self availabilityForCentralManagerState:central.state];
        if (!self.didObserveAvailability || newAvailability != self.lastObservedAvailability) {
            self.didObserveAvailability = YES;
            self.lastObservedAvailability = newAvailability;
            for (id<FTBLEAvailabilityObserver> availabilityObserver in self.weakAvailabilityObservers) {
                [availabilityObserver flytech:self.flytech availabilityChanged:newAvailability];
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
