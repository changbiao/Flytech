//
//  ZBPrinterCompositeContent.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 17/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBPrinterContent.h"

/*!
 *  @class ZBPrinterCompositeContent
 *  @discussion This class is used to easily compose content consisting of multiple other pieces of content.
 */
@interface ZBPrinterCompositeContent : ZBPrinterContent

/*!
 *  @property content
 *  @discussion The content items composed. Items can also be added/removed directly through this array.
 */
@property (strong, nonatomic, readonly) NSMutableArray<ZBPrinterContent *> *content;

/*!
 *  @property verticalContentPadding
 *  @discussion The padding that will be added in between each piece of content vertically.
 */
@property (assign, nonatomic) NSUInteger verticalContentPadding;

/*!
 *  @method addContent:
 *  @param content The content to add.
 *  @discussion Shortcut for adding content to the content array.
 */
- (void)addContent:(ZBPrinterContent *)content;

/*!
 *  @method removeContent:
 *  @param content The content to remove.
 *  @discussion Shortcut for removing content from the content array.
 */
- (void)removeContent:(ZBPrinterContent *)content;

/*!
 *  @method removeAllContent
 *  @discussion Shortcut for removing all content from the content array.
 */
- (void)removeAllContent;

@end
