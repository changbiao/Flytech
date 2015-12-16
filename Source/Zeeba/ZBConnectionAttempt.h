//
//  ZBConnectionAttempt.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 26/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBZeeba.h"

NS_ASSUME_NONNULL_BEGIN

@class ZBStand;

@interface ZBConnectionAttempt : NSObject

@property (strong, nonatomic) ZBStand *stand;
@property (copy, nonatomic) ZBConnectCompletionHandler completion;
@property (strong, nonatomic, nullable) NSTimer *timeoutTimer;

- (instancetype)initWithStand:(ZBStand *)stand timeoutTimer:(nullable NSTimer *)timeoutTimer completion:(ZBConnectCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
