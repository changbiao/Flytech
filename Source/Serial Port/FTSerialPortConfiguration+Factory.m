//
//  FTSerialPortConfiguration+Factory.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTSerialPortConfiguration+Factory.h"

@implementation FTSerialPortConfiguration (Factory)

#pragma mark - Public Interface

+ (FTSerialPortConfiguration *)configurationForPortNumber:(FTSerialPortNumber)portNumber standModel:(FTStandModel)standModel {
    switch (portNumber) {
        case FTSerialPortNumberOne: {
            return [self defaultConfigurationForPortOne];
            break;
        }
        case FTSerialPortNumberTwo: {
            return [self defaultConfigurationForPortTwo];
            break;
        }
        case FTSerialPortNumberThree: {
            switch (standModel) {
                case FTStandModelT605: {
                    return [self configurationForPortThreeOnT605];
                    break;
                }
                default: {
                    return [self defaultConfigurationForPortThree];
                    break;
                }
            }
            break;
        }
    }
}

#pragma mark - Internals

+ (FTSerialPortConfiguration *)defaultConfigurationForPortOne {
    return [[self alloc] initWithPower:NO flowControl:NO baudRate:FTSerialPortBaudRate9600BPS parity:FTSerialPortParityNone dataBits:FTSerialPortDataBitsEight stopBits:FTSerialPortStopBitsOne];
}

+ (FTSerialPortConfiguration *)defaultConfigurationForPortTwo {
    return [[self alloc] initWithPower:YES flowControl:NO baudRate:FTSerialPortBaudRate9600BPS parity:FTSerialPortParityNone dataBits:FTSerialPortDataBitsEight stopBits:FTSerialPortStopBitsOne];
}

+ (FTSerialPortConfiguration *)defaultConfigurationForPortThree {
    return [[self alloc] initWithPower:YES flowControl:NO baudRate:FTSerialPortBaudRate115200BPS parity:FTSerialPortParityNone dataBits:FTSerialPortDataBitsEight stopBits:FTSerialPortStopBitsOne];
}

+ (FTSerialPortConfiguration *)configurationForPortThreeOnT605 {
    return [[self alloc] initWithPower:YES flowControl:NO baudRate:FTSerialPortBaudRate115200BPS parity:FTSerialPortParityNone dataBits:FTSerialPortDataBitsEight stopBits:FTSerialPortStopBitsOne];
}

@end
