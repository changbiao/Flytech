//
//  FTConnectionPool.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 19/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTCentralManagerDelegateProxy.h"
#import "FTConnectivity.h"
#import "FTFlytech.h"
#import "FTScanner.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTConnectionPool : NSObject <FTCentralManagerConnectionDelegate>

@property (weak, nonatomic, readonly) FTFlytech *flytech;
@property (copy, nonatomic, readonly) NSSet<id<FTConnectivityObserver>> *connectivityObservers;
@property (copy, nonatomic, readonly) NSSet<FTStand *> *stands;
@property (copy, nonatomic, readonly) NSSet<FTStand *> *connectedStands;
@property (weak, nonatomic) CBCentralManager *centralManager;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFlytech:(FTFlytech *)flytech NS_DESIGNATED_INITIALIZER;

- (void)addConnectivityObserver:(id<FTConnectivityObserver>)connectivityObserver;
- (void)removeConnectivityObserver:(id<FTConnectivityObserver>)connectivityObserver;

- (void)connectStand:(FTStand *)stand timeout:(NSTimeInterval)timeout completionHandler:(FTConnectCompletionHandler)completionHandler;
- (void)disconnectStand:(FTStand *)stand;

@end

NS_ASSUME_NONNULL_END
