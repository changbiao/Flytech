//
//  FTSerialPortConfigurator.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 12/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTStand.h"

@class FTSerialPortCommunicator;

@interface FTSerialPortConfigurator : NSObject

- (void)applyConfigurationAppropriateForStandModel:(FTStandModel)model toSerialPortCommunicator:(FTSerialPortCommunicator *)communicator completion:(void (^)(NSError *))completion;

@end
