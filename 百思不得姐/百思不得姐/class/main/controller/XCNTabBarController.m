//
//  XCNTabBarController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/9.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNTabBarController.h"
#import "XCNEssenceViewController.h"
#import "XCNMeViewController.h"
#import "XCNNewViewController.h"
#import "XCNFriendTrendsViewController.h"
#import "XCNTabBar.h"
#import "XCNNavigationController.h"
@interface XCNTabBarController ()

@end

@implementation XCNTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加所有的子控制器
    [self setUpAllChildViewController];
    
    // 设置所有item属性的字的颜色和字体大小
    [self setUpAllItem];
    // 处理tabBar
    [self setUpTabBar];
    
}
#pragma mark - 处理tabBar
- (void)setUpTabBar
{
    [self setValue:[[XCNTabBar alloc]init] forKeyPath:@"tabBar"];
}

#pragma mark - 设置TabBarItem文字属性
- (void)setUpAllItem
{
    // 正常状态下的设置
    NSMutableDictionary *norDict = [NSMutableDictionary dictionary];
    norDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    NSMutableDictionary *selDict = [NSMutableDictionary dictionary];
    selDict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    selDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    // 获取当前所有的UItabberItem
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:norDict forState:UIControlStateNormal];
    [item setTitleTextAttributes:selDict forState:UIControlStateSelected];
}

#pragma mark -设置所有的子控制器
- (void)setUpAllChildViewController
{
    // 精华
    [self setUpOneChildVc:[[XCNEssenceViewController alloc]init] image:@"tabBar_essence_icon" selectImage:@"tabBar_essence_click_icon" title:@"精华"];
    // 我
    [self setUpOneChildVc:[[XCNMeViewController alloc]initWithStyle:UITableViewStyleGrouped] image:@"tabBar_me_icon" selectImage:@"tabBar_me_click_icon" title:@"我"];
    
    // 新帖
    [self setUpOneChildVc:[[XCNNewViewController alloc]init] image:@"tabBar_new_icon" selectImage:@"tabBar_new_click_icon" title:@"新帖"];
    
    // 关注
    XCNFriendTrendsViewController *friendVc = [UIStoryboard storyboardWithName:@"XCNFriendTrendsViewController" bundle:nil].instantiateInitialViewController;
    [self setUpOneChildVc:friendVc image:@"tabBar_friendTrends_icon" selectImage:@"tabBar_friendTrends_click_icon" title:@"关注"];
   
}

#pragma mark - 设置一个子控制器

- (void)setUpOneChildVc:(UIViewController *)vc image:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title
{
    // 添加手势
    
    // 添加导航控制器
    UINavigationController *nav = [[XCNNavigationController alloc]initWithRootViewController:vc];
    // 精华和关注模块标题是图片
    if ([vc isKindOfClass:[XCNNewViewController class]] || [vc isKindOfClass:[XCNEssenceViewController class]]) {
        vc.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    }
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    [self addChildViewController:nav];
}

@end
