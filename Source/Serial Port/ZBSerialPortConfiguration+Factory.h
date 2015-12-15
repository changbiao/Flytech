//
//  ZBSerialPortConfiguration+Factory.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 28/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBSerialPortConfiguration.h"
#import "ZBStand.h"
#import "ZBSerialPortCommunicator.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBSerialPortConfiguration (Factory)

+ (nullable ZBSerialPortConfiguration *)configurationForPortNumber:(ZBSerialPortNumber)portNumber standModel:(ZBStandModel)standModel;

@end

NS_ASSUME_NONNULL_END
