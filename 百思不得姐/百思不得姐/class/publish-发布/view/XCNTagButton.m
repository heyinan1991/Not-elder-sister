//
//  XCNTagButton.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/31.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNTagButton.h"

@implementation XCNTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 字体
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = XCNTagBgColor;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    // 自动适配
    [self sizeToFit];
    self.height = 25;
    self.width +=3*XCNSmallMargin;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.x = XCNSmallMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame)+XCNSmallMargin;
}



@end
