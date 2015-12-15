//
//  ZBPrinterFunctionSettings+Factory.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 26/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Zeeba/Zeeba.h>

@interface ZBPrinterFunctionSettings (Factory)

+ (instancetype)functionSettingsForStandModel:(ZBStandModel)standModel;

@end
