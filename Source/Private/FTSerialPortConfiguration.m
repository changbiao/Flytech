//
//  FTSerialPortConfiguration.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 27/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTSerialPortConfiguration.h"

@implementation FTSerialPortConfiguration

#pragma mark - Life Cycle

- (instancetype)initWithPower:(FTSerialPortPower)power baudRate:(FTSerialPortBaudRate)baudRate parity:(FTSerialPortParity)parity dataBits:(FTSerialPortDataBits)dataBits stopBits:(FTSerialPortStopBits)stopBits {
    self = [super init];
    if (self) {
        self.power = power;
        self.baudRate = baudRate;
        self.parity = parity;
        self.dataBits = dataBits;
        self.stopBits = stopBits;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    return nil;
}

@end
