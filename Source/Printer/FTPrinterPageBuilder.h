//
//  FTPrinterPageBuilder.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPrinter.h"
#import "FTPrinterPageComponent.h"
#import "FTPrinterPageTextComponent.h"
#import "FTPrinterPageColumnsComponent.h"

@interface FTPrinterPageBuilder : NSObject

@property (copy, nonatomic, readonly) NSData *commandData;
@property (strong, nonatomic, readonly) NSMutableArray *pageComponents;
@property (assign, nonatomic) NSUInteger verticalPageComponentPadding;

- (void)addPageComponent:(FTPrinterPageComponent *)pageComponent;
- (void)addPageComponentWithText:(NSString *)text font:(FTPrinterCharacterFont)font scale:(NSUInteger)scale alignment:(FTPrinterAlignment)alignment;
- (void)addHorizontalLinePageComponent;

@end
