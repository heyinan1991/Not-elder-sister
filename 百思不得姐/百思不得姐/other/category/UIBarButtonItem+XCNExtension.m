//
//  UIBarButtonItem+XCNExtension.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/9.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "UIBarButtonItem+XCNExtension.h"

@implementation UIBarButtonItem (XCNExtension)
+ (instancetype)itemWithImage:(NSString *)image heightImage:(NSString *)heightImage action:(SEL)action target:(id)target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:heightImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}
@end
