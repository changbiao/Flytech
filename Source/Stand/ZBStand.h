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

typedef void(^ZBLockCompletionHandler)(NSError * _Nullable error);

/*!
 *  @enum ZBStandModel
 *  @discussion The different models that are supported by the SDK.
 *  @constant ZBStandModelUnknown Model unknown. Either because it hasn't been discovered yet or because the model information retrieved wasn't known.
 *  @constant ZBStandModelT605 Stand model T605.
 */
typedef NS_ENUM(NSUInteger, ZBStandModel) {
    ZBStandModelUnknown = 0,
    ZBStandModelT605
};

/*!
 *  @class ZBStand
 *  @discussion Objects of this class represent a stand.
 */
@interface ZBStand : NSObject

/*!
 *  @property identifier
 *  @discussion The stand's unique identifier. You can only set this upon initialization, otherwise it will be populated when the stand is discovered by a ZBZeeba object.
 *  @see initWithIdentifier:
 */
@property (copy, nonatomic, readonly) NSUUID *identifier;

/*!
 *  @property firmwareRevision
 *  @discussion The stand's current firmware revision. Present it to the user for quicker troubleshooting.
 */
@property (nullable, copy, nonatomic, readonly) NSString *firmwareRevision;

/*!
 *  @property printer
 *  @discussion Access the stand's printer through this property. This property will return nil unless the stand is connected and ready.
 */
@property (nullable, strong, nonatomic, readonly) ZBPrinter *printer;

/*!
 *  @property connectivity
 *  @discussion The current connectivity state of the stand.
 */
@property (assign, nonatomic, readonly) ZBConnectivity connectivity;

/*!
 *  @property model
 *  @discussion The model of the stand.
 */
@property (assign, nonatomic, readonly) ZBStandModel model;

/*!
 *  @method initWithIdentifier:
 *  @discussion Initialize a ZBStand object with an already known identifier. Useful when one has persisted identifiers for stands used in the past.
 *  @param identifier The identifier for the stand.
 */
- (instancetype)initWithIdentifier:(NSUUID *)identifier NS_DESIGNATED_INITIALIZER;

/*!
 *  @method init
 *  @discussion Unavailable. Use initWithIdentifier: instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/*!
 *  @method setTabletLock:completion:
 *  @discussion Enables or disables the tabled locking mechanism of the stand.
 *  @param lock Whether or not the locking mechanism should be enabled.
 *  @param completion A handler that is called once the call completes.
 */
- (void)setTabletLock:(BOOL)lock completion:(ZBLockCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
