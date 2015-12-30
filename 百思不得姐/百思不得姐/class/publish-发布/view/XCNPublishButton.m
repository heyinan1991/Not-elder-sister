//
//  XCNPublishButton.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/29.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNPublishButton.h"

@implementation XCNPublishButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
   
    // 图片
    self.imageView.centerX = self.width*0.5;
    self.imageView.y = 10;
    //文字
    self.titleLabel.width = self.width;
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.bottom;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
