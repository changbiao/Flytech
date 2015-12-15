//
//  ZBConnectionPool.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 19/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBCentralManagerDelegateProxy.h"
#import "ZBConnectivity.h"
#import "ZBZeeba.h"
#import "ZBScanner.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBConnectionPool : NSObject <ZBCentralManagerConnectionDelegate>

@property (weak, nonatomic, readonly) ZBZeeba *zeeba;
@property (copy, nonatomic, readonly) NSSet<id<ZBConnectivityObserver>> *connectivityObservers;
@property (copy, nonatomic, readonly) NSSet<ZBStand *> *stands;
@property (copy, nonatomic, readonly) NSSet<ZBStand *> *connectedStands;
@property (weak, nonatomic) CBCentralManager *centralManager;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithZeeba:(ZBZeeba *)zeeba NS_DESIGNATED_INITIALIZER;

- (void)addConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver;
- (void)removeConnectivityObserver:(id<ZBConnectivityObserver>)connectivityObserver;

- (void)connectStand:(ZBStand *)stand timeout:(NSTimeInterval)timeout completionHandler:(ZBConnectCompletionHandler)completionHandler;
- (void)disconnectStand:(ZBStand *)stand;

@end

NS_ASSUME_NONNULL_END
