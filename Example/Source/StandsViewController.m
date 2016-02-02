//
//  StandsViewController.m
//  ZeebaExample
//
//  Created by Rasmus Taulborg Hummelmose on 26/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "StandsViewController.h"
#import <Zeeba/Zeeba.h>
#import <Masonry/Masonry.h>
#import "ConnectedStandViewController.h"

static NSUInteger const StandsTableViewNumberOfSections = 2;
static NSString * const StandsTableViewCellReuseIdentifier = @"StandsTableViewCellReuseIdentifier";

typedef NS_ENUM(NSUInteger, StandsTableViewSections) {
    StandsTableViewSectionsConnectedStands,
    StandsTableViewSectionsDiscoveredStands
};

@interface StandsViewController () <UITableViewDataSource, UITableViewDelegate, ZBBLEAvailabilityObserver, ZBConnectivityObserver>

@property (strong, nonatomic) ZBZeeba *zeeba;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *discoveries;
@property (strong, nonatomic) NSMutableArray *connections;
@property (strong, nonatomic) NSTimer *delayTimer;
@property (assign, nonatomic) BOOL shouldDiscover;

@end

@implementation StandsViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.title = NSLocalizedString(@"Stands", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.zeeba addAvailabilityObserver:self];
    [self.zeeba addConnectivityObserver:self];
    NSString *zeebaSDKKey = @"15944859-AC69-4BC3-BD1E-EFE0E9C47895"; // Replace this with your key!
    if (!zeebaSDKKey) {
        [NSException raise:@"ZeebaSDKKeyNotSpecifiedException" format:@"Go specify your SDK key :)"];
    }
    [self.zeeba startWithZeebaSDKKey:zeebaSDKKey];
    [self prepareSubviews];
    [self addSubviews];
    [self applyConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [self discover];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self endDiscovery];
}

#pragma mark - User Interface

- (void)prepareSubviews {
    self.tableView = [UITableView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:StandsTableViewCellReuseIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)addSubviews {
    [self.view addSubview:self.tableView];
}

- (void)applyConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
}

#pragma mark - Internals

- (void)discover {
    self.shouldDiscover = YES;
    [self.zeeba discoverStandsWithTimeout:3 discovery:^(ZBStand * _Nonnull discoveredStand) {
        if (![self.discoveries containsObject:discoveredStand]) {
            [self.discoveries addObject:discoveredStand];
            [self.tableView reloadData];
        }
    } completion:^(NSArray<ZBStand *> * _Nullable discoveredStands, NSError * _Nullable error) {
        NSMutableArray *discoveriesToRemove = [NSMutableArray arrayWithCapacity:self.discoveries.count];
        for (ZBStand *discovery in self.discoveries) {
            if (![discoveredStands containsObject:discovery]) {
                [discoveriesToRemove addObject:discovery];
            }
        }
        [self.discoveries removeObjectsInArray:discoveriesToRemove];
        [self.tableView reloadData];
        if (self.shouldDiscover) {
            self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(discover) userInfo:nil repeats:NO];
        }
    }];
}

- (void)endDiscovery {
    self.shouldDiscover = NO;
    [self.delayTimer invalidate];
    [self.zeeba stopDiscovery];
}

#pragma mark - FTBLEAvailabilityObserver

- (void)zeeba:(ZBZeeba *)zeeba availabilityChanged:(ZBBLEAvailability)availability {
    NSLog(@"Availability: %@", [ZBBLEAvailabilityTools descriptionForAvailability:availability]);
}

#pragma mark - FTConnectivityObserver

- (void)zeeba:(ZBZeeba *)zeeba disconnectedStand:(ZBStand *)stand {
    [self.connections removeObject:stand];
    [self.tableView reloadData];
    if (self.navigationController.viewControllers.lastObject != self) {
        [self.navigationController popToViewController:self animated:YES];
    }
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return StandsTableViewNumberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StandsTableViewCellReuseIdentifier forIndexPath:indexPath];
    ZBStand *stand;
    switch (indexPath.section) {
        case StandsTableViewSectionsDiscoveredStands: stand = self.discoveries[indexPath.row]; break;
        case StandsTableViewSectionsConnectedStands: stand = self.connections[indexPath.row]; break;
    }
    cell.textLabel.text = stand.identifier.UUIDString;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    switch (section) {
        case StandsTableViewSectionsDiscoveredStands: title = NSLocalizedString(@"Discovered", nil); break;
        case StandsTableViewSectionsConnectedStands: title = NSLocalizedString(@"Connected", nil); break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger numberOfRowsInSection = 0;
    switch (section) {
        case StandsTableViewSectionsDiscoveredStands: numberOfRowsInSection = self.discoveries.count; break;
        case StandsTableViewSectionsConnectedStands: numberOfRowsInSection = self.connections.count; break;
    }
    return numberOfRowsInSection;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.allowsSelection = NO;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == StandsTableViewSectionsDiscoveredStands) {
        ZBStand *stand = self.discoveries[indexPath.row];
        if ([self.connections containsObject:stand]) {
            self.tableView.allowsSelection = YES;
            return;
        }
        [self.zeeba connectStand:stand timeout:10 completion:^(ZBStand * _Nonnull stand, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Failed connecting with error: %@", error);
            } else {
                [self.connections addObject:stand];
                [self.tableView reloadData];
            }
            self.tableView.allowsSelection = YES;
        }];
    } else if (indexPath.section == StandsTableViewSectionsConnectedStands) {
        ConnectedStandViewController *connectedStandViewController = [[ConnectedStandViewController alloc] initWithConnectedStand:self.connections[indexPath.row]];
        [self.navigationController pushViewController:connectedStandViewController animated:YES];
        self.tableView.allowsSelection = YES;
    }
}

#pragma mark - Accessors

- (ZBZeeba *)zeeba {
    if (!_zeeba) {
        _zeeba = [ZBZeeba sharedInstance];
    }
    return _zeeba;
}

- (NSMutableArray *)discoveries {
    if (!_discoveries) {
        _discoveries = [NSMutableArray array];
    }
    return _discoveries;
}

- (NSMutableArray *)connections {
    if (!_connections) {
        _connections = [NSMutableArray array];
    }
    return _connections;
}

@end
