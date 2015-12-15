//
//  ZBPrinter+HexCmd.m
//  Zeeba
//
//  Created by Rasmus Taulborg Hummelmose on 11/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ZBPrinter+HexCmd.h"

NSString * const ZBPrinterHexCmdLineFeed = @"0A";
NSString * const ZBPrinterHexCmdPrintReturningToStandardModeOrMarkedPaperPrintFormFeeding = @"0C";
NSString * const ZBPrinterHexCmdCarriageReturn = @"0D";
NSString * const ZBPrinterHexCmdQRCodeDataMatrixModuleSizeSet = @"123B";
NSString * const ZBPrinterHexCmdEnableAutoCutter = @"1277010C0100";
NSString * const ZBPrinterHexCmdPrintDataCancelInPageMode = @"18";
NSString * const ZBPrinterHexCmdPageModeDataPrint= @"1B0C";
NSString * const ZBPrinterHexCmdPrintModeSelect = @"1B21";
NSString * const ZBPrinterHexCmdUnderlineSettings = @"1B2D";
NSString * const ZBPrinterHexCmdLineSpacingSet = @"1B33";
NSString * const ZBPrinterHexCmdPeripheralEquipmentSelection = @"1B3D";
NSString * const ZBPrinterHexCmdPrinterInitialize = @"1B40";
NSString * const ZBPrinterHexCmdHorizontalTabPositionSet = @"1B44";
NSString * const ZBPrinterHexCmdHRICharacterPrintPositionSelection = @"1D48";
NSString * const ZBPrinterHexCmdPrintAndFeedForward = @"1B4A";
NSString * const ZBPrinterHexCmdPageModeSelect = @"1B4C";
NSString * const ZBPrinterHexCmdCharacterFontSelect = @"1B4D";
NSString * const ZBPrinterHexCmdCharacterRightRotate = @"1B56";
NSString * const ZBPrinterHexCmdPrintAreaSetInPageMode = @"1B57";
NSString * const ZBPrinterHexCmdRelativePositionSpecify = @"1B5C";
NSString * const ZBPrinterHexCmdAlignment = @"1B61";
NSString * const ZBPrinterHexCmdFlipPrinting = @"1B7B";
NSString * const ZBPrinterHexCmdNVBitImageDefine = @"1C71";
NSString * const ZBPrinterHexCmdCharacterSizeSpecify = @"1D21";
NSString * const ZBPrinterHexCmdReversePrint = @"1D42";
NSString * const ZBPrinterHexCmdPaperCut = @"1D56";
NSString * const ZBPrinterHexCmdPrintAndNLinesFeedForward = @"1B64";
NSString * const ZBPrinterHexCmdPrintAreaWidthSet = @"1D57";
NSString * const ZBPrinterHexCmdHRICharacterTypefaceSelection = @"1D66";
NSString * const ZBPrinterHexCmdBarcodeHeightSet = @"1D68";
NSString * const ZBPrinterHexCmdBarcodePrint = @"1D6B";
NSString * const ZBPrinterHexCmdQRCodePrint = @"1D7001";
NSString * const ZBPrinterHexCmdBarcodeHorizontalSizeSet = @"1D77";
NSString * const ZBPrinterHexCmdTestPrint = @"1274";
NSString * const ZBPrinterHexCmdNVBitImagePrint = @"1C70";
NSString * const ZBPrinterHexCmdRasterBitImagePrint = @"1D7630";
NSString * const ZBPrinterHexCmdAbsolutePositionSpecify = @"1B24";
NSString * const ZBPrinterHexCmdVerticalAbsolutePositionSpecifyInPageMode = @"1D24";
NSString * const ZBPrinterHexCmdFunctionSettingsChange = @"126B";
NSString * const ZBPrinterHexCmdFunctionSettingResponse = @"126C00";
NSString * const ZBPrinterHexCmdExecutionResponseRequest = @"1271";
NSString * const ZBPrinterHexCmdAutomaticStatusBackEnableDisable = @"1D61";
NSString * const ZBPrinterHexCmd512ZeroBytes = @"00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 \n"
                                                "00000000 00000000 00000000 00000000";
NSString * const ZBPrinterHexCmdCharacterPrintDirectionSpecifyInPageMade = @"1B54";
NSString * const ZBPrinterHexCmdInversionFlipPrintingSpecifyCancel = @"1B7B";
NSString * const ZBPrinterHexCmdMacroDefinitionStartStop = @"1D3A";
NSString * const ZBPrinterHexCmdMacroExecution = @"1D5E";
