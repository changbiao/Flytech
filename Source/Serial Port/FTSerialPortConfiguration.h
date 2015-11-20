//
//  FTSerialPortConfiguration.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 27/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FTSerialPortBaudRate) {
    FTSerialPortBaudRate1200BPS = 0,
    FTSerialPortBaudRate2400BPS = 1,
    FTSerialPortBaudRate4800BPS = 2,
    FTSerialPortBaudRate9600BPS = 3,
    FTSerialPortBaudRate19200BPS = 4,
    FTSerialPortBaudRate38400BPS = 5,
    FTSerialPortBaudRate57600BPS = 6,
    FTSerialPortBaudRate115200BPS = 7
};

typedef NS_ENUM(NSUInteger, FTSerialPortParity) {
    FTSerialPortParityNone = 0,
    FTSerialPortParityEven = 1,
    FTSerialPortParityOdd = 2
};

typedef NS_ENUM(NSUInteger, FTSerialPortDataBits) {
    FTSerialPortDataBitsSeven = 7,
    FTSerialPortDataBitsEight = 8
};

typedef NS_ENUM(NSUInteger, FTSerialPortStopBits) {
    FTSerialPortStopBitsOne = 1,
    FTSerialPortStopBitsTwo = 2
};

@interface FTSerialPortConfiguration : NSObject

@property (assign, nonatomic) BOOL powered;
@property (assign, nonatomic) BOOL flowControlled;
@property (assign, nonatomic) FTSerialPortBaudRate baudRate;
@property (assign, nonatomic) FTSerialPortParity parity;
@property (assign, nonatomic) FTSerialPortDataBits dataBits;
@property (assign, nonatomic) FTSerialPortStopBits stopBits;
@property (copy, nonatomic, readonly) NSData *dataRepresentation;

- (instancetype)initWithPower:(BOOL)power flowControl:(BOOL)flowControl baudRate:(FTSerialPortBaudRate)baudRate parity:(FTSerialPortParity)parity dataBits:(FTSerialPortDataBits)dataBits stopBits:(FTSerialPortStopBits)stopBits;
- (instancetype)initWithData:(NSData *)data;

@end
