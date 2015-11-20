//
//  FTStand.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 14/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTConnectivity.h"
#import "FTPrinter.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FTStandModel) {
    FTStandModelUnknown = 0,
    FTStandModelT605
};

typedef void(^FTPrintHandler)(FTPrinter *printer);
typedef void(^FTPrintCompletionHandler)(NSError * _Nullable error);
typedef void(^FTUndockCompletionHandler)(NSError * _Nullable error);

@interface FTStand : NSObject

@property (copy, nonatomic, readonly) NSUUID *identifier;
@property (nullable, copy, nonatomic, readonly) NSString *firmwareRevision;
@property (nullable, strong, nonatomic, readonly) FTPrinter *printer;
@property (assign, nonatomic, readonly) FTConnectivity connectivity;
@property (assign, nonatomic, readonly) FTStandModel model;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSUUID *)identifier NS_DESIGNATED_INITIALIZER;

- (void)print:(FTPrintHandler)printHandler completion:(FTPrintCompletionHandler)completionHandler;
- (void)undockWithCompletion:(FTUndockCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
