//
//  NSString+FTWordWrap.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 08/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "NSString+FTWordWrap.h"

@implementation NSString (FTWordWrap)

#pragma mark - Public Interface

- (NSArray<NSString *> *)linesByWordWrappingToMaxCharactersPerLine:(NSUInteger)mcpl {
    NSRegularExpression *wordLengthRegExp = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@".{1,%lu}", (unsigned long)mcpl] options:0 error:nil];
    NSArray *inputLines = [self componentsSeparatedByString:@"\n"];
    NSMutableArray *lines = [NSMutableArray array]; // output
    for (NSString *line in inputLines) {
        if (line.length <= mcpl) {
            [lines addObject:line];
        } else { // line too long
            NSArray *words = [line componentsSeparatedByString:@" "]; // split into words
            NSMutableString *cutLine = [NSMutableString string]; // current cut line
            for (NSString *word in words) {
                if (word.length > mcpl) { // word too long for a line
                    [lines addObject:cutLine];
                    cutLine = [NSMutableString string];
                    NSArray *matches = [wordLengthRegExp matchesInString:word options:0 range:NSMakeRange(0,[word length])];
                    for (NSTextCheckingResult *match in matches) {
                        [lines addObject:[word substringWithRange:match.range]];
                    }
                } else if ((cutLine.length && cutLine.length + word.length + 1 <= mcpl) || (!cutLine.length && word.length <= mcpl)) { // word fits into this line (with or without space)
                    if (cutLine.length) {
                        [cutLine appendString:@" "];
                    }
                    [cutLine appendString:word];
                } else { // word must be in next line
                    [lines addObject:cutLine];
                    cutLine = [NSMutableString string];
                    [cutLine appendString:word];
                }
            }
            if (cutLine.length) {
                [lines addObject:cutLine]; // add final words of line
            }
        }
    }
    // 'lines' is now an array of strings with the specified length
    return lines;
}

@end
