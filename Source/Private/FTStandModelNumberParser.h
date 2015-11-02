//
//  FTStandModelNumberParser.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 29/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTStand.h"

@interface FTStandModelNumberParser : NSObject

+ (FTStandModel)standModelForModelNumberString:(NSString *)modelNumberString;

@end
