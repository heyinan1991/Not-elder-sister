//
//  XCNMeSquareButton.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/11.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNMeSquareButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "XCNMeSquare.h"
@implementation XCNMeSquareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    }
    return self;
}

/** set方法根据网络数据设置名字,图片*/

- (void)setSquare:(XCNMeSquare *)square
{
    _square = square;
    // 发送网络请求,设置数据
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal placeholderImage:[UIImage cirlceImageName:@"defaultUserIcon"]];
    [self setTitle:square.name forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片
    self.imageView.width = self.width*0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.width*0.5;
    self.imageView.y = self.height*0.1;
    // 设置文字
    self.titleLabel.y = self.imageView.bottom + self.height*0.1;
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
