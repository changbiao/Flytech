//
//  ZBZeeba+SharedInstance.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Zeeba/Zeeba.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBZeeba (SharedInstance)

/**
 Easy to access shared instance.
 @returns A shared instance object of the ZBZeeba class. The object will be retained and exist
 for the remaining life span of the application.
 */
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
