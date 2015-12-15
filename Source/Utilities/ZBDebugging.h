//
//  ZBDebugging.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 19/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#ifndef ZBDebugging_h
#define ZBDebugging_h

#define ZBDebugLoggingEnabled
// #define ZBBLEDebugLoggingEnabled

#ifdef ZBDebugLoggingEnabled
#   define ZBLog(fmt, ...)   NSLog((@"[Zeeba ] %s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#   define ZBLog(...)
#endif

#ifdef ZBBLEDebugLoggingEnabled
#   define ZBBLELog(fmt, ...)   NSLog((@"[Zeeba BLE ] %s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#   define ZBBLELog(...)
#endif

#endif /* ZBDebugging_h */
