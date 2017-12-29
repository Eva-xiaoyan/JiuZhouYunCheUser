//
//  AppDelegate.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+UMSocial.h"
#import "JZTabBarController.h"
#import "JZRegisterViewController.h"
#import "JZGuidePageViewController.h"
#import "JZNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupUMSocial];
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if ([userDefaults objectForKey:@"username"]) {
        // 设置根控制器
//        self.window.rootViewController = [[JZTabBarController alloc] init];
//    }else if (![userDefaults boolForKey:@"notFirst"]){
//        // 如果是第一次进入引导页
//        self.window.rootViewController = [[JZGuidePageViewController alloc] init];
//    }else{
//        // 设置根控制器
        JZNavigationController *nav = [[JZNavigationController alloc]initWithRootViewController:[[JZRegisterViewController alloc] init]];
        self.window.rootViewController = nav;
//    }
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
