//
//  XCNTabBar.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/9.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNTabBar.h"
#import "XCNPublishViewController.h"
@interface XCNTabBar ()
/**
 加号按钮
 */
@property(nonatomic, weak) UIButton *publish;

@end

@implementation XCNTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        // 添加加号按钮
        UIButton *publish = [UIButton buttonWithType:UIButtonTypeCustom];
        [publish setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publish setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
        [publish sizeToFit];
        [publish addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        self.publish = publish;
        [self addSubview:publish];
    }
    return self;
}

- (void)publishClick
{
    XCNPublishViewController *publish = [[XCNPublishViewController alloc]init];
    [self.window.rootViewController presentViewController:publish animated:NO completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置加号按钮的中心位置
    self.publish.center = CGPointMake(self.width*0.5, self.height*0.5);
    // frame的计算
    CGFloat w = self.width/5;
    CGFloat h = self.height;
    CGFloat y = 0;
    CGFloat x = 0;
    
    // 遍历子控件
    NSInteger index = 0;
    for (UIView *tabBarBtn in self.subviews) {
        // 根据名称获取类名
        Class clazz = NSClassFromString(@"UITabBarButton");
        if (![tabBarBtn isKindOfClass:clazz]) continue;
        x = w*index;
        if (index >=2) {
            x +=w;
        }
        tabBarBtn.frame = CGRectMake(x, y, w, h);
        // 索引++
        index ++;
    }
    
    
}


@end
