//
//  RunCalcAppDelegate.h
//  RunCalc
//
//  Created by Snow Leopard User on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConvertTableViewController.h"
#import "HRateTableViewController.h"
#import "DateTableViewController.h"

@interface RunCalcAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic) IBOutlet UIWindow *window;
@property (nonatomic) IBOutlet UITabBarController *tabBarController;
@property (nonatomic) IBOutlet ConvertTableViewController *convertTableViewController;
@property (nonatomic) IBOutlet HRateTableViewController *hRateTableViewController;
@property (nonatomic) IBOutlet DateTableViewController *dateTableViewController;
@end
