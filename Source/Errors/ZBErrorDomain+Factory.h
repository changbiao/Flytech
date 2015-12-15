//
//  ZBErrorDomain+Factory.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 22/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Zeeba/Zeeba.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBErrorDomain (Factory)

+ (NSError *)zeebaError;
+ (NSError *)zeebaErrorWithCode:(ZBZeebaErrorCode)code;
+ (NSError *)zeebaErrorWithCode:(ZBZeebaErrorCode)code userInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
