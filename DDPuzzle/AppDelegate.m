//
//  AppDelegate.m
//  Puzzle
//
//  Created by duodian on 2018/5/31.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "AppDelegate.h"
#import "EnterController.h"
#import "BaseNavController.h"
#import <SVProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:0.8];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] , NSForegroundColorAttributeName :[UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    EnterController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EnterController"];
    BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    return YES;
}

@end

