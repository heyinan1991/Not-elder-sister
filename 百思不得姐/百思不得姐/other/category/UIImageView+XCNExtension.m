//
//  UIImageView+XCNExtension.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "UIImageView+XCNExtension.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation UIImageView (XCNExtension)
- (void)setHeaderImageUrl:(NSString *)url
{
    [self setCircleImageUrl:url];
}

- (void)setCircleImageUrl:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return;
        self.image = [image circleImage];
    }];
}
- (void)setRectImageUrl:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}
@end
