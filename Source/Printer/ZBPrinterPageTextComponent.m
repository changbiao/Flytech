//
//  ZBPrinterPageTextComponent.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinterPageTextComponent.h"
#import "NSString+ZBWordWrap.h"
#import "ZBPrinterPageBuilder.h"

@implementation ZBPrinterPageTextComponent

#pragma mark - Public Interface

+ (instancetype)pageTextComponentWithWidth:(NSUInteger)width text:(NSString *)text characterFont:(ZBPrinterCharacterFont)characterFont scale:(NSUInteger)scale alignment:(ZBPrinterAlignment)alignment {
    ZBPrinterPageTextComponent *pageTextComponent = [ZBPrinterPageTextComponent new];
    pageTextComponent.width = width;
    pageTextComponent.text = text;
    pageTextComponent.characterFont = characterFont;
    pageTextComponent.scale = scale;
    pageTextComponent.alignment = alignment;
    return pageTextComponent;
}

+ (instancetype)pageTextComponentWithText:(NSString *)text characterFont:(ZBPrinterCharacterFont)characterFont scale:(NSUInteger)scale alignment:(ZBPrinterAlignment)alignment {
    return [self pageTextComponentWithWidth:ZBPrinterFullPageWidth text:text characterFont:characterFont scale:scale alignment:alignment];
}

#pragma mark - ZBPrinterPageComponent

- (NSUInteger)height {
    double numberOfLines = [[self linesWordWrappedAccordingToWidth] count];
    double lineSpacing = [self lineHeightForCharacterFont:self.characterFont withVerticalCharacterScale:self.scale];
    return numberOfLines * lineSpacing - [self spaceBetweenLinesForCharacterFont:self.characterFont withScale:self.scale];
}

- (NSData *)commandDataWithStartingPoint:(ZBPrinterPagePoint)startingPoint pageBuilder:(ZBPrinterPageBuilder *)pageBuilder {
    NSMutableData *commandData = [NSMutableData data];
    [commandData appendData:[ZBPrinter commandDataForPrintAreaSetInPageModeWithX:startingPoint.x y:startingPoint.y width:self.width height:self.height]];
    if (self.characterFont != pageBuilder.currentCharacterFont) {
        pageBuilder.currentCharacterFont = self.characterFont;
        [commandData appendData:[ZBPrinter commandDataForSelectCharacterFont:self.characterFont]];
    }
    NSUInteger lineSpacing = [self lineHeightForCharacterFont:self.characterFont withVerticalCharacterScale:self.scale];
    if (lineSpacing != pageBuilder.currentLineSpacing) {
        pageBuilder.currentLineSpacing = lineSpacing;
        [commandData appendData:[ZBPrinter commandDataForLineSpacingSet:lineSpacing]];
    }
    if (self.scale != pageBuilder.currenctCharacterScale) {
        pageBuilder.currenctCharacterScale = self.scale;
        [commandData appendData:[ZBPrinter commandDataForSpecifyCharacterScaleVertically:self.scale horizontally:self.scale]];
    }
    NSArray *lines = [self linesWordWrappedAccordingToWidth];
    NSUInteger verticalPosition = [self heightForCharacterFont:self.characterFont withScale:self.scale];
    NSUInteger horizontalPosition = 0;
    if (self.alignment == ZBPrinterAlignmentLeZB) {
        [commandData appendData:[ZBPrinter commandDataForSpecifyVerticalAbsolutePositionInPageMode:verticalPosition]];
        [commandData appendData:[ZBPrinter commandDataForSpecifyHorizontalAbsolutePosition:horizontalPosition]];
        NSString *linesInText = [lines componentsJoinedByString:@"\n"];
        [commandData appendData:[self commandDataForPrintingText:linesInText]];
    } else {
        for (NSString *line in lines) {
            if (line != lines.firstObject) {
                verticalPosition += lineSpacing;
            }
            if (self.alignment == ZBPrinterAlignmentCenter) {
                NSUInteger widthOfCharacters = line.length * [self widthForCharacterFont:self.characterFont withScale:self.scale];
                horizontalPosition = (self.width - widthOfCharacters) / 2;
            } else if (self.alignment == ZBPrinterAlignmentRight) {
                NSUInteger widthOfCharacters = line.length * [self widthForCharacterFont:self.characterFont withScale:self.scale];
                horizontalPosition = self.width - widthOfCharacters;
                if (horizontalPosition > 0) {
                    horizontalPosition--; // No idea why this is required, but it is probably due to the printer's conditional for line breaking.
                }
            }
            [commandData appendData:[ZBPrinter commandDataForSpecifyVerticalAbsolutePositionInPageMode:verticalPosition]];
            [commandData appendData:[ZBPrinter commandDataForSpecifyHorizontalAbsolutePosition:horizontalPosition]];
            [commandData appendData:[self commandDataForPrintingText:line]];
        }
    }
    return commandData;
}

#pragma mark - Utility

- (NSData *)commandDataForPrintingText:(NSString *)text {
    NSMutableData *commandData = [NSMutableData data];
    NSScanner *scanner = [NSScanner scannerWithString:text];
    NSCharacterSet *underscoreCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"_"];
    NSString *underscores;
    NSString *notUnderscores;
    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:underscoreCharacterSet intoString:&underscores]) {
            if (underscores.length > 4) {
                [commandData appendData:[ZBPrinter commandDataForMacroExecutionWithExecutionCount:underscores.length inBetweenDelayIn100ms:0]];
            } else {
                [commandData appendData:[ZBPrinter commandDataForPrintText:underscores]];
            }
        } else if ([scanner scanUpToCharactersFromSet:underscoreCharacterSet intoString:&notUnderscores]) {
            [commandData appendData:[ZBPrinter commandDataForPrintText:notUnderscores]];
        }
    }
    return commandData;
}

- (NSArray *)linesWordWrappedAccordingToWidth {
    NSUInteger charactersPerLine = self.width / [self widthForCharacterFont:self.characterFont];
    return [self.text linesByWordWrappingToMaxCharactersPerLine:charactersPerLine];
}

- (NSUInteger)lineHeightForCharacterFont:(ZBPrinterCharacterFont)characterFont withVerticalCharacterScale:(NSUInteger)vcs {
    return [self heightForCharacterFont:characterFont withScale:vcs] + [self spaceBetweenLinesForCharacterFont:characterFont withScale:vcs];
}

- (NSUInteger)spaceBetweenLinesForCharacterFont:(ZBPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    NSUInteger scaledCharacterHeight = [self heightForCharacterFont:characterFont withScale:scale];
    return ceil(scaledCharacterHeight * ZBPrinterSpaceBetweenLinesFraction);
}

- (NSUInteger)heightForCharacterFont:(ZBPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    return [self heightForCharacterFont:characterFont] * scale;
}

- (NSUInteger)heightForCharacterFont:(ZBPrinterCharacterFont)characterFont {
    switch (characterFont) {
        case ZBPrinterCharacterFont24x12: return 24; break;
        case ZBPrinterCharacterFont16x8: return 16; break;
    }
}

- (NSUInteger)widthForCharacterFont:(ZBPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    return [self widthForCharacterFont:characterFont] * scale;
}

- (NSUInteger)widthForCharacterFont:(ZBPrinterCharacterFont)characterFont {
    switch (characterFont) {
        case ZBPrinterCharacterFont24x12: return 12; break;
        case ZBPrinterCharacterFont16x8: return 8; break;
    }
}

@end
