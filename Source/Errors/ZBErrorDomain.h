//
//  ZBErrorDomain.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 21/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ZBZeebaErrorDomain;
extern NSString * const ZBZeebaErrorUserInfoKeyInvalidResponse;

typedef NS_ENUM(NSUInteger, ZBZeebaErrorCode) {
    ZBZeebaErrorCodeUndefined,
    ZBZeebaErrorCodeBLEAvailability,
    ZBZeebaErrorCodeAlreadyDiscovering,
    ZBZeebaErrorCodeAlreadyConnecting,
    ZBZeebaErrorCodeConnectionTimedOut,
    ZBZeebaErrorCodeConnectionFailed,
    ZBZeebaErrorCodeConnectionInterrupted,
    ZBZeebaErrorCodePrinterCommunicationFailed,
    ZBZeebaErrorCodePrinterReceivedInvalidResponse
};

@interface ZBErrorDomain : NSObject

@end

NS_ASSUME_NONNULL_END
