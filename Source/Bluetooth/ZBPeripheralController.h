//
//  ZBPeripheralController.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZBSerialPortCommunicator.h"

typedef void(^ZBPeripheralControllerPrepareForUseCompletionHandler)(NSString *modelNumber, NSString *firmwareRevision, ZBSerialPortCommunicator *serialPortCommunicator, NSError *error);

@interface ZBPeripheralController : NSObject

@property (weak, nonatomic) CBPeripheral *peripheral;

- (void)prepareForUseWithCompletion:(ZBPeripheralControllerPrepareForUseCompletionHandler)completion;

@end
