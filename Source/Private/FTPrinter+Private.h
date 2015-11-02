//
//  FTPrinter+Private.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter.h"
#import "FTSerialPortCommunicator.h"

@interface FTPrinter (Private)

@property (weak, nonatomic) FTSerialPortCommunicator *serialPortCommunicator;
@property (assign, nonatomic) FTSerialPortNumber portNumber;

- (instancetype)initWithSerialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator portNumber:(FTSerialPortNumber)portNumber;

@end
