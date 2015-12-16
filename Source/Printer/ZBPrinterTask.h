//
//  ZBPrinterTask.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 26/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZBPrinterFunctionSettings;

@interface ZBPrinterTask : NSObject
@property (copy, nonatomic) id completion;
@end

@interface ZBPrinterTaskSendData : ZBPrinterTask
@property (copy, nonatomic) NSData *data;
@property (copy, nonatomic) void(^completion)(NSError *error);
@end

@interface ZBPrinterTaskGetFunctionSettings : ZBPrinterTask
@property (copy, nonatomic) void(^completion)(ZBPrinterFunctionSettings *functionSettings, NSError *error);
@end
