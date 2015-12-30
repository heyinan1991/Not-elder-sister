//
//  XCNEssenceViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/9.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNEssenceViewController.h"
#import "XCNRecommendTagController.h"
#import "XCNAllViewController.h"
#import "XCNVideoViewController.h"
#import "XCNVioceViewController.h"
#import "XCNPictureViewController.h"
#import "XCNWordViewController.h"
@interface XCNEssenceViewController ()<UIScrollViewDelegate>
/**
 * 选中的按钮
 */
@property(nonatomic, weak) UIButton *selectBtn;
/**
 *  指示器
 */
@property(nonatomic, weak) UIView *titleIndicatorView;

@property(nonatomic, weak) UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *titleButtons;

@end

@implementation XCNEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self setupChildViewController];
    // 设置导航条
    [self setupNav];

    // 添加scrollview
    [self setupScrollView];
    
    // 添加标题栏
    [self setupTitlesView];
    
    // 根据scrollView的偏移量添加子控制器的view
    [self addChildViewControllerView];
}
#pragma mark -懒加载
- (NSMutableArray *)titleButtons
{
    if (_titleButtons== nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

#pragma mark -添加子控件
/**
 *  添加子控制器
 */
- (void)setupChildViewController
{
    // 全部
    XCNAllViewController *all = [[XCNAllViewController alloc]init];
    all.title = @"全部";
    [self addChildViewController:all];
    // 视频
    XCNVideoViewController *video = [[XCNVideoViewController alloc]init];
     video.title = @"视频";
    [self addChildViewController:video];
    //图片
    XCNPictureViewController *picture = [[XCNPictureViewController alloc]init];
     picture.title = @"图片";
    [self addChildViewController:picture];
    // 声音
    XCNVioceViewController *vioce = [[XCNVioceViewController alloc]init];
     vioce.title = @"声音";
    [self addChildViewController:vioce];
    
    // 文字
    XCNWordViewController *word = [[XCNWordViewController alloc]init];
     word.title = @"段子";
    [self addChildViewController:word];
}
/**
 *  添加标题栏
 */
- (void)setupTitlesView
{
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 64, self.view.width, 40);
    titleView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.view addSubview:titleView];
    // 添加按钮
    NSInteger count = self.childViewControllers.count;
    CGFloat buttonW = titleView.width/count;
    CGFloat buttonH = titleView.height;
//    NSArray *arr = @[@"全部",@"精华",@"图片",@"声音",@"段子"];
    for (int i = 0; i<count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake(i*buttonW, 0, buttonW, buttonH);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        // 文字颜色
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
        [self.titleButtons addObject:btn];
    }
    
    // 添加底部的指示器
    UIView *titleIndicatorView = [[UIView alloc]init];
    [titleView addSubview:titleIndicatorView];
    // 设置底部指示器的颜色
    UIButton *firstTitleButton = titleView.subviews.firstObject;
    titleIndicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    // 设置指示器的高,y值
    titleIndicatorView.height = 1;
    titleIndicatorView.bottom = titleView.height;
    self.titleIndicatorView = titleIndicatorView;
    
    // 默认选中第一个
    firstTitleButton.selected = YES;
    // 设置一定要设置,不然再点击下一个出问题
    self.selectBtn = firstTitleButton;
    // 不设置这一句,此时firstTitleButton.titleLabel的frame是空的
    [firstTitleButton.titleLabel sizeToFit];
//    XCNLog(@"%@",NSStringFromCGRect(firstTitleButton.titleLabel.frame));
    titleIndicatorView.width = firstTitleButton.titleLabel.width;
    titleIndicatorView.centerX = firstTitleButton.centerX;
    
}
/**
 *  添加scrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = XCNColor(206, 206, 206);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置contentsize
    self.scrollView.contentSize = CGSizeMake(self.childViewControllers.count*self.scrollView.width, 0);
}

#pragma mark - UIScrollViewDelegate
/**
 *  当在使用setContentOffset: animated:让scrollView进行了滚动动画,那么在停止时就会调用这个方法
 *
 *
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildViewControllerView];
}

/**
 *  缓冲结束调用
 *
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 根据当前偏移量计算当前在那个界面
    int index = scrollView.contentOffset.x / scrollView.width;
    UIButton *titleButton = self.titleButtons[index];
    // 让按钮点击状态
    [self dealingTitleButtonClick:titleButton];
    // 根据scrollView的偏移量添加子控制器的view
    [self addChildViewControllerView];
}

- (void)addChildViewControllerView
{
    // 根据当前偏移量计算当前在那个界面
    int index = self.scrollView.contentOffset.x / self.scrollView.width;
    // 添加对应的子控制器的View到scrollView上
    UIViewController *vc =self.childViewControllers[index];
    // 判断当前点击的view是否加载过了,加载过了就返回,防止重复加载
    if (vc.isViewLoaded) return;
    // 设置frame
    vc.view.frame = self.scrollView.bounds;

    // 添加view
    [self.scrollView addSubview:vc.view];
   
}

#pragma mark - 基本设置
- (void)setupNav
{
    self.view.backgroundColor = XCNColor(206, 206, 206);
    // 设置左边的标签
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" heightImage:@"MainTagSubIconClick" action:@selector(essenceClick) target:self];

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 监听点击事件

- (void)essenceClick {
    XCNFuc;
    XCNRecommendTagController *vc = [[XCNRecommendTagController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)titleButtonClick:(UIButton *)button
{
    
    // 按钮重复点击发出通知
    if (self.selectBtn == button) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XCNTitleButtonRepeatClickNotfication object:nil];
    }
    // 处理按钮
    [self dealingTitleButtonClick:button];
    
}
- (void)dealingTitleButtonClick:(UIButton *)button
{
    // 原来选中的按钮状态为NO
    self.selectBtn.selected = NO;
    // 现在选中的按钮状态为YES
    button.selected = YES;
    // 现在选中的按钮赋值给记录已经选中按钮
    self.selectBtn = button;
    
    // 底部指示器的宽度,和中心点-->指示器移动
    [UIView animateWithDuration:0.25 animations:^{
        self.titleIndicatorView.centerX = button.centerX;
        self.titleIndicatorView.width = button.titleLabel.width;
    }];
    
    // 设置scrollView的偏移量
    CGPoint offSet = self.scrollView.contentOffset;
    offSet.x = button.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offSet animated:YES];
}
@end
