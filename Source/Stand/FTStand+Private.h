//
//  FTStand+Private.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Flytech/Flytech.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FTPeripheralController.h"
#import "FTSerialPortCommunicator.h"

@interface FTStand (Private)

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) FTPeripheralController *peripheralController;
@property (strong, nonatomic) FTSerialPortCommunicator *serialPortCommunicator;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;
- (void)prepareForUseWithCompletion:(void (^)(NSError *error))completionHandler;

@end
