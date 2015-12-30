//
//  XCNStatusBarViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/26.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNStatusBarViewController.h"

@interface XCNStatusBarViewController ()<NSCopying>

@end

@implementation XCNStatusBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
static UIWindow *window_;
+ (void)show
{
    // 创建window
    window_ = [[UIWindow alloc]init];
    // 设置窗口的view的颜色
    window_.backgroundColor = [UIColor clearColor];
    // 设置window的frame为应用程序的状态栏的frame;
    window_.frame = [UIApplication sharedApplication].statusBarFrame;
    window_.hidden = NO;
    // 设置window的优先级
    window_.windowLevel = UIWindowLevelAlert;
    // 设置window的跟控制器
    XCNStatusBarViewController *vc = [[XCNStatusBarViewController alloc]init];
    window_.rootViewController = vc;
}
#pragma mark - 单利对象
static id statusBarVC_;
+ (instancetype)shareStatusBarVC
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statusBarVC_ = [[self alloc]init];
    });
    return statusBarVC_;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statusBarVC_ = [super allocWithZone:zone];
    });
    return statusBarVC_;
}

- (id)copyWithZone:(NSZone *)zone
{
    return statusBarVC_;
}

#pragma mark - 控制状态栏
/**
 *  设置状态栏的显示隐藏
 */
- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    _statusBarHidden = statusBarHidden;
    // 刷新状态栏(内部胡调用preferredStatusBarStyle和prefersStatusBarHidden两个方法,重新设置状态栏)
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle;
    // 刷新状态栏(内部胡调用preferredStatusBarStyle和prefersStatusBarHidden两个方法,重新设置状态栏)
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - 状态栏点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取程序主窗口的所有子控件
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewWith:window];
}


- (void)searchScrollViewWith:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        [self searchScrollViewWith:subView];
    }
    // 如果是scrollView,就设置点击状态栏回弹
//    XCNLog(@"%@",view);
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        // 判断当期界面和程序主窗口有没有在有重合的部分
        // 首先算出主窗口的rect
        CGRect windowRect = scrollView.window.bounds;
        // 转换scrollView的坐标系
        // nil 就代表程序主窗口
        CGRect scrollRect = [scrollView convertRect:scrollView.bounds toView:nil];
        // 正式判断有没有重合
        // 没有重合就返回,不会弹
        if (!CGRectIntersectsRect(windowRect, scrollRect))return;
        
        // 滚动到最前面
        CGPoint offset = scrollView.contentOffset;
        offset.y = -scrollView.contentInset.top;
        // 设置scrollView的偏移量
        [scrollView setContentOffset:offset animated:YES];
    }
}

@end
