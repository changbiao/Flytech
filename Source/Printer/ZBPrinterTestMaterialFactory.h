//
//  ZBPrinterTestMaterialFactory.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 15/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBPrinter.h"

@interface ZBPrinterTestMaterialFactory : NSObject

+ (ZBPrinterPageBuilderBlock)testMaterialPageBuilderBlock;

@end
