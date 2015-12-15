//
//  CBCentralManager+ZBFactory.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 23/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBCentralManager (ZBFactory)

+ (CBCentralManager *)zeebaCentralManagerWithDelegate:(id<CBCentralManagerDelegate>)delegate;

@end
