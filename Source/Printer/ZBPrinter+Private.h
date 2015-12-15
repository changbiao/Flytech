//
//  ZBPrinter+Private.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinter.h"
#import "ZBSerialPortCommunicator.h"
#import "ZBPrinterTask.h"

@interface ZBPrinter (Private) <ZBSerialPortCommunicatorObserver>

@property (weak, nonatomic) ZBSerialPortCommunicator *serialPortCommunicator;
@property (assign, nonatomic) ZBSerialPortNumber portNumber;
@property (copy, nonatomic, readonly) NSArray *tasks;

- (instancetype)initWithSerialPortCommunicator:(ZBSerialPortCommunicator *)serialPortCommunicator portNumber:(ZBSerialPortNumber)portNumber;
- (void)addTask:(ZBPrinterTask *)task;
- (void)addSendDataTaskWithData:(NSData *)data completion:(ZBPrinterDefaultCompletionHandler)completion;

@end
