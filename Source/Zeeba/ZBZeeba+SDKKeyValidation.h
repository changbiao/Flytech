//
//  ZBZeeba+SDKKeyValidation.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 15/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Zeeba/Zeeba.h>

@interface ZBZeeba (SDKKeyValidation)

+ (BOOL)validateSDKKey:(NSString *)key failure:(void(^)())failure;

@end
