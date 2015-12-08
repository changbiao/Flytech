//
//  FTPrinterPageComponent.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinterPageComponent.h"

FTPrinterPagePoint FTPrinterPagePointMake(NSUInteger x, NSUInteger y) {
    FTPrinterPagePoint pagePoint;
    pagePoint.x = x;
    pagePoint.y = y;
    return pagePoint;
}

@implementation FTPrinterPageComponent

- (NSUInteger)height {
    return 0;
}

- (NSData *)commandDataWithStartingPoint:(FTPrinterPagePoint)startingPoint {
    return nil;
}

@end
