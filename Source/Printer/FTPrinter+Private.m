//
//  FTPrinter+Private.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter+Private.h"
#import <objc/runtime.h>
#import "FTDebugging.h"
#import "FTPrinterFunctionSettings.h"
#import "NSData+FTDescriptionBits.h"
#import "FTPrinter+HexCmd.h"
#import "NSData+FTHex.h"
#import "FTPrinterStatusUpdate.h"
#import "FTErrorDomain+Factory.h"

typedef NS_ENUM(NSUInteger, FTPrinterResponseType) {
    FTPrinterResponseTypeUnknown,
    FTPrinterResponseTypeStatusUpdate,
    FTPrinterResponseTypeFunctionSettings
};

@interface FTPrinter ()

@property (strong, nonatomic) NSMutableArray *mutableTasks;

@end

@implementation FTPrinter (Private)

#pragma mark - Life Cycle

- (instancetype)initWithSerialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator portNumber:(FTSerialPortNumber)portNumber {
    self = [super init];
    if (self) {
        self.serialPortCommunicator = serialPortCommunicator;
        [self.serialPortCommunicator addObserver:self];
        self.portNumber = portNumber;
    }
    return self;
}

#pragma mark - Public Interface

- (void)addTask:(FTPrinterTask *)task {
    [self.mutableTasks addObject:task];
    if (self.mutableTasks.count == 1) {
        [self processNextTask];
    }
}

- (void)addSendDataTaskWithData:(NSData *)data completion:(FTPrinterDefaultCompletionHandler)completion {
    FTPrinterTaskSendData *task = [FTPrinterTaskSendData new];
    task.data = data;
    task.completionHandler = completion;
    [self addTask:task];
}

#pragma mark - FTSerialPortCommunicatorObserver

- (void)serialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator receivedData:(NSData *)data fromPortNumber:(FTSerialPortNumber)portNumber {
    if (portNumber != self.portNumber) {
        return;
    }
    [self handleResponseData:data];
}

#pragma mark - Response Handling

- (void)handleResponseData:(NSData *)data {
    FTLog(@"Received data: %@ from printer", data);
    switch ([self determineResponseTypeForData:data]) {
        case FTPrinterResponseTypeStatusUpdate: [self handleStatusUpdateResponseData:data]; break;
        case FTPrinterResponseTypeFunctionSettings: [self handleFunctionSettingsResponseData:data]; break;
        case FTPrinterResponseTypeUnknown: [self handleUnknownResponse:data]; break;
    }
}

- (FTPrinterResponseType)determineResponseTypeForData:(NSData *)data {
    if ([FTPrinterStatusUpdate validateDataForInitialization:data]) {
        return FTPrinterResponseTypeStatusUpdate;
    } else if ([FTPrinterFunctionSettings validateDataForInitialization:data]) {
        return FTPrinterResponseTypeFunctionSettings;
    }
    return FTPrinterResponseTypeUnknown;
}

- (void)handleStatusUpdateResponseData:(NSData *)data {
    FTPrinterStatusUpdate *statusUpdate = [[FTPrinterStatusUpdate alloc] initWithData:data];
    FTLog(@"%@", statusUpdate);
}

- (void)handleFunctionSettingsResponseData:(NSData *)data {
    FTPrinterFunctionSettings *functionSettings = [[FTPrinterFunctionSettings alloc] initWithData:data];
    FTPrinterTask *currentTask = self.mutableTasks.firstObject;
    if (currentTask && [currentTask isKindOfClass:[FTPrinterTaskGetFunctionSettings class]]) {
        [self completeCurrentTaskWithResponse:functionSettings error:nil];
    } else {
        id userInfo = @{ FTFlytechErrorUserInfoKeyInvalidResponse: data };
        [self completeCurrentTaskWithResponse:nil error:[FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodePrinterReceivedInvalidResponse userInfo:userInfo]];
    }
}

- (void)handleUnknownResponse:(NSData *)data {
    id userInfo = @{ FTFlytechErrorUserInfoKeyInvalidResponse: data };
    [self completeCurrentTaskWithResponse:nil error:[FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodePrinterReceivedInvalidResponse userInfo:userInfo]];
}

#pragma mark - Task Handling

- (void)processNextTask {
    if (!self.mutableTasks.count) {
        return;
    }
    FTPrinterTask *nextTask = self.mutableTasks[0];
    if ([nextTask isKindOfClass:[FTPrinterTaskGetFunctionSettings class]]) {
        [self processGetFunctionSettingsTask:(FTPrinterTaskGetFunctionSettings *)nextTask];
    } else if ([nextTask isKindOfClass:[FTPrinterTaskSendData class]]) {
        [self processSendDataTask:(FTPrinterTaskSendData *)nextTask];
    } else {
        FTLog(@"Unhandled printer task encountered: %@", nextTask);
    }
}

- (void)processGetFunctionSettingsTask:(FTPrinterTaskGetFunctionSettings *)task {
    [self.serialPortCommunicator sendDataEnsured:[NSData dataWithHex:FTPrinterHexCmdFunctionSettingResponse] toPortNumber:self.portNumber completion:^(NSError *error) {
        if (error) {
            [self completeCurrentTaskWithResponse:nil error:[FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodePrinterCommunicationFailed userInfo:@{ NSUnderlyingErrorKey: error }]];
        }
    }];
}

- (void)processSendDataTask:(FTPrinterTaskSendData *)task {
    [self.serialPortCommunicator sendDataEnsured:task.data toPortNumber:self.portNumber completion:^(NSError *error) {
        [self completeCurrentTaskWithResponse:nil error:error ? [FTErrorDomain flytechErrorWithCode:FTFlytechErrorCodePrinterCommunicationFailed userInfo:@{ NSUnderlyingErrorKey: error }] : nil];
    }];
}

- (void)completeCurrentTaskWithResponse:(id)response error:(NSError *)error {
    if (!self.mutableTasks.count) {
        return;
    }
    FTPrinterTask *currentTask = self.mutableTasks[0];
    id completionHandler = currentTask.completionHandler;
    [self.mutableTasks removeObject:currentTask];
    if (self.mutableTasks.count) {
        [self processNextTask];
    }
    if ([currentTask isKindOfClass:[FTPrinterTaskGetFunctionSettings class]]) {
        void(^typedCompletionHandler)(FTPrinterFunctionSettings *functionSettings, NSError *error) = completionHandler;
        if (typedCompletionHandler) {
            typedCompletionHandler(response, error);
        }
    } else if ([currentTask isKindOfClass:[FTPrinterTaskSendData class]]) {
        void(^typedCompletionHandler)(NSError *error) = completionHandler;
        if (typedCompletionHandler) {
            typedCompletionHandler(error);
        }
    } else {
        FTLog(@"Unhandled printer task enountered: %@", currentTask);
    }
}

#pragma mark - Accessors

- (FTSerialPortCommunicator *)serialPortCommunicator {
    return objc_getAssociatedObject(self, @selector(serialPortCommunicator));
}

- (FTSerialPortNumber)portNumber {
    return [objc_getAssociatedObject(self, @selector(portNumber)) unsignedIntegerValue];
}

- (NSArray *)tasks {
    return [NSArray arrayWithArray:self.mutableTasks];
}

- (NSMutableArray *)mutableTasks {
    NSMutableArray *mutableTasks = objc_getAssociatedObject(self, @selector(mutableTasks));
    if (!mutableTasks) {
        mutableTasks = [NSMutableArray array];
        self.mutableTasks = mutableTasks;
    }
    return mutableTasks;
}

#pragma mark - Mutators

- (void)setSerialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator {
    objc_setAssociatedObject(self, @selector(serialPortCommunicator), serialPortCommunicator, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setPortNumber:(FTSerialPortNumber)portNumber {
    objc_setAssociatedObject(self, @selector(portNumber), @(portNumber), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setMutableTasks:(NSMutableArray *)mutableTasks {
    objc_setAssociatedObject(self, @selector(mutableTasks), mutableTasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
