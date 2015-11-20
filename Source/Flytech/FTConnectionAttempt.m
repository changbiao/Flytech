//
//  FTConnectionAttempt.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 26/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTConnectionAttempt.h"

@implementation FTConnectionAttempt

#pragma mark - Life Cycle

- (instancetype)initWithStand:(FTStand *)stand timeoutTimer:(NSTimer *)timeoutTimer completionHandler:(FTConnectCompletionHandler)completionHandler {
    self = [self init];
    if (self) {
        self.stand = stand;
        self.timeoutTimer = timeoutTimer;
        self.completionHandler = completionHandler;
    }
    return self;
}

@end
