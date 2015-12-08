//
//  FTPrinterFunctionSettings+Factory.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 26/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Flytech/Flytech.h>

@interface FTPrinterFunctionSettings (Factory)

+ (instancetype)functionSettingsForStandModel:(FTStandModel)standModel;

@end
