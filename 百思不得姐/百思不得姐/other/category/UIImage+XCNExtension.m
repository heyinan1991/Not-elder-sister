//
//  UIImage+XCNExtension.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "UIImage+XCNExtension.h"

@implementation UIImage (XCNExtension)
- (instancetype)circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 画一个圆形到上下文
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    
    // 裁剪圆形区域:超出区域就看不见了
    CGContextClip(context);
    // 画图片上去
    
    [self drawInRect:rect];
    
    // 获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (instancetype)cirlceImageName:(NSString *)name
{
    return [[self imageNamed:name] circleImage];
}

@end
