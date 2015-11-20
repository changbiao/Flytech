//
//  FTErrorDomain+Factory.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 22/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTErrorDomain+Factory.h"

@implementation FTErrorDomain (Factory)

#pragma mark - Public Interface

+ (NSError *)flytechError {
    return [self flytechErrorWithCode:FTFlytechErrorCodeUndefined];
}

+ (NSError *)flytechErrorWithCode:(FTFlytechErrorCode)code {
    return [self flytechErrorWithCode:code userInfo:nil];
}

+ (NSError *)flytechErrorWithCode:(FTFlytechErrorCode)code userInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *finalUserInfo = [NSMutableDictionary dictionaryWithDictionary:[self baseUserInfoForErrorCode:code]];
    for (id key in userInfo) {
        finalUserInfo[key] = userInfo[key];
    }
    NSError *error = [NSError errorWithDomain:FTFlytechErrorDomain code:code userInfo:finalUserInfo];
    return error;
}

#pragma mark - Utility

+ (NSDictionary *)baseUserInfoForErrorCode:(FTFlytechErrorCode)errorCode {
    NSMutableDictionary *baseUserInfo = [NSMutableDictionary dictionaryWithDictionary:@{ NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil) }];
    switch (errorCode) {
        case FTFlytechErrorCodeUndefined:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Unknown.", nil);
            break;
        case FTFlytechErrorCodeBLEAvailability:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Bluetooth Low Energy is unavailable.", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Ensure that your device supports Bluetooth Low Energy, that Bluetooth is turned on and the application is allowed to use it.", nil);
            break;
        case FTFlytechErrorCodeConnectionTimedOut:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"The operation timed out.", nil);
            break;
        case FTFlytechErrorCodeAlreadyDiscovering:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"A discovery operation is already in progress", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Wait until the current discovery operation times out or cancel it by calling stopDiscovery.", nil);
            break;
        case FTFlytechErrorCodeAlreadyConnecting:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"A connection to a stand is already being established.", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Await connection.", nil);
            break;
        case FTFlytechErrorCodeConnectionFailed:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Failed connecting to stand.", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Inspect the underlying error from Core Bluetooth.", nil);
            break;
        case FTFlytechErrorCodeConnectionInterrupted:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"The connection to the stand was interrupted.", nil);
            break;
    }
    return baseUserInfo;
}

@end
