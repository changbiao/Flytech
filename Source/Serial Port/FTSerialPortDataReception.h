//
//  FTSerialPortDataReception.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 18/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTSerialPortCommunicator.h"

@interface FTSerialPortDataReception : NSObject

@property (assign, nonatomic) FTSerialPortNumber portNumber;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSTimer *timer;

@end
