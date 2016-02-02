//
//  AppDelegate.m
//  ZeebaExample
//
//  Created by Rasmus Taulborg Hummelmose on 01/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "StandsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    StandsViewController *standsViewController = [StandsViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:standsViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
