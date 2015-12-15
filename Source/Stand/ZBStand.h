//
//  ZBStand.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBConnectivity.h"
#import "ZBPrinter.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZBStandModel) {
    ZBStandModelUnknown = 0,
    ZBStandModelT605
};

typedef void(^ZBPrintHandler)(ZBPrinter *printer);
typedef void(^ZBPrintCompletionHandler)(NSError * _Nullable error);
typedef void(^ZBUndockCompletionHandler)(NSError * _Nullable error);

@interface ZBStand : NSObject

@property (copy, nonatomic, readonly) NSUUID *identifier;
@property (nullable, copy, nonatomic, readonly) NSString *firmwareRevision;
@property (nullable, strong, nonatomic, readonly) ZBPrinter *printer;
@property (assign, nonatomic, readonly) ZBConnectivity connectivity;
@property (assign, nonatomic, readonly) ZBStandModel model;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSUUID *)identifier NS_DESIGNATED_INITIALIZER;

- (void)undockWithCompletion:(ZBUndockCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
