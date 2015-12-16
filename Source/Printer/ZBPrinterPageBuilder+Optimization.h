//
//  ZBPrinterPageBuilder+Optimization.h
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 16/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Zeeba/Zeeba.h>

@interface ZBPrinterPageBuilder (Optimization)

@property (assign, nonatomic) ZBPrinterCharacterFont currentCharacterFont;
@property (assign, nonatomic) NSUInteger currentCharacterScale;
@property (assign, nonatomic) NSUInteger currentLineSpacing;

@end
