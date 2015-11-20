//
//  FTPrinter+Advanced.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 17/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter+Advanced.h"
#import "FTPrinter+Private.h"
#import "NSData+FTHex.h"
#import "FTPrinter+HexCmd.h"

@implementation FTPrinter (Advanced)

#pragma mark - Public Interface

- (void)send512ZeroBytes {
    [self.serialPortCommunicator sendData:[NSData dataWithHex:FTPrinterHexCmd512ZeroBytes] toPortNumber:self.portNumber completion:nil];
}

- (void)initializeHardware {
    [self.serialPortCommunicator sendData:[NSData dataWithHex:FTPrinterHexCmdPrinterInitialize] toPortNumber:self.portNumber completion:nil];
}

- (void)enablePrinter:(BOOL)enable {
    unsigned char value = enable;
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdPeripheralEquipmentSelection];
    [command appendBytes:&value length:sizeof(value)];
    [self.serialPortCommunicator sendData:command toPortNumber:self.portNumber completion:nil];
}

- (void)setPrinterModeWithCharacterFont:(FTPrinterCharacterFont)characterFont bold:(BOOL)bold doubleHeight:(BOOL)doubleHeight doubleWidth:(BOOL)doubleWidth {
    unsigned char mode = 0x00;
    switch (characterFont) {
        case FTPrinterCharacterFont24x12: break;
        case FTPrinterCharacterFont16x8: mode = mode | 0x01;
    }
    if (bold) {
        mode = mode | 0x08;
    }
    if (doubleHeight) {
        mode = mode | 0x10;
    }
    if (doubleWidth) {
        mode = mode | 0x20;
    }
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdPrintModeSelect];
    [command appendBytes:&mode length:sizeof(mode)];
    [self.serialPortCommunicator sendData:command toPortNumber:self.portNumber completion:nil];
}

- (void)settingsWithCompletion:(void (^)(NSData *response, NSError *error))completion {
    [self.serialPortCommunicator sendData:[NSData dataWithHex:FTPrinterHexCmdFunctionSettingResponse] toPortNumber:self.portNumber completion:nil];
    // [self.serialPortCommunicator sendData:[NSData dataWithHex:@"127100"] toPortNumber:self.portNumber completion:nil];
    completion(nil, nil);
}

- (void)enableAutomaticStatusBackForChangingDrawerSensorStatus:(BOOL)cdss printerInformation:(BOOL)printerInfo errorStatus:(BOOL)es paperSensorInformation:(BOOL)psi presenterInformation:(BOOL)presenterInfo {
    unsigned char automaticStatusBack = 0x00;
    if (cdss) {
        automaticStatusBack = automaticStatusBack | 0x01;
    }
    if (printerInfo) {
        automaticStatusBack = automaticStatusBack | 0x02;
    }
    if (es) {
        automaticStatusBack = automaticStatusBack | 0x04;
    }
    if (psi) {
        automaticStatusBack = automaticStatusBack | 0x08;
    }
    if (presenterInfo) {
        automaticStatusBack = automaticStatusBack | 0x10;
    }
    NSMutableData *command = [NSMutableData dataWithHex:FTPrinterHexCmdAutomaticStatusBackEnableDisable];
    [command appendBytes:&automaticStatusBack length:sizeof(automaticStatusBack)];
    [self.serialPortCommunicator sendData:command toPortNumber:self.portNumber completion:nil];
}

@end
