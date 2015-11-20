//
//  FTErrorDomain+Factory.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 22/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Flytech/Flytech.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTErrorDomain (Factory)

+ (NSError *)flytechError;
+ (NSError *)flytechErrorWithCode:(FTFlytechErrorCode)code;
+ (NSError *)flytechErrorWithCode:(FTFlytechErrorCode)code userInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
