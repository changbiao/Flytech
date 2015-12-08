//
//  FTPrinterPageComponent.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

struct FTPrinterPagePoint {
    NSUInteger x;
    NSUInteger y;
};
typedef struct FTPrinterPagePoint FTPrinterPagePoint;
FTPrinterPagePoint FTPrinterPagePointMake(NSUInteger x, NSUInteger y);

@interface FTPrinterPageComponent : NSObject

@property (assign, nonatomic) NSUInteger width;
@property (assign, nonatomic, readonly) NSUInteger height;

- (NSData *)commandDataWithStartingPoint:(FTPrinterPagePoint)startingPoint;

@end
