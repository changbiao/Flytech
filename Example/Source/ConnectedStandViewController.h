//
//  ConnectedStandViewController.h
//  ZeebaExample
//
//  Created by Rasmus Taulborg Hummelmose on 11/11/2015.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBStand;

@interface ConnectedStandViewController : UIViewController

- (instancetype)initWithConnectedStand:(ZBStand *)stand;

@end
