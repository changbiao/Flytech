//
//  FTPrinter.h
//  Flytech
//
//  Created by Rasmus Taulborg Hummelmose on 30/10/15.
//  Copyright © 2015 Glastonia Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FTPrintCompletionHandler)(NSError *error);

@interface FTPrinter : NSObject

- (void)printTestMaterialWithCompletion:(FTPrintCompletionHandler)completionHandler;

@end
