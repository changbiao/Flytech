//
//  FTPrinterTask.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 26/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTPrinterFunctionSettings;

@interface FTPrinterTask : NSObject
@property (copy, nonatomic) id completionHandler;
@end

@interface FTPrinterTaskSendData : FTPrinterTask
@property (copy, nonatomic) NSData *data;
@property (copy, nonatomic) void(^completionHandler)(NSError *error);
@end

@interface FTPrinterTaskGetFunctionSettings : FTPrinterTask
@property (copy, nonatomic) void(^completionHandler)(FTPrinterFunctionSettings *functionSettings, NSError *error);
@end
