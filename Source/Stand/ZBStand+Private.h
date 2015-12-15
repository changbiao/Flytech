//
//  ZBStand+Private.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Zeeba/Zeeba.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZBPeripheralController.h"
#import "ZBSerialPortCommunicator.h"

@interface ZBStand (Private)

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) ZBPeripheralController *peripheralController;
@property (strong, nonatomic) ZBSerialPortCommunicator *serialPortCommunicator;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;
- (void)prepareForUseWithCompletion:(void (^)(NSError *error))completionHandler;

@end
