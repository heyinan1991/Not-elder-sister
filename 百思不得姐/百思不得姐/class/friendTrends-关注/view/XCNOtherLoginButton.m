//
//  XCNOtherLoginButton.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNOtherLoginButton.h"

@implementation XCNOtherLoginButton

- (void)awakeFromNib
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置图片
    self.imageView.y = 0;
    self.imageView.centerX = self.width*0.5;
    
    // 设置文字
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
}

@end
