//
//  CBCentralManager+Factory.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 23/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBCentralManager (Factory)

+ (CBCentralManager *)flytechCentralManagerWithDelegate:(id<CBCentralManagerDelegate>)delegate;

@end
