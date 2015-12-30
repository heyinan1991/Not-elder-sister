//
//  XCNNavigationController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNNavigationController.h"

@interface XCNNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation XCNNavigationController
/**
 *  第一次使用该类或者他的子类的时候调用,当类初始化的时候调用
 */
//+ (void)initialize
//{
//    if (self == [XCNNavigationController class]) {
//        // 获取当前导航控制器下所有导航条
//        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
//        dict[NSFontAttributeName] = [UIFont systemFontOfSize:30];
//        [bar setTitleTextAttributes:dict];
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 禁用系统的手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 添加自己的手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}
#pragma mark 判断什么时候能用自定义的手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 
    return self.childViewControllers.count >1;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断当前控制器是否跟控制器
    if (self.childViewControllers.count >0) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 添加左边的按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button sizeToFit];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
@end
