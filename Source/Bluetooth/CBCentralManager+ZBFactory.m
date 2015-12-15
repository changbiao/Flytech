//
//  CBCentralManager+ZBFactory.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 23/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "CBCentralManager+ZBFactory.h"

static NSString * const ZBZeebaCentralManagerRestorationIdentifier = @"08B3C7BB-BC44-402B-802B-DF000DD37076";

@implementation CBCentralManager (ZBFactory)

#pragma mark - Public Interface

+ (CBCentralManager *)zeebaCentralManagerWithDelegate:(id<CBCentralManagerDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate queue:[self queue] options:[self options]];
}

#pragma mark - Internals

+ (dispatch_queue_t)queue {
    return dispatch_queue_create("Zeeba Queue", DISPATCH_QUEUE_SERIAL);
}

+ (NSDictionary *)options {
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:@{ CBCentralManagerOptionShowPowerAlertKey: @NO }];
    #if TARGET_OS_IPHONE
    options[CBCentralManagerOptionRestoreIdentifierKey] = ZBZeebaCentralManagerRestorationIdentifier;
    #endif
    return options;
}

@end
