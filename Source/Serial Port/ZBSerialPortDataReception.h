//
//  ZBSerialPortDataReception.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 18/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBSerialPortCommunicator.h"

@interface ZBSerialPortDataReception : NSObject

@property (assign, nonatomic) ZBSerialPortNumber portNumber;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSTimer *timer;

@end
