//
//  XCNNewViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/9.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNNewViewController.h"

@interface XCNNewViewController ()

@end

@implementation XCNNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XCNColor(206, 206, 206);

    // 设置左边的标签
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" heightImage:@"MainTagSubIconClick" action:@selector(newClick) target:self];
}


- (void)newClick
{
    XCNFuc;
}

@end
