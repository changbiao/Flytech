//
//  AppDelegate.h
//  ZeebaExample
//
//  Created by Rasmus Taulborg Hummelmose on 01/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

void appLog(NSString *prefix, const char *file, int lineNumber, const char *functionName, NSString *format, ...);

@end
