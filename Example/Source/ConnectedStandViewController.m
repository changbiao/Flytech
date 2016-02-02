//
//  ConnectedStandViewController.m
//  ZeebaExample
//
//  Created by Rasmus Taulborg Hummelmose on 11/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "ConnectedStandViewController.h"
#import <Zeeba/Zeeba.h>
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, ActionTableViewCell) {
    ActionTableViewCellPrint = 0,
    ActionTableViewCellDock = 1,
    ActionTableViewCellUndock = 2
};

static NSString * const ActionTableViewCellReuseIdentifier = @"ActionTableViewCellReuseIdentifier";

@interface ConnectedStandViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ZBStand *stand;
@property (strong, nonatomic) UITableView *actionsTableView;
@property (strong, nonatomic) UITextView *logTextView;

@end

@implementation ConnectedStandViewController

#pragma mark - Life Cycle

- (instancetype)initWithConnectedStand:(ZBStand *)stand {
    self = [super init];
    if (self) {
        self.stand = stand;
    }
    return self;
}

- (void)viewDidLoad {
    [self prepareSubviews];
    [self addSubviews];
    [self applyTheming];
    [self applyConstraints];
}

#pragma mark - User Interface

- (void)prepareSubviews {
    self.actionsTableView = [UITableView new];
    [self.actionsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ActionTableViewCellReuseIdentifier];
    self.actionsTableView.rowHeight = 50;
    self.actionsTableView.delegate = self;
    self.actionsTableView.dataSource = self;
    self.logTextView = [UITextView new];
}

- (void)addSubviews {
    [self.view addSubview:self.actionsTableView];
    [self.view addSubview:self.logTextView];
}

- (void)applyTheming {
    self.logTextView.backgroundColor = [UIColor lightGrayColor];
}

- (void)applyConstraints {
    [self.actionsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.logTextView.mas_top);
    }];
    [self.logTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionsTableView.mas_bottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        make.leading.trailing.height.equalTo(self.actionsTableView);
    }];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ActionTableViewCellReuseIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case ActionTableViewCellPrint: cell.textLabel.text = @"Print"; break;
        case ActionTableViewCellUndock: cell.textLabel.text = @"Undock"; break;
        case ActionTableViewCellDock: cell.textLabel.text = @"Dock"; break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.actionsTableView.allowsSelection = NO;
    id completionBlock = ^{
        self.actionsTableView.allowsSelection = YES;
        [self.actionsTableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    switch (indexPath.row) {
        case ActionTableViewCellPrint: [self printWithCompletion:completionBlock]; break;
        case ActionTableViewCellUndock: [self setTabledLock:NO completion:completionBlock]; break;
        case ActionTableViewCellDock: [self setTabledLock:YES completion:completionBlock]; break;
    }
}

#pragma mark - Internals

- (void)printWithCompletion:(void(^)())completion {
    [self.stand.printer printWithPageBuilder:^(ZBPrinterPageBuilder *pageBuilder) {
        pageBuilder.verticalPageComponentPadding = 25;
        [pageBuilder addPageComponentWithText:@"Zeeba Example" font:ZBPrinterCharacterFont16x8 scale:3 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"Zeeba Street 1\nLondon" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addPageComponentWithText:@"You were served by Mr. Zeeba" font:ZBPrinterCharacterFont16x8 scale:1 alignment:ZBPrinterAlignmentCenter];
        [pageBuilder addHorizontalLinePageComponent];
        for (NSUInteger index = 0; index < 2; index++) {
            ZBPrinterPageTextComponent *quantityTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"1" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
            ZBPrinterPageTextComponent *nameTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Zeeba Product" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
            ZBPrinterPageTextComponent *priceTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"10.00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
            NSArray *lineItemColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 10.0 textComponent:quantityTextComponent],
                                          [ZBPrinterPageColumn pageColumnWithWidthFraction:6 / 10.0 textComponent:nameTextComponent],
                                          [ZBPrinterPageColumn pageColumnWithWidthFraction:3 / 10.0 textComponent:priceTextComponent] ];
            [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:lineItemColumns horizontalPadding:20]];
        }
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *subtotalTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Subtotal" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
        ZBPrinterPageTextComponent *subtotalValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"16.67" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *subtotalColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:subtotalTitleTextComponent],
                                      [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:subtotalValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:subtotalColumns horizontalPadding:20]];
        ZBPrinterPageTextComponent *taxTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"VAT" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
        ZBPrinterPageTextComponent *taxValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"3.33" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *taxColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:taxTitleTextComponent],
                                 [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:taxValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:taxColumns horizontalPadding:20]];
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *totalTitleTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Total" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
        ZBPrinterPageTextComponent *totalValueTextComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"20.00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *totalColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:totalTitleTextComponent],
                                   [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:totalValueTextComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:totalColumns horizontalPadding:20]];
        [pageBuilder addHorizontalLinePageComponent];
        ZBPrinterPageTextComponent *cashTransactionTitleComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"Cash" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentLeft];
        ZBPrinterPageTextComponent *cashTransactionValueComponent = [ZBPrinterPageTextComponent pageTextComponentWithText:@"20.00" characterFont:ZBPrinterCharacterFont24x12 scale:1 alignment:ZBPrinterAlignmentRight];
        NSArray *cashTransactionColumns = @[ [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cashTransactionTitleComponent],
                                             [ZBPrinterPageColumn pageColumnWithWidthFraction:1 / 2.0 textComponent:cashTransactionValueComponent] ];
        [pageBuilder addPageComponent:[ZBPrinterPageColumnsComponent pageColumnsComponentWithWidth:ZBPrinterFullPageWidth columns:cashTransactionColumns horizontalPadding:20]];
    } completion:^(NSError *error) {
        completion();
    }];
}

- (void)setTabledLock:(BOOL)lock completion:(void(^)())completion {
    [self.stand setTabletLock:lock completion:^(NSError * _Nullable error) {
        completion();
    }];
}

@end
