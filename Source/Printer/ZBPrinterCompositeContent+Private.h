//
//  ZBPrinterCompositeContent+Private.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 16/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinter+Advanced.h"
#import "ZBPrinterCompositeContent.h"

@interface ZBPrinterCompositeContent (Private)

@property (assign, nonatomic) BOOL containedInColumn;
@property (assign, nonatomic) ZBPrinterCharacterFont currentCharacterFont;
@property (assign, nonatomic) NSUInteger currentCharacterScale;
@property (assign, nonatomic) NSUInteger currentLineSpacing;

@end
