//
//  ZBDebugging.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 19/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ZBDebugging_h
#define ZBDebugging_h

#define ZBDebugLoggingEnabled
#define ZBBLEDebugLoggingEnabled

#ifdef ZBDebugLoggingEnabled
#   define ZBLog(fmt...)   zeebaLog(@"[Zeeba ]",__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt);
#else
#   define ZBLog(...)
#endif

#ifdef ZBBLEDebugLoggingEnabled
#   define ZBBLELog(fmt...)   zeebaLog(@"[Zeeba BLE ]",__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt);
#else
#   define ZBBLELog(...)
#endif

#endif /* ZBDebugging_h */

NS_ASSUME_NONNULL_BEGIN

@protocol ZBLoggingObserver

- (void)zeebaLoggingObservedAtDate:(NSDate *)date prefix:(NSString *)prefix function:(NSString *)function file:(NSString *)file line:(NSUInteger)line body:(NSString *)body;

@end

@interface ZBDebugging: NSObject

+ (void)addLoggingObserver:(id<ZBLoggingObserver>)loggingObserver;
+ (void)removeLoggingObserver:(id<ZBLoggingObserver>)loggingObserver;

void zeebaLog(NSString *prefix, const char *file, int lineNumber, const char *functionName, NSString *format, ...);

@end

NS_ASSUME_NONNULL_END
