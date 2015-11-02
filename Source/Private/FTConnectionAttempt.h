//
//  FTConnectionAttempt.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 26/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTFlytech.h"

NS_ASSUME_NONNULL_BEGIN

@class FTStand;

@interface FTConnectionAttempt : NSObject

@property (strong, nonatomic) FTStand *stand;
@property (copy, nonatomic) FTConnectCompletionHandler completionHandler;
@property (strong, nonatomic, nullable) NSTimer *timeoutTimer;

- (instancetype)initWithStand:(FTStand *)stand timeoutTimer:(nullable NSTimer *)timeoutTimer completionHandler:(FTConnectCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
