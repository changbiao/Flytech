//
//  ZBPrinterStatusUpdate.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 26/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZBPrinterStatusPaperFeedMotorDrive) {
    ZBPrinterStatusPaperFeedMotorDriveStop = 0,
    ZBPrinterStatusPaperFeedMotorDriveWork = 1
};

typedef NS_ENUM(NSUInteger, ZBPrinterStatusDrawerSensor) {
    ZBPrinterStatusDrawerSensorLow = 0,
    ZBPrinterStatusDrawerSensorHigh = 1
};

@interface ZBPrinterStatusUpdate : NSObject

@property (copy, nonatomic, readonly) NSData *data;
@property (assign, nonatomic) ZBPrinterStatusPaperFeedMotorDrive paperFeedMotorDriveStatus;
@property (assign, nonatomic) ZBPrinterStatusDrawerSensor drawerSensorStatus;
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
