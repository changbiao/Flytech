//
//  FTStand.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTStand.h"
#import "FTStand+Private.h"
#import "FTPeripheralController.h"
#import "FTSerialPortCommunicator.h"
#import "FTSerialPortConfiguration+Factory.h"

@interface FTStand ()

@property (copy, nonatomic) NSUUID *identifier;
@property (assign, nonatomic) FTStandModel model;
@property (copy, nonatomic) NSString *firmwareRevision;

@end

@implementation FTStand

#pragma mark - Life Cycle

- (instancetype)initWithIdentifier:(NSUUID *)identifier {
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}

#pragma mark - Public Interface

- (FTConnectivity)connectivity {
    if (!self.peripheral) {
        return FTConnectivityNone;
    }
    switch (self.peripheral.state) {
        case CBPeripheralStateDisconnected: return FTConnectivityDisconnected; break;
        case CBPeripheralStateConnected: return FTConnectivityConnected; break;
        case CBPeripheralStateConnecting: return FTConnectivityConnecting; break;
        case CBPeripheralStateDisconnecting: return FTConnectivityDisconnecting; break;
    }
}

#pragma mark - Compare

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        FTStand *otherStand = object;
        return [self.identifier isEqual:otherStand.identifier];
    }
    return [super isEqual:object];
}

@end
