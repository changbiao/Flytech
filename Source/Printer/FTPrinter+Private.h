//
//  FTPrinter+Private.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter.h"
#import "FTSerialPortCommunicator.h"
#import "FTPrinterTask.h"

@interface FTPrinter (Private) <FTSerialPortCommunicatorObserver>

@property (weak, nonatomic) FTSerialPortCommunicator *serialPortCommunicator;
@property (assign, nonatomic) FTSerialPortNumber portNumber;
@property (copy, nonatomic, readonly) NSArray *tasks;

- (instancetype)initWithSerialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator portNumber:(FTSerialPortNumber)portNumber;
- (void)addTask:(FTPrinterTask *)task;
- (void)addSendDataTaskWithData:(NSData *)data completion:(FTPrinterDefaultCompletionHandler)completion;

@end
