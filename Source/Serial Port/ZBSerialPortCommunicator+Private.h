//
//  ZBSerialPortCommunicator+Private.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBSerialPortCommunicator.h"
#import "ZBSerialPortCommunicatorTask.h"

@interface ZBSerialPortCommunicator (Private)

@property (weak, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray<ZBSerialPortCommunicatorTask *> *tasks;

- (void)processSendDataEnsuredTask:(ZBSerialPortCommunicatorTask *)task;
- (void)sendingDataCompletedForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)receiveData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic;
- (void)completeCurrentTask;
- (void)completeCurrentSendDataTaskWithError:(NSError *)error;
- (CBService *)serviceForPortNumber:(ZBSerialPortNumber)portNumber;
- (CBCharacteristic *)writeCharacteristicForService:(CBService *)service;

@end
