//
//  UITextField+XCNExtension.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/30.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "UITextField+XCNExtension.h"
/**
 *  占位文字颜色
 */
static NSString * const XCNPlaceholderColorKey = @"placeholderLabel.textColor";
@implementation UITextField (XCNExtension)

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    BOOL chang = NO;
    // 保证有占位文字
    if (self.placeholder == nil) {
//        self.placeholder = @" ";
        chang = YES;
    }
    // 设置占位文字的颜色
    [self setValue:placeholderColor forKeyPath:XCNPlaceholderColorKey];
    // 回复原状
    if (chang) {
        self.placeholder = nil;
    }
}

- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:XCNPlaceholderColorKey];
}

@end
