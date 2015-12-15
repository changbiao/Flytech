//
//  ZBSerialPortConfigurator.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 12/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBStand.h"

@class ZBSerialPortCommunicator;

@interface ZBSerialPortConfigurator : NSObject

- (void)applyConfigurationAppropriateForStandModel:(ZBStandModel)model toSerialPortCommunicator:(ZBSerialPortCommunicator *)communicator completion:(void (^)(NSError *))completion;

@end
