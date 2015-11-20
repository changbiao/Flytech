//
//  FTSerialPortCommunicator+Private.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTSerialPortCommunicator.h"
#import "FTSerialPortCommunicatorTask.h"

@interface FTSerialPortCommunicator (Private)

@property (weak, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray<FTSerialPortCommunicatorTask *> *tasks;

- (void)receiveData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic;
- (void)completeCurrentTask;

@end
