//
//  ZBPrinterContent.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 17/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 *  @class ZBPrinterContent
 *  @discussion This class represents a piece of printable content.
 */
@interface ZBPrinterContent : NSObject

/*!
 *  @property commandData
 *  @discussion This property returns the command data that can be sent to the printer, in order to print the content.
 */
@property (copy, nonatomic, readonly) NSData *commandData;

/*!
 *  @property height
 *  @discussion The height of the content in points.
 */
@property (assign, nonatomic) NSUInteger height;

/*!
 *  @property width
 *  @discussion The width of the content in points.
 */
@property (assign, nonatomic) NSUInteger width;

/*!
 *  @method initWithCommandData:
 *  @param commandData The command data for the content object.
 */
- (instancetype)initWithCommandData:(NSData *)commandData NS_DESIGNATED_INITIALIZER;

/*!
 *  @method init
 *  @discussion Unavailable. Use initWithCommandData: initializer.
 */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
