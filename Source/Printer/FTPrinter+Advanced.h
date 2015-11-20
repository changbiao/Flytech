//
//  FTPrinter+Advanced.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 17/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Flytech/Flytech.h>

typedef NS_ENUM(NSUInteger, FTPrinterCharacterFont) {
    FTPrinterCharacterFont24x12 = 0,
    FTPrinterCharacterFont16x8 = 1
};

@interface FTPrinter (Advanced)

- (void)send512ZeroBytes;
- (void)initializeHardware;
- (void)enablePrinter:(BOOL)enable;
- (void)setPrinterModeWithCharacterFont:(FTPrinterCharacterFont)characterFont bold:(BOOL)bold doubleHeight:(BOOL)doubleHeight doubleWidth:(BOOL)doubleWidth;
- (void)settingsWithCompletion:(void(^)(NSData *response, NSError *error))completion;
- (void)enableAutomaticStatusBackForChangingDrawerSensorStatus:(BOOL)cdss printerInformation:(BOOL)printerInfo errorStatus:(BOOL)es paperSensorInformation:(BOOL)psi presenterInformation:(BOOL)presenterInfo;

@end
