//
//  ZBZeeba+SDKKeyValidation.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 15/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBZeeba+SDKKeyValidation.h"

static BOOL ZBZeebaValidationDidFail = NO;
static NSString * const ZBZeebaValidationTimerUserInfoKeySDKKey = @"SDK Key";
static NSString * const ZBZeebaValidationTimerUserInfoKeyStartDate = @"Start date";
static NSString * const ZBZeebaValidationTimerUserInfoKeyFailureBlock = @"Failure block";
static NSTimeInterval const ZBZeebaMaxSecondsBeforeFirstValidation = 60 * 5;

@implementation ZBZeeba (SDKKeyValidation)

#pragma mark - Public Interface

+ (BOOL)validateSDKKey:(NSString *)key failure:(void (^)())failure {
    if (ZBZeebaValidationDidFail) {
        return NO;
    }
    [self performValidationRequestWithSDKKey:key cycleStart:[NSDate date] failureBlock:failure];
    return YES;
}

#pragma mark - Internals

+ (void)performValidationRequestWithSDKKey:(NSString *)key cycleStart:(NSDate *)cycleStart failureBlock:(void(^)())failureBlock {
    NSDate *currentDate = [NSDate date];
    if ((currentDate.timeIntervalSince1970 - cycleStart.timeIntervalSince1970) > ZBZeebaMaxSecondsBeforeFirstValidation) {
        ZBZeebaValidationDidFail = YES;
        failureBlock();
        return;
    }
    NSURL *url = [NSURL URLWithString:@"https://api.parse.com/1/functions/validateZeebaSDKKey"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 5;
    [request setValue:@"ZtvZREGRouzUpgg0LSIfXJBMas2vtXmalAjGBDJL" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:@"8w2fZcYSeogDzxorTXfZWFmQY8tRXrecr1tXhWy6" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    NSDictionary *dictionary = @{@"zeebaSDKKey": key};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
    if (error) {
        ZBZeebaValidationDidFail = YES;
        failureBlock();
        return;
    }
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        void(^initiateTimerForNextRequestInSeconds)(NSTimeInterval seconds) = ^(NSTimeInterval seconds) {
            NSDictionary *userInfo = @{ ZBZeebaValidationTimerUserInfoKeySDKKey: key, ZBZeebaValidationTimerUserInfoKeyStartDate: cycleStart, ZBZeebaValidationTimerUserInfoKeyFailureBlock: failureBlock };
            [NSTimer scheduledTimerWithTimeInterval:seconds target:[ZBZeeba class] selector:@selector(validationCycleTimerElapsed:) userInfo:userInfo repeats:NO];
        };
        if (error || !data.length) {
            dispatch_async(dispatch_get_main_queue(), ^{
                initiateTimerForNextRequestInSeconds(2);
            });
            return;
        }
        NSError *jsonError;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                initiateTimerForNextRequestInSeconds(2);
            });
            return;
        }
        if ([responseDictionary[@"result"] isEqualToString:@"1"]) {
            return;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                ZBZeebaValidationDidFail = YES;
                failureBlock();
            });
            return;
        }
    }];
    [task resume];
}

+ (void)validationCycleTimerElapsed:(NSTimer *)validationTimer {
    NSString *key = validationTimer.userInfo[ZBZeebaValidationTimerUserInfoKeySDKKey];
    NSDate *cycleStart = validationTimer.userInfo[ZBZeebaValidationTimerUserInfoKeyStartDate];
    id failureBlock = validationTimer.userInfo[ZBZeebaValidationTimerUserInfoKeyFailureBlock];
    [self performValidationRequestWithSDKKey:key cycleStart:cycleStart failureBlock:failureBlock];
}

@end
