//
//  XCNRefreshHeader.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/16.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNRefreshHeader.h"

@implementation XCNRefreshHeader

- (void)prepare
{
    [super prepare];
    // 调整下拉刷新显示的时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 自动调整刷新透明度
    self.automaticallyChangeAlpha = YES;
    // 设置下拉刷新的文字颜色
    self.stateLabel.textColor = [UIColor redColor];
    // 闲置状态下的文字
    [self setTitle:@"下拉哥给你刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"🐮🐮松开刷新🐮🐮" forState:MJRefreshStatePulling];
    [self setTitle:@"哥正给你刷新" forState:MJRefreshStateRefreshing];
}

@end
