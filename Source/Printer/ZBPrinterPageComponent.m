//
//  ZBPrinterPageComponent.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterPageComponent.h"

ZBPrinterPagePoint ZBPrinterPagePointMake(NSUInteger x, NSUInteger y) {
    ZBPrinterPagePoint pagePoint;
    pagePoint.x = x;
    pagePoint.y = y;
    return pagePoint;
}

@implementation ZBPrinterPageComponent

- (NSUInteger)height {
    return 0;
}

- (NSData *)commandDataWithStartingPoint:(ZBPrinterPagePoint)startingPoint pageBuilder:(ZBPrinterPageBuilder *)pageBuilder {
    return nil;
}

@end
