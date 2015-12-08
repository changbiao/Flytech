//
//  FTDebugging.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 19/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#ifndef FTDebugging_h
#define FTDebugging_h

#define FTDebugLoggingEnabled
// #define FTBLEDebugLoggingEnabled

#ifdef FTDebugLoggingEnabled
#   define FTLog(fmt, ...)   NSLog((@"[Flytech ] %s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#   define FTLog(...)
#endif

#ifdef FTBLEDebugLoggingEnabled
#   define FTBLELog(fmt, ...)   NSLog((@"[Flytech BLE ] %s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#   define FTBLELog(...)
#endif

#endif /* FTDebugging_h */
