//
//  FTSerialPortConfiguration+Factory.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTSerialPortConfiguration.h"
#import "FTStand.h"
#import "FTSerialPortCommunicator.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTSerialPortConfiguration (Factory)

+ (nullable FTSerialPortConfiguration *)configurationForPortNumber:(FTSerialPortNumber)portNumber standModel:(FTStandModel)standModel;

@end

NS_ASSUME_NONNULL_END
