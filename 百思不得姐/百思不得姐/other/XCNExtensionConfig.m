//
//  XCNExtensionConfig.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/18.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNExtensionConfig.h"
#import "XCNComment.h"
#import "XCNTopic.h"
#import <MJExtension.h>
@implementation XCNExtensionConfig
+ (void)load
{
    [XCNTopic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"profileImage":@"profile_image",
                 @"createdAt":@"created_at",
                 @"top_cmt":@"top_cmt[0]",
                 // 小图
                 @"small_image":@"image0",
                 // 中图
                 @"middle_image":@"image2",
                 // 大图
                 @"big_image":@"image1"
                 };
    }];
}
@end
