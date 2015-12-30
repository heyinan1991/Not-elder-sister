//
//  XCNLoginRegisterTextField.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNLoginRegisterTextField.h"
#define XCNPlaceholderColor @"placeholderLabel.textColor"
@implementation XCNLoginRegisterTextField

- (void)awakeFromNib
{
    // 设置光标的颜色
    self.tintColor = [UIColor whiteColor];
    // 设置输入文字的颜色
    self.textColor = [UIColor whiteColor];
    // 设置提示文字的颜色
    [self setValue:[UIColor grayColor] forKeyPath:XCNPlaceholderColor];
    
    // kvo监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setValue:[UIColor whiteColor] forKeyPath:XCNPlaceholderColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setValue:[UIColor grayColor] forKeyPath:XCNPlaceholderColor];
}

@end
