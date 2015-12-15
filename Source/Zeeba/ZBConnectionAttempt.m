//
//  ZBConnectionAttempt.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 26/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBConnectionAttempt.h"

@implementation ZBConnectionAttempt

#pragma mark - Life Cycle

- (instancetype)initWithStand:(ZBStand *)stand timeoutTimer:(NSTimer *)timeoutTimer completionHandler:(ZBConnectCompletionHandler)completionHandler {
    self = [self init];
    if (self) {
        self.stand = stand;
        self.timeoutTimer = timeoutTimer;
        self.completionHandler = completionHandler;
    }
    return self;
}

@end
