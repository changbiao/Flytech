//
//  ZBPrinterCompositeContent.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 17/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterCompositeContent.h"

@interface ZBPrinterCompositeContent ()

@property (strong, nonatomic, readwrite) NSMutableArray<ZBPrinterContent *> *content;

@end

@implementation ZBPrinterCompositeContent

#pragma mark - Public Interface

- (void)addContent:(ZBPrinterContent *)content {
    [self.content addObject:content];
}

- (void)removeContent:(ZBPrinterContent *)content {
    [self.content removeObject:content];
}

- (void)removeAllContent {
    [self.content removeAllObjects];
}

#pragma mark - ZBPrinterContent

- (NSData *)commandData {
    NSMutableData *commandData = [NSMutableData data];
    NSUInteger verticalOffset = 0;
    for (ZBPrinterContent *content in self.content) {
        [commandData appendData:content.commandData];
        verticalOffset += content.height;
        if (content != self.content.lastObject) {
            verticalOffset += self.verticalContentPadding;
        }
    }
    return commandData;
}

#pragma mark - Accessors

- (NSMutableArray<ZBPrinterContent *> *)content {
    if (!_content) {
        _content = [NSMutableArray array];
    }
    return _content;
}

@end
