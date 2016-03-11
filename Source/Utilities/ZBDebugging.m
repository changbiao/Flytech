//
//  ZBDebugging.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 07/03/2016.
//  Copyright © 2016 Glastonia Ltd. All rights reserved.
//

#import "ZBDebugging.h"

@interface ZBDebugging ()

@property (strong, nonatomic) NSHashTable<id<ZBLoggingObserver>> *loggingObservers;

@end

@implementation ZBDebugging

#pragma mark - Variables

static NSHashTable<id<ZBLoggingObserver>> *loggingObservers;
static dispatch_queue_t loggingQueue;
static NSDateFormatter *dateFormatter;

#pragma mark - Life Cycle

+ (void)load {
    loggingObservers = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    loggingQueue = dispatch_queue_create("com.zeeba.logging", DISPATCH_QUEUE_CONCURRENT);
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-dd-MM HH:mm:ss.SSS";
}

#pragma mark - Public Interface

+ (void)addLoggingObserver:(id<ZBLoggingObserver>)loggingObserver {
    dispatch_async(loggingQueue, ^{
        [loggingObservers addObject:loggingObserver];
    });
}

+ (void)removeLoggingObserver:(id<ZBLoggingObserver>)loggingObserver {
    dispatch_async(loggingQueue, ^{
        [loggingObservers removeObject:loggingObserver];
    });
}

void zeebaLog(NSString *prefix, const char *file, int lineNumber, const char *functionName, NSString *format, ...) {
    va_list ap;
    va_start (ap, format);
    if (![format hasSuffix: @"\n"]) {
        format = [format stringByAppendingString: @"\n"];
    }
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end (ap);
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    fprintf(stderr, "%s %s (%s) (%s:%d) %s", [dateString UTF8String], [prefix UTF8String], functionName, [fileName UTF8String], lineNumber, [body UTF8String]);
    NSString *function = [[NSString alloc] initWithUTF8String:functionName];
    dispatch_async(loggingQueue, ^{
        for (id<ZBLoggingObserver> loggingObserver in loggingObservers) {
            [loggingObserver zeebaLoggingObservedAtDate:date prefix:prefix function:function file:fileName line:lineNumber body:body];
        }
    });
}

@end
