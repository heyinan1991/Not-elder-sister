//
//  UIImageView+XCNExtension.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (XCNExtension)
/**
 设置头部图片
 */
- (void)setHeaderImageUrl:(NSString *)url;
/**
 设置圆角图片
 */
- (void)setCircleImageUrl:(NSString *)url;
/**
 设置方形图片
 */
- (void)setRectImageUrl:(NSString *)url;
@end
