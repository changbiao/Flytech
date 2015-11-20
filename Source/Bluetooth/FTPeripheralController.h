//
//  FTPeripheralController.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FTSerialPortCommunicator.h"

typedef void(^FTPeripheralControllerPrepareForUseCompletionHandler)(NSString *modelNumber, NSString *firmwareRevision, FTSerialPortCommunicator *serialPortCommunicator, NSError *error);

@interface FTPeripheralController : NSObject

@property (weak, nonatomic) CBPeripheral *peripheral;

- (void)prepareForUseWithCompletion:(FTPeripheralControllerPrepareForUseCompletionHandler)completion;

@end
