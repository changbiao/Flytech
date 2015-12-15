//
//  ZBStandModelNumberParser.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 29/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBStand.h"

@interface ZBStandModelNumberParser : NSObject

+ (ZBStandModel)standModelForModelNumberString:(NSString *)modelNumberString;

@end
