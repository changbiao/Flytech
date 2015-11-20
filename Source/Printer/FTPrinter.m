//
//  FTPrinter.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter.h"
#import "FTPrinter+Private.h"
#import "FTPrinter+HexCmd.h"
#import "NSData+FTHex.h"
#import "FTPrinter+Advanced.h"

@implementation FTPrinter

#pragma mark - Public Interface

- (void)printTestMaterialWithCompletion:(FTPrintCompletionHandler)completionHandler {
    /*[self setPrinterModeWithCharacterFont:FTPrinterCharacterFont16x8 bold:NO doubleHeight:NO doubleWidth:NO];
    [self.serialPortCommunicator sendData:[NSData dataWithHex:@"1277010C0100"] toPortNumber:self.portNumber completion:nil];
    [self.serialPortCommunicator sendData:[NSData dataWithHex:@"0C"] toPortNumber:self.portNumber completion:nil];*/
    [self.serialPortCommunicator sendData:[NSData dataWithHex:FTPrinterHexCmdTestPrint] toPortNumber:self.portNumber completion:completionHandler];
}

@end
