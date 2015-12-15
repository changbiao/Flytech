//
//  ZBSerialPortConfiguration+Factory.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBSerialPortConfiguration+Factory.h"

@implementation ZBSerialPortConfiguration (Factory)

#pragma mark - Public Interface

+ (ZBSerialPortConfiguration *)configurationForPortNumber:(ZBSerialPortNumber)portNumber standModel:(ZBStandModel)standModel {
    switch (portNumber) {
        case ZBSerialPortNumberOne: {
            return [self defaultConfigurationForPortOne];
            break;
        }
        case ZBSerialPortNumberTwo: {
            return [self defaultConfigurationForPortTwo];
            break;
        }
        case ZBSerialPortNumberThree: {
            switch (standModel) {
                case ZBStandModelT605: {
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

+ (ZBSerialPortConfiguration *)defaultConfigurationForPortOne {
    return [[self alloc] initWithPower:NO flowControl:NO baudRate:ZBSerialPortBaudRate9600BPS parity:ZBSerialPortParityNone dataBits:ZBSerialPortDataBitsEight stopBits:ZBSerialPortStopBitsOne];
}

+ (ZBSerialPortConfiguration *)defaultConfigurationForPortTwo {
    return [[self alloc] initWithPower:YES flowControl:NO baudRate:ZBSerialPortBaudRate9600BPS parity:ZBSerialPortParityNone dataBits:ZBSerialPortDataBitsEight stopBits:ZBSerialPortStopBitsOne];
}

+ (ZBSerialPortConfiguration *)defaultConfigurationForPortThree {
    return [[self alloc] initWithPower:YES flowControl:NO baudRate:ZBSerialPortBaudRate115200BPS parity:ZBSerialPortParityNone dataBits:ZBSerialPortDataBitsEight stopBits:ZBSerialPortStopBitsOne];
}

+ (ZBSerialPortConfiguration *)configurationForPortThreeOnT605 {
    return [[self alloc] initWithPower:YES flowControl:NO baudRate:ZBSerialPortBaudRate115200BPS parity:ZBSerialPortParityNone dataBits:ZBSerialPortDataBitsEight stopBits:ZBSerialPortStopBitsOne];
}

@end
