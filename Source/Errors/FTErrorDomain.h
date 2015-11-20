//
//  FTErrorDomain.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const FTFlytechErrorDomain;

typedef NS_ENUM(NSUInteger, FTFlytechErrorCode) {
    FTFlytechErrorCodeUndefined,
    FTFlytechErrorCodeBLEAvailability,
    FTFlytechErrorCodeAlreadyDiscovering,
    FTFlytechErrorCodeAlreadyConnecting,
    FTFlytechErrorCodeConnectionTimedOut,
    FTFlytechErrorCodeConnectionFailed,
    FTFlytechErrorCodeConnectionInterrupted
};

@interface FTErrorDomain : NSObject

@end

NS_ASSUME_NONNULL_END
