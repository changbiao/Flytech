//
//  CBCentralManager+Factory.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 23/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "CBCentralManager+Factory.h"

static NSString * const FTFlytechCentralManagerRestorationIdentifier = @"08B3C7BB-BC44-402B-802B-DF000DD37076";

@implementation CBCentralManager (Factor)

#pragma mark - Public Interface

+ (CBCentralManager *)flytechCentralManagerWithDelegate:(id<CBCentralManagerDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate queue:[self queue] options:[self options]];
}

#pragma mark - Internals

+ (dispatch_queue_t)queue {
    return dispatch_queue_create("Flytech Queue", DISPATCH_QUEUE_SERIAL);
}

+ (NSDictionary *)options {
    return @{ CBCentralManagerOptionShowPowerAlertKey: @NO, CBCentralManagerOptionRestoreIdentifierKey: FTFlytechCentralManagerRestorationIdentifier };
}

@end
