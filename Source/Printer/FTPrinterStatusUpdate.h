//
//  FTPrinterStatusUpdate.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 26/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FTPrinterStatusPaperFeedMotorDrive) {
    FTPrinterStatusPaperFeedMotorDriveStop = 0,
    FTPrinterStatusPaperFeedMotorDriveWork = 1
};

typedef NS_ENUM(NSUInteger, FTPrinterStatusDrawerSensor) {
    FTPrinterStatusDrawerSensorLow = 0,
    FTPrinterStatusDrawerSensorHigh = 1
};

@interface FTPrinterStatusUpdate : NSObject

@property (copy, nonatomic, readonly) NSData *data;
@property (assign, nonatomic) FTPrinterStatusPaperFeedMotorDrive paperFeedMotorDriveStatus;
@property (assign, nonatomic) FTPrinterStatusDrawerSensor drawerSensorStatus;
@property (assign, nonatomic) BOOL coverOpen;
@property (assign, nonatomic) BOOL paperFeedingBySwitch;
@property (assign, nonatomic) BOOL paperJammedWhileDetectingMark;
@property (assign, nonatomic) BOOL autoCutterErrorEncountered;
@property (assign, nonatomic) BOOL headOrVoltageErrorEncountered;
@property (assign, nonatomic) BOOL willRecoverFromErrorAutomatically;
@property (assign, nonatomic) BOOL paperNearEndDetected;
@property (assign, nonatomic) BOOL outOfPaperDetected;
@property (assign, nonatomic) BOOL markDetected;
@property (assign, nonatomic) BOOL paperDetected;
@property (assign, nonatomic) BOOL paperFeedErrorEncountered;
@property (assign, nonatomic) BOOL paperJamErrorEncountered;

+ (BOOL)validateDataForInitialization:(NSData *)data;
- (instancetype)initWithData:(NSData *)data NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;


@end
