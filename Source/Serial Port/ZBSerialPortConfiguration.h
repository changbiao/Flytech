//
//  ZBSerialPortConfiguration.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 27/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZBSerialPortBaudRate) {
    ZBSerialPortBaudRate1200BPS = 0,
    ZBSerialPortBaudRate2400BPS = 1,
    ZBSerialPortBaudRate4800BPS = 2,
    ZBSerialPortBaudRate9600BPS = 3,
    ZBSerialPortBaudRate19200BPS = 4,
    ZBSerialPortBaudRate38400BPS = 5,
    ZBSerialPortBaudRate57600BPS = 6,
    ZBSerialPortBaudRate115200BPS = 7
};

typedef NS_ENUM(NSUInteger, ZBSerialPortParity) {
    ZBSerialPortParityNone = 0,
    ZBSerialPortParityEven = 1,
    ZBSerialPortParityOdd = 2
};

typedef NS_ENUM(NSUInteger, ZBSerialPortDataBits) {
    ZBSerialPortDataBitsSeven = 7,
    ZBSerialPortDataBitsEight = 8
};

typedef NS_ENUM(NSUInteger, ZBSerialPortStopBits) {
    ZBSerialPortStopBitsOne = 1,
    ZBSerialPortStopBitsTwo = 2
};

@interface ZBSerialPortConfiguration : NSObject

@property (assign, nonatomic) BOOL powered;
@property (assign, nonatomic) BOOL flowControlled;
@property (assign, nonatomic) ZBSerialPortBaudRate baudRate;
@property (assign, nonatomic) ZBSerialPortParity parity;
@property (assign, nonatomic) ZBSerialPortDataBits dataBits;
@property (assign, nonatomic) ZBSerialPortStopBits stopBits;
@property (copy, nonatomic, readonly) NSData *dataRepresentation;

- (instancetype)initWithPower:(BOOL)power flowControl:(BOOL)flowControl baudRate:(ZBSerialPortBaudRate)baudRate parity:(ZBSerialPortParity)parity dataBits:(ZBSerialPortDataBits)dataBits stopBits:(ZBSerialPortStopBits)stopBits;
- (instancetype)initWithData:(NSData *)data;

@end
