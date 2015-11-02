//
//  FTScanner.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 19/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTCentralManagerDelegateProxy.h"
#import "FTFlytech.h"
#import "FTBLEAvailabilityAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTScanner : NSObject <FTCentralManagerDiscoveryDelegate>

@property (weak, nonatomic) CBCentralManager *centralManager;

- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discoveryHandler:(nullable FTDiscoveryHandler)discoveryHandler completionHandler:(FTDiscoveryCompletionHandler)completionHandler;
- (void)stopDiscovery;

@end

NS_ASSUME_NONNULL_END
