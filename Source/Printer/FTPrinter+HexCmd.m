//
//  FTPrinter+HexCmd.m
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 11/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "FTPrinter+HexCmd.h"

NSString * const FTPrinterHexCmdLineFeed = @"0A";
NSString * const FTPrinterHexCmdPrintReturningToStandardModeOrMarkedPaperPrintFormFeeding = @"0C";
NSString * const FTPrinterHexCmdCarriageReturn = @"0D";
NSString * const FTPrinterHexCmdQRCodeDataMatrixModuleSizeSet = @"123B";
NSString * const FTPrinterHexCmdEnableAutoCutter = @"1277010C0100";
NSString * const FTPrinterHexCmdPrintDataCancelInPageMode = @"18";
NSString * const FTPrinterHexCmdPageModeDataPrint= @"1B0C";
NSString * const FTPrinterHexCmdPrintModeSelect = @"1B21";
NSString * const FTPrinterHexCmdUnderlineSettings = @"1B2D";
NSString * const FTPrinterHexCmdLineSpacingSet = @"1B33";
NSString * const FTPrinterHexCmdPeripheralEquipmentSelection = @"1B3D";
NSString * const FTPrinterHexCmdPrinterInitialize = @"1B40";
NSString * const FTPrinterHexCmdHorizontalTabPositionSet = @"1B44";
NSString * const FTPrinterHexCmdHRICharacterPrintPositionSelection = @"1D48";
NSString * const FTPrinterHexCmdPrintAndFeedForward = @"1B4A";
NSString * const FTPrinterHexCmdPageModeSelect = @"1B4C";
NSString * const FTPrinterHexCmdCharacterFontSelect = @"1B4D";
NSString * const FTPrinterHexCmdCharacterRightRotate = @"1B56";
NSString * const FTPrinterHexCmdPrintAreaSetInPageMode = @"1B57";
NSString * const FTPrinterHexCmdRelativePositionSpecify = @"1B5C";
NSString * const FTPrinterHexCmdAlignment = @"1B61";
NSString * const FTPrinterHexCmdFlipPrinting = @"1B7B";
NSString * const FTPrinterHexCmdNVBitImageDefine = @"1C71";
NSString * const FTPrinterHexCmdCharacterSizeSpecify = @"1D21";
NSString * const FTPrinterHexCmdReversePrint = @"1D42";
NSString * const FTPrinterHexCmdPaperCut = @"1D56";
NSString * const FTPrinterHexCmdPrintAndNLinesFeedForward = @"1B64";
NSString * const FTPrinterHexCmdPrintAreaWidthSet = @"1D57";
NSString * const FTPrinterHexCmdHRICharacterTypefaceSelection = @"1D66";
NSString * const FTPrinterHexCmdBarcodeHeightSet = @"1D68";
NSString * const FTPrinterHexCmdBarcodePrint = @"1D6B";
NSString * const FTPrinterHexCmdQRCodePrint = @"1D7001";
NSString * const FTPrinterHexCmdBarcodeHorizontalSizeSet = @"1D77";
NSString * const FTPrinterHexCmdTestPrint = @"1274";
NSString * const FTPrinterHexCmdNVBitImagePrint = @"1C70";
NSString * const FTPrinterHexCmdRasterBitImagePrint = @"1D7630";
NSString * const FTPrinterHexCmdAbsolutePositionSpecify = @"1B24";
NSString * const FTPrinterHexCmdVerticalAbsolutePositionSpecifyInPageMode = @"1D24";
NSString * const FTPrinterHexCmdFunctionSettingsChange = @"126B";
NSString * const FTPrinterHexCmdFunctionSettingResponse = @"126C00";
NSString * const FTPrinterHexCmdExecutionResponseRequest = @"1271";
NSString * const FTPrinterHexCmdAutomaticStatusBackEnableDisable = @"1D61";
NSString * const FTPrinterHexCmd512ZeroBytes = @"00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000";
NSString * const FTPrinterHexCmdCharacterPrintDirectionSpecifyInPageMade = @"1B54";
NSString * const FTPrinterHexCmdInversionFlipPrintingSpecifyCancel = @"1B7B";
