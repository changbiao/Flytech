//
//  ZBStand.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBStand.h"
#import "ZBStand+Private.h"
#import "ZBPeripheralController.h"
#import "ZBSerialPortCommunicator.h"
#import "ZBSerialPortConfiguration+Factory.h"

@interface ZBStand ()

@property (copy, nonatomic) NSUUID *identifier;
@property (assign, nonatomic) ZBStandModel model;
@property (copy, nonatomic) NSString *firmwareRevision;
@property (strong, nonatomic) ZBPrinter *printer;

@end

@implementation ZBStand

#pragma mark - Life Cycle

- (instancetype)initWithIdentifier:(NSUUID *)identifier {
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}

#pragma mark - Public Interface

- (ZBConnectivity)connectivity {
    if (!self.peripheral) {
        return ZBConnectivityNone;
    }
    #if TARGET_OS_IPHONE
    switch (self.peripheral.state) {
        case CBPeripheralStateDisconnected: return ZBConnectivityDisconnected; break;
        case CBPeripheralStateConnected: return ZBConnectivityConnected; break;
        case CBPeripheralStateConnecting: return ZBConnectivityConnecting; break;
        case CBPeripheralStateDisconnecting: return ZBConnectivityDisconnecting; break;
    }
    #else
    switch (self.peripheral.state) {
        case CBPeripheralStateDisconnected: return ZBConnectivityDisconnected; break;
        case CBPeripheralStateConnected: return ZBConnectivityConnected; break;
        case CBPeripheralStateConnecting: return ZBConnectivityConnecting; break;
    }
    #endif
    
}

- (void)undockWithCompletion:(ZBUndockCompletionHandler)completionHandler {
    if (completionHandler) {
        completionHandler(nil);
    }
}

#pragma mark - Compare

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        ZBStand *otherStand = object;
        return [self.identifier isEqual:otherStand.identifier];
    }
    return [super isEqual:object];
}

@end
