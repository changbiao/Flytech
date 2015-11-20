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

- (instancetype)initWithPower:(BOOL)power flowControl:(BOOL)flowControl baudRate:(FTSerialPortBaudRate)baudRate parity:(FTSerialPortParity)parity dataBits:(FTSerialPortDataBits)dataBits stopBits:(FTSerialPortStopBits)stopBits {
    self = [super init];
    if (self) {
        self.powered = power;
        self.flowControlled = flowControl;
        self.baudRate = baudRate;
        self.parity = parity;
        self.dataBits = dataBits;
        self.stopBits = stopBits;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = data.length == 5 ? [super init] : nil;
    if (self) {
        unsigned char baudRate;
        [data getBytes:&baudRate range:NSMakeRange(0, 1)];
        self.baudRate = baudRate;
        unsigned char parity;
        [data getBytes:&parity range:NSMakeRange(1, 1)];
        self.parity = parity;
        unsigned char dataBits;
        [data getBytes:&dataBits range:NSMakeRange(2, 1)];
        self.dataBits = dataBits;
        unsigned char stopBits;
        [data getBytes:&stopBits range:NSMakeRange(3, 1)];
        self.stopBits = stopBits;
        unsigned char settingsByte;
        [data getBytes:&settingsByte range:NSMakeRange(4, 1)];
        self.powered = settingsByte & 0x02;
        self.flowControlled = settingsByte & 0x01;
    }
    return self;
}

#pragma mark - Public Interface

- (NSData *)dataRepresentation {
    NSMutableData *dataRepresentation = [NSMutableData dataWithCapacity:5];
    unsigned char baudRate = self.baudRate;
    [dataRepresentation appendBytes:&baudRate length:1];
    unsigned char parity = self.parity;
    [dataRepresentation appendBytes:&parity length:1];
    unsigned char dataBits = self.dataBits;
    [dataRepresentation appendBytes:&dataBits length:1];
    unsigned char stopBits = self.stopBits;
    [dataRepresentation appendBytes:&stopBits length:1];
    unsigned char settingsByte = 0x00;
    if (self.powered) {
        settingsByte = settingsByte | 0x02;
    }
    if (self.flowControlled) {
        settingsByte = settingsByte | 0x01;
    }
    [dataRepresentation appendBytes:&settingsByte length:1];
    return dataRepresentation;
}

- (NSString *)description {
    NSString *powered = self.powered ? @"YES" : @"NO";
    NSString *flowControlled = self.flowControlled ? @"YES" : @"NO";
    NSString *baudRate = [self descriptiveBaudRate];
    NSString *parity = [self descriptiveParity];
    NSString *dataBits = [self descriptiveDataBits];
    NSString *stopBits = [self descriptiveStopBits];
    return [NSString stringWithFormat:@"Data representation: %@ | Powered: %@ | Flow controlled: %@ | Baud rate: %@ | Parity: %@ | Data bits: %@ | Stop bits: %@", self.dataRepresentation, powered, flowControlled, baudRate, parity, dataBits, stopBits];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[FTSerialPortConfiguration class]]) {
        FTSerialPortConfiguration *otherConfiguration = object;
        return (self.powered == otherConfiguration.powered &&
                self.flowControlled == otherConfiguration.flowControlled &&
                self.baudRate == otherConfiguration.baudRate &&
                self.parity == otherConfiguration.parity &&
                self.dataBits == otherConfiguration.dataBits &&
                self.stopBits == otherConfiguration.stopBits);
    }
    return NO;
}

#pragma mark - Internals

- (NSString *)descriptiveBaudRate {
    switch (self.baudRate) {
        case FTSerialPortBaudRate1200BPS: return @"1200 BPS"; break;
        case FTSerialPortBaudRate2400BPS: return @"2400 BPS"; break;
        case FTSerialPortBaudRate4800BPS: return @"4800 BPS"; break;
        case FTSerialPortBaudRate9600BPS: return @"9600 BPS"; break;
        case FTSerialPortBaudRate19200BPS: return @"19200 BPS"; break;
        case FTSerialPortBaudRate38400BPS: return @"38400 BPS"; break;
        case FTSerialPortBaudRate57600BPS: return @"57600 BPS"; break;
        case FTSerialPortBaudRate115200BPS: return @"115200 BPS"; break;
    }
    return nil;
}

- (NSString *)descriptiveParity {
    switch (self.parity) {
        case FTSerialPortParityNone: return @"None"; break;
        case FTSerialPortParityEven: return @"Even"; break;
        case FTSerialPortParityOdd: return @"Odd"; break;
    }
    return nil;
}

- (NSString *)descriptiveDataBits {
    switch (self.dataBits) {
        case FTSerialPortDataBitsSeven: return @"7"; break;
        case FTSerialPortDataBitsEight: return @"8"; break;
    }
    return nil;
}

- (NSString *)descriptiveStopBits {
    switch (self.stopBits) {
        case FTSerialPortStopBitsOne: return @"1"; break;
        case FTSerialPortStopBitsTwo: return @"2"; break;
    }
    return nil;
}

@end
