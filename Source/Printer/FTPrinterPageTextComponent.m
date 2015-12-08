//
//  FTPrinterPageTextComponent.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 07/12/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinterPageTextComponent.h"
#import "NSString+FTWordWrap.h"

@implementation FTPrinterPageTextComponent

#pragma mark - Public Interface

+ (instancetype)pageTextComponentWithWidth:(NSUInteger)width text:(NSString *)text characterFont:(FTPrinterCharacterFont)characterFont scale:(NSUInteger)scale alignment:(FTPrinterAlignment)alignment {
    FTPrinterPageTextComponent *pageTextComponent = [FTPrinterPageTextComponent new];
    pageTextComponent.width = width;
    pageTextComponent.text = text;
    pageTextComponent.characterFont = characterFont;
    pageTextComponent.scale = scale;
    pageTextComponent.alignment = alignment;
    return pageTextComponent;
}

+ (instancetype)pageTextComponentWithText:(NSString *)text characterFont:(FTPrinterCharacterFont)characterFont scale:(NSUInteger)scale alignment:(FTPrinterAlignment)alignment {
    return [self pageTextComponentWithWidth:FTPrinterFullPageWidth text:text characterFont:characterFont scale:scale alignment:alignment];
}

#pragma mark - FTPrinterPageComponent

- (NSUInteger)height {
    double numberOfLines = [[self linesWordWrappedAccordingToWidth] count];
    double lineSpacing = [self lineHeightForCharacterFont:self.characterFont withVerticalCharacterScale:self.scale];
    return numberOfLines * lineSpacing - [self spaceBetweenLinesForCharacterFont:self.characterFont withScale:self.scale];
}

- (NSData *)commandDataWithStartingPoint:(FTPrinterPagePoint)startingPoint {
    NSMutableData *commandData = [NSMutableData data];
    NSUInteger lineSpacing = [self lineHeightForCharacterFont:self.characterFont withVerticalCharacterScale:self.scale];
    [commandData appendData:[FTPrinter commandDataForPrintAreaSetInPageModeWithX:startingPoint.x y:startingPoint.y width:self.width height:self.height]];
    [commandData appendData:[FTPrinter commandDataForSelectCharacterFont:self.characterFont]];
    [commandData appendData:[FTPrinter commandDataForLineSpacingSet:lineSpacing]];
    [commandData appendData:[FTPrinter commandDataForSpecifyCharacterScaleVertically:self.scale horizontally:self.scale]];
    NSArray *lines = [self linesWordWrappedAccordingToWidth];
    NSUInteger verticalPosition = 0;
    for (NSString *line in lines) {
        if (line == lines.firstObject) {
            verticalPosition += [self heightForCharacterFont:self.characterFont withScale:self.scale];
        } else {
            verticalPosition += lineSpacing;
        }
        NSUInteger horizontalPosition = 0;
        if (self.alignment == FTPrinterAlignmentCenter) {
            NSUInteger widthOfCharacters = line.length * [self widthForCharacterFont:self.characterFont withScale:self.scale];
            horizontalPosition = (self.width - widthOfCharacters) / 2;
        } else if (self.alignment == FTPrinterAlignmentRight) {
            NSUInteger widthOfCharacters = line.length * [self widthForCharacterFont:self.characterFont withScale:self.scale];
            horizontalPosition = self.width - widthOfCharacters;
            if (horizontalPosition > 0) {
                horizontalPosition--; // No idea why this is required, but it is probably due to the printer's conditional for line breaking.
            }
        }
        [commandData appendData:[FTPrinter commandDataForSpecifyVerticalAbsolutePositionInPageMode:verticalPosition]];
        [commandData appendData:[FTPrinter commandDataForSpecifyHorizontalAbsolutePosition:horizontalPosition]];
        [commandData appendData:[FTPrinter commandDataForPrintText:line]];
    }
    return commandData;
}

#pragma mark - Utility

- (NSArray *)linesWordWrappedAccordingToWidth {
    NSUInteger charactersPerLine = self.width / [self widthForCharacterFont:self.characterFont];
    return [self.text linesByWordWrappingToMaxCharactersPerLine:charactersPerLine];
}

- (NSUInteger)lineHeightForCharacterFont:(FTPrinterCharacterFont)characterFont withVerticalCharacterScale:(NSUInteger)vcs {
    return [self heightForCharacterFont:characterFont withScale:vcs] + [self spaceBetweenLinesForCharacterFont:characterFont withScale:vcs];
}

- (NSUInteger)spaceBetweenLinesForCharacterFont:(FTPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    NSUInteger scaledCharacterHeight = [self heightForCharacterFont:characterFont withScale:scale];
    return ceil(scaledCharacterHeight * FTPrinterSpaceBetweenLinesFraction);
}

- (NSUInteger)heightForCharacterFont:(FTPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    return [self heightForCharacterFont:characterFont] * scale;
}

- (NSUInteger)heightForCharacterFont:(FTPrinterCharacterFont)characterFont {
    switch (characterFont) {
        case FTPrinterCharacterFont24x12: return 24; break;
        case FTPrinterCharacterFont16x8: return 16; break;
    }
}

- (NSUInteger)widthForCharacterFont:(FTPrinterCharacterFont)characterFont withScale:(NSUInteger)scale {
    return [self widthForCharacterFont:characterFont] * scale;
}

- (NSUInteger)widthForCharacterFont:(FTPrinterCharacterFont)characterFont {
    switch (characterFont) {
        case FTPrinterCharacterFont24x12: return 12; break;
        case FTPrinterCharacterFont16x8: return 8; break;
    }
}

@end
