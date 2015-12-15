//
//  ZBErrorDomain+Factory.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 22/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBErrorDomain+Factory.h"

@implementation ZBErrorDomain (Factory)

#pragma mark - Public Interface

+ (NSError *)zeebaError {
    return [self zeebaErrorWithCode:ZBZeebaErrorCodeUndefined];
}

+ (NSError *)zeebaErrorWithCode:(ZBZeebaErrorCode)code {
    return [self zeebaErrorWithCode:code userInfo:nil];
}

+ (NSError *)zeebaErrorWithCode:(ZBZeebaErrorCode)code userInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *finalUserInfo = [NSMutableDictionary dictionaryWithDictionary:[self baseUserInfoForErrorCode:code]];
    for (id key in userInfo) {
        finalUserInfo[key] = userInfo[key];
    }
    NSError *error = [NSError errorWithDomain:ZBZeebaErrorDomain code:code userInfo:finalUserInfo];
    return error;
}

#pragma mark - Utility

+ (NSDictionary *)baseUserInfoForErrorCode:(ZBZeebaErrorCode)errorCode {
    NSMutableDictionary *baseUserInfo = [NSMutableDictionary dictionaryWithDictionary:@{ NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil) }];
    switch (errorCode) {
        case ZBZeebaErrorCodeUndefined:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Unknown.", nil);
            break;
        case ZBZeebaErrorCodeBLEAvailability:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Bluetooth Low Energy is unavailable.", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Ensure that your device supports Bluetooth Low Energy, that Bluetooth is turned on and the application is allowed to use it.", nil);
            break;
        case ZBZeebaErrorCodeConnectionTimedOut:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"The operation timed out.", nil);
            break;
        case ZBZeebaErrorCodeAlreadyDiscovering:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"A discovery operation is already in progress", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Wait until the current discovery operation times out or cancel it by calling stopDiscovery.", nil);
            break;
        case ZBZeebaErrorCodeAlreadyConnecting:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"A connection to a stand is already being established.", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Await connection.", nil);
            break;
        case ZBZeebaErrorCodeConnectionFailed:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Failed connecting to stand.", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Inspect the underlying error from Core Bluetooth.", nil);
            break;
        case ZBZeebaErrorCodeConnectionInterrupted:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"The connection to the stand was interrupted.", nil);
            break;
        case ZBZeebaErrorCodePrinterCommunicationFailed:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"Communication to the printer failed.", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Inspect the underlying error from the serial port communicator.", nil);
            break;
        case ZBZeebaErrorCodePrinterReceivedInvalidResponse:
            baseUserInfo[NSLocalizedFailureReasonErrorKey] = NSLocalizedString(@"An invalid or unexpected response was received from the printer.", nil);
            baseUserInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(@"Inspect the received data to debug.", nil);
            break;
    }
    return baseUserInfo;
}

@end
