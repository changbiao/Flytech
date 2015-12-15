//
//  ZBPrinter+Private.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinter+Private.h"
#import <objc/runtime.h>
#import "ZBDebugging.h"
#import "ZBPrinterFunctionSettings.h"
#import "NSData+ZBDescriptionBits.h"
#import "ZBPrinter+HexCmd.h"
#import "NSData+ZBHex.h"
#import "ZBPrinterStatusUpdate.h"
#import "ZBErrorDomain+Factory.h"

typedef NS_ENUM(NSUInteger, ZBPrinterResponseType) {
    ZBPrinterResponseTypeUnknown,
    ZBPrinterResponseTypeStatusUpdate,
    ZBPrinterResponseTypeFunctionSettings
};

@interface ZBPrinter ()

@property (strong, nonatomic) NSMutableArray *mutableTasks;

@end

@implementation ZBPrinter (Private)

#pragma mark - Life Cycle

- (instancetype)initWithSerialPortCommunicator:(ZBSerialPortCommunicator *)serialPortCommunicator portNumber:(ZBSerialPortNumber)portNumber {
    self = [super init];
    if (self) {
        self.serialPortCommunicator = serialPortCommunicator;
        [self.serialPortCommunicator addObserver:self];
        self.portNumber = portNumber;
    }
    return self;
}

#pragma mark - Public Interface

- (void)addTask:(ZBPrinterTask *)task {
    [self.mutableTasks addObject:task];
    if (self.mutableTasks.count == 1) {
        [self processNextTask];
    }
}

- (void)addSendDataTaskWithData:(NSData *)data completion:(ZBPrinterDefaultCompletionHandler)completion {
    ZBPrinterTaskSendData *task = [ZBPrinterTaskSendData new];
    task.data = data;
    task.completionHandler = completion;
    [self addTask:task];
}

#pragma mark - ZBSerialPortCommunicatorObserver

- (void)serialPortCommunicator:(ZBSerialPortCommunicator *)serialPortCommunicator receivedData:(NSData *)data fromPortNumber:(ZBSerialPortNumber)portNumber {
    if (portNumber != self.portNumber) {
        return;
    }
    [self handleResponseData:data];
}

#pragma mark - Response Handling

- (void)handleResponseData:(NSData *)data {
    ZBLog(@"Received data: %@ from printer", data);
    switch ([self determineResponseTypeForData:data]) {
        case ZBPrinterResponseTypeStatusUpdate: [self handleStatusUpdateResponseData:data]; break;
        case ZBPrinterResponseTypeFunctionSettings: [self handleFunctionSettingsResponseData:data]; break;
        case ZBPrinterResponseTypeUnknown: [self handleUnknownResponse:data]; break;
    }
}

- (ZBPrinterResponseType)determineResponseTypeForData:(NSData *)data {
    if ([ZBPrinterStatusUpdate validateDataForInitialization:data]) {
        return ZBPrinterResponseTypeStatusUpdate;
    } else if ([ZBPrinterFunctionSettings validateDataForInitialization:data]) {
        return ZBPrinterResponseTypeFunctionSettings;
    }
    return ZBPrinterResponseTypeUnknown;
}

- (void)handleStatusUpdateResponseData:(NSData *)data {
    ZBPrinterStatusUpdate *statusUpdate = [[ZBPrinterStatusUpdate alloc] initWithData:data];
    ZBLog(@"%@", statusUpdate);
}

- (void)handleFunctionSettingsResponseData:(NSData *)data {
    ZBPrinterFunctionSettings *functionSettings = [[ZBPrinterFunctionSettings alloc] initWithData:data];
    ZBPrinterTask *currentTask = self.mutableTasks.firstObject;
    if (currentTask && [currentTask isKindOfClass:[ZBPrinterTaskGetFunctionSettings class]]) {
        [self completeCurrentTaskWithResponse:functionSettings error:nil];
    } else {
        id userInfo = @{ ZBZeebaErrorUserInfoKeyInvalidResponse: data };
        [self completeCurrentTaskWithResponse:nil error:[ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodePrinterReceivedInvalidResponse userInfo:userInfo]];
    }
}

- (void)handleUnknownResponse:(NSData *)data {
    id userInfo = @{ ZBZeebaErrorUserInfoKeyInvalidResponse: data };
    [self completeCurrentTaskWithResponse:nil error:[ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodePrinterReceivedInvalidResponse userInfo:userInfo]];
}

#pragma mark - Task Handling

- (void)processNextTask {
    if (!self.mutableTasks.count) {
        return;
    }
    ZBPrinterTask *nextTask = self.mutableTasks[0];
    if ([nextTask isKindOfClass:[ZBPrinterTaskGetFunctionSettings class]]) {
        [self processGetFunctionSettingsTask:(ZBPrinterTaskGetFunctionSettings *)nextTask];
    } else if ([nextTask isKindOfClass:[ZBPrinterTaskSendData class]]) {
        [self processSendDataTask:(ZBPrinterTaskSendData *)nextTask];
    } else {
        ZBLog(@"Unhandled printer task encountered: %@", nextTask);
    }
}

- (void)processGetFunctionSettingsTask:(ZBPrinterTaskGetFunctionSettings *)task {
    [self.serialPortCommunicator sendDataEnsured:[NSData dataWithHex:ZBPrinterHexCmdFunctionSettingResponse] toPortNumber:self.portNumber completion:^(NSError *error) {
        if (error) {
            [self completeCurrentTaskWithResponse:nil error:[ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodePrinterCommunicationFailed userInfo:@{ NSUnderlyingErrorKey: error }]];
        }
    }];
}

- (void)processSendDataTask:(ZBPrinterTaskSendData *)task {
    [self.serialPortCommunicator sendDataEnsured:task.data toPortNumber:self.portNumber completion:^(NSError *error) {
        [self completeCurrentTaskWithResponse:nil error:error ? [ZBErrorDomain zeebaErrorWithCode:ZBZeebaErrorCodePrinterCommunicationFailed userInfo:@{ NSUnderlyingErrorKey: error }] : nil];
    }];
}

- (void)completeCurrentTaskWithResponse:(id)response error:(NSError *)error {
    if (!self.mutableTasks.count) {
        return;
    }
    ZBPrinterTask *currentTask = self.mutableTasks[0];
    id completionHandler = currentTask.completionHandler;
    [self.mutableTasks removeObject:currentTask];
    if (self.mutableTasks.count) {
        [self processNextTask];
    }
    if ([currentTask isKindOfClass:[ZBPrinterTaskGetFunctionSettings class]]) {
        void(^typedCompletionHandler)(ZBPrinterFunctionSettings *functionSettings, NSError *error) = completionHandler;
        if (typedCompletionHandler) {
            typedCompletionHandler(response, error);
        }
    } else if ([currentTask isKindOfClass:[ZBPrinterTaskSendData class]]) {
        void(^typedCompletionHandler)(NSError *error) = completionHandler;
        if (typedCompletionHandler) {
            typedCompletionHandler(error);
        }
    } else {
        ZBLog(@"Unhandled printer task enountered: %@", currentTask);
    }
}

#pragma mark - Accessors

- (ZBSerialPortCommunicator *)serialPortCommunicator {
    return objc_getAssociatedObject(self, @selector(serialPortCommunicator));
}

- (ZBSerialPortNumber)portNumber {
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

- (void)setSerialPortCommunicator:(ZBSerialPortCommunicator *)serialPortCommunicator {
    objc_setAssociatedObject(self, @selector(serialPortCommunicator), serialPortCommunicator, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setPortNumber:(ZBSerialPortNumber)portNumber {
    objc_setAssociatedObject(self, @selector(portNumber), @(portNumber), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setMutableTasks:(NSMutableArray *)mutableTasks {
    objc_setAssociatedObject(self, @selector(mutableTasks), mutableTasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
