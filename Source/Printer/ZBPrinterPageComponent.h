//
//  ZBPrinterPageComponent.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZBPrinterPageBuilder;

struct ZBPrinterPagePoint {
    NSUInteger x;
    NSUInteger y;
};
typedef struct ZBPrinterPagePoint ZBPrinterPagePoint;
ZBPrinterPagePoint ZBPrinterPagePointMake(NSUInteger x, NSUInteger y);

@interface ZBPrinterPageComponent : NSObject

@property (assign, nonatomic) NSUInteger width;
@property (assign, nonatomic, readonly) NSUInteger height;

- (NSData *)commandDataWithStartingPoint:(ZBPrinterPagePoint)startingPoint pageBuilder:(ZBPrinterPageBuilder *)pageBuilder;

@end
