//
//  FTPrinter+Private.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter+Private.h"

@implementation FTPrinter (Private)

#pragma mark - Life Cycle

- (instancetype)initWithSerialPortCommunicator:(FTSerialPortCommunicator *)serialPortCommunicator portNumber:(FTSerialPortNumber)portNumber {
    self = [super init];
    if (self) {
        self.serialPortCommunicator = serialPortCommunicator;
        self.portNumber = portNumber;
    }
    return self;
}

@end
