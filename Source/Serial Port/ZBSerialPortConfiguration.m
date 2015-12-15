//
//  ZBSerialPortConfiguration.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 27/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBSerialPortConfiguration.h"

@implementation ZBSerialPortConfiguration

#pragma mark - Life Cycle

- (instancetype)initWithPower:(BOOL)power flowControl:(BOOL)flowControl baudRate:(ZBSerialPortBaudRate)baudRate parity:(ZBSerialPortParity)parity dataBits:(ZBSerialPortDataBits)dataBits stopBits:(ZBSerialPortStopBits)stopBits {
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
    if ([object isKindOfClass:[ZBSerialPortConfiguration class]]) {
        ZBSerialPortConfiguration *otherConfiguration = object;
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
        case ZBSerialPortBaudRate1200BPS: return @"1200 BPS"; break;
        case ZBSerialPortBaudRate2400BPS: return @"2400 BPS"; break;
        case ZBSerialPortBaudRate4800BPS: return @"4800 BPS"; break;
        case ZBSerialPortBaudRate9600BPS: return @"9600 BPS"; break;
        case ZBSerialPortBaudRate19200BPS: return @"19200 BPS"; break;
        case ZBSerialPortBaudRate38400BPS: return @"38400 BPS"; break;
        case ZBSerialPortBaudRate57600BPS: return @"57600 BPS"; break;
        case ZBSerialPortBaudRate115200BPS: return @"115200 BPS"; break;
    }
    return nil;
}

- (NSString *)descriptiveParity {
    switch (self.parity) {
        case ZBSerialPortParityNone: return @"None"; break;
        case ZBSerialPortParityEven: return @"Even"; break;
        case ZBSerialPortParityOdd: return @"Odd"; break;
    }
    return nil;
}

- (NSString *)descriptiveDataBits {
    switch (self.dataBits) {
        case ZBSerialPortDataBitsSeven: return @"7"; break;
        case ZBSerialPortDataBitsEight: return @"8"; break;
    }
    return nil;
}

- (NSString *)descriptiveStopBits {
    switch (self.stopBits) {
        case ZBSerialPortStopBitsOne: return @"1"; break;
        case ZBSerialPortStopBitsTwo: return @"2"; break;
    }
    return nil;
}

@end
