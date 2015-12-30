//
//  XCNPlaceHolderTextView.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/29.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNPlaceHolderTextView.h"

@interface XCNPlaceHolderTextView ()
/** 占位label */
@property(nonatomic, weak) UILabel *placeholderLabel;

@end


@implementation XCNPlaceHolderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 添加label
        UILabel *placeholderLabel = [[UILabel alloc]init];
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        // 光标颜色
        self.tintColor = [UIColor darkGrayColor];
        // 初始化占位文字大小,颜色
        self.font = [UIFont systemFontOfSize:15];
        self.placeholderColor = [UIColor darkGrayColor];
        // 使用通知监听文字的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChange:(NSNotification *)note
{
    // 没有输入文字占位文字就显示,输入文字占位文字就不显示
    self.placeholderLabel.hidden = self.hasText;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    // 定位占位文字
    self.placeholderLabel.x = 5;
    self.placeholderLabel.y = 10;
    self.placeholderLabel.width = XCNScreenW - 2*self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
    
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

//- (void)setText:(NSString *)text
//{
//    [super setText:text];
//    self.placeholderLabel.hidden = self.hasText;
//}
//
//- (void)setFont:(UIFont *)font
//{
//    [super setFont:font];
//    
//    self.placeholderLabel.font = font;
//    [self.placeholderLabel sizeToFit];
//}
//
//- (void)setAttributedText:(NSAttributedString *)attributedText
//{
//    [super setAttributedText:attributedText];
//    
//}



@end
