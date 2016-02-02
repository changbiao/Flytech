//
//  ZBPrinterContent.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 17/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterContent.h"

@interface ZBPrinterContent ()

@property (copy, nonatomic, readwrite) NSData *commandData;

@end

@implementation ZBPrinterContent

#pragma mark - Initialization

- (instancetype)initWithCommandData:(NSData *)commandData {
    self = [super init];
    if (self) {
        self.commandData = commandData;
    }
    return self;
}

@end
