//
//  AppDelegate.m
//  ZeebaExample
//
//  Created by Rasmus Taulborg Hummelmose on 01/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "StandsViewController.h"

#import <Zeeba/Zeeba.h>
#import <CocoaAsyncSocket/CocoaAsyncSocket.h>
#import <AdSupport/AdSupport.h>

static NSString * const AppDelegatePapertrailHost = @"logs3.papertrailapp.com";
static NSInteger const AppDelegatePapertrailPort = 57445;
static NSString * const AppDelegateLoggingDateFormat = @"yyyy-dd-MM HH:mm:ss.SSS";
static NSString * const AppDelegateSyslogLocaleIdentifier = @"en_US_POSIX";
static NSString * const AppDelegateSyslogDateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";

@interface AppDelegate () <ZBLoggingObserver, GCDAsyncUdpSocketDelegate>

@property (strong, nonatomic) GCDAsyncUdpSocket *loggingUdpSocket;
@property (strong, nonatomic) NSDateFormatter *loggingDateFormatter;
@property (strong, nonatomic) NSDateFormatter *syslogDateFormatter;
@property (strong, nonatomic) NSString *advertisingIdentifier;
@property (strong, nonatomic) NSString *bundle;

@end

@implementation AppDelegate 

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.loggingDateFormatter.dateFormat = AppDelegateLoggingDateFormat;
    self.syslogDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:AppDelegateSyslogLocaleIdentifier];
    self.syslogDateFormatter.dateFormat = AppDelegateSyslogDateFormat;
    [ZBDebugging addLoggingObserver:self];
    StandsViewController *standsViewController = [StandsViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:standsViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Public Interface

void appLog(NSString *prefix, const char *file, int lineNumber, const char *functionName, NSString *format, ...) {
    va_list ap;
    va_start (ap, format);
    if (![format hasSuffix: @"\n"]) {
        format = [format stringByAppendingString: @"\n"];
    }
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end (ap);
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    NSDate *date = [NSDate date];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *dateString = [appDelegate.loggingDateFormatter stringFromDate:date];
    fprintf(stderr, "%s %s (%s) (%s:%d) %s", [dateString UTF8String], [prefix UTF8String], functionName, [fileName UTF8String], lineNumber, [body UTF8String]);
    NSString *function = [[NSString alloc] initWithUTF8String:functionName];
    [appDelegate logAtDate:date prefix:prefix function:function file:fileName line:lineNumber body:body];
}

#pragma mark - Internals

- (void)logAtDate:(NSDate *)date prefix:(NSString *)prefix function:(NSString *)function file:(NSString *)file line:(NSUInteger)line body:(NSString *)body {
    NSString *syslogPrefix = [NSString stringWithFormat:@"<22>1 %@ %@ %@ - - -", [self.syslogDateFormatter stringFromDate:date], self.advertisingIdentifier, self.bundle];
    NSString *message = [NSString stringWithFormat:@"%@ %@ (%@:%ld) %@", prefix, function, file, line, body];
    NSData *data = [[@[ syslogPrefix, message ] componentsJoinedByString:@" "] dataUsingEncoding:NSUTF8StringEncoding];
    [self.loggingUdpSocket sendData:data toHost:AppDelegatePapertrailHost port:AppDelegatePapertrailPort withTimeout:-1 tag:1];
}

#pragma mark - ZBLoggingObserver

- (void)zeebaLoggingObservedAtDate:(NSDate *)date prefix:(NSString *)prefix function:(NSString *)function file:(NSString *)file line:(NSUInteger)line body:(NSString *)body {
    [self logAtDate:date prefix:prefix function:function file:file line:line body:body];
}

#pragma mark - Accessors

- (GCDAsyncUdpSocket *)loggingUdpSocket {
    if (!_loggingUdpSocket) {
        _loggingUdpSocket = [GCDAsyncUdpSocket new];
    }
    return _loggingUdpSocket;
}

- (NSDateFormatter *)loggingDateFormatter {
    if (!_loggingDateFormatter) {
        _loggingDateFormatter = [NSDateFormatter new];
    }
    return _loggingDateFormatter;
}

- (NSDateFormatter *)syslogDateFormatter {
    if (!_syslogDateFormatter) {
        _syslogDateFormatter = [NSDateFormatter new];
    }
    return _syslogDateFormatter;
}

- (NSString *)advertisingIdentifier {
    if (!_advertisingIdentifier) {
        _advertisingIdentifier = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] substringToIndex:7];
    }
    return _advertisingIdentifier;
}

- (NSString *)bundle {
    if (!_bundle) {
        NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _bundle = [NSString stringWithFormat:@"%@ %@", bundleName, bundleVersion];
    }
    return _bundle;
}

@end
