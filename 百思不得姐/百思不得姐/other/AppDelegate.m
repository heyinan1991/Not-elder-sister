//
//  AppDelegate.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/9.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "AppDelegate.h"
#import "XCNTabBarController.h"
#import "XCNStatusBarViewController.h"
#import "XCNTabBarController.h"
@interface AppDelegate ()<UITabBarControllerDelegate>
/** 记录tabBarcontroller上一次选中的位置 */
@property(nonatomic, assign) NSInteger previousSelectedIndex;
@end

@implementation AppDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.previousSelectedIndex == tabBarController.selectedIndex) {
        // 发出一个通知:当重复点击tabBar上的一个按钮
        [[NSNotificationCenter defaultCenter] postNotificationName:XCNTabBarButtonRepeatClickNotfication object:nil];
    }
    // 记录当前选中的索引
    self.previousSelectedIndex = tabBarController.selectedIndex;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 设置窗口的根控制器
    XCNTabBarController *tv = [[XCNTabBarController alloc]init];
    tv.view.backgroundColor = [UIColor redColor];
    // 设置窗口的跟控制器
    tv.delegate = self;
    self.window.rootViewController = tv;
    // 显示
    [self.window makeKeyAndVisible];
    // 添加状态栏的遮盖控制器
    [XCNStatusBarViewController show];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
