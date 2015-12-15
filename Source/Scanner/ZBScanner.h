//
//  ZBScanner.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 19/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBCentralManagerDelegateProxy.h"
#import "ZBZeeba.h"
#import "ZBBLEAvailabilityAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBScanner : NSObject <ZBCentralManagerDiscoveryDelegate>

@property (weak, nonatomic) CBCentralManager *centralManager;

- (void)discoverStandsWithTimeout:(NSTimeInterval)timeout discoveryHandler:(nullable ZBDiscoveryHandler)discoveryHandler completionHandler:(ZBDiscoveryCompletionHandler)completionHandler;
- (void)stopDiscovery;

@end

NS_ASSUME_NONNULL_END
