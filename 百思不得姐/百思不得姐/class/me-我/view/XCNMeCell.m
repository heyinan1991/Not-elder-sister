//
//  XCNMeCell.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/11.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNMeCell.h"

@implementation XCNMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
        self.textLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.image == nil) return;
    // 图片
    self.imageView.height = self.contentView.height - XCNMargin;
    self.imageView.centerY = self.contentView.height*0.5;
    self.imageView.width = self.imageView.height;
    
    // 文字
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + XCNMargin;
    // 或者
//    self.textLabel.x = self.imageView.x + self.imageView.width + XCNMargin;
    
}


@end
