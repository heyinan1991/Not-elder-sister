//
//  XCNCommentHeaderView.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/26.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNCommentHeaderView.h"

@interface XCNCommentHeaderView ()
/** label */
@property(nonatomic, weak) UILabel *label;

@end


@implementation XCNCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = XCNColor(206, 206, 206);
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:14];
        label.x = 10;
        label.y = 0;
        label.width = 100;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    self.label.text = text;
}

@end
