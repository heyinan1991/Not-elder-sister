//
//  XCNRecommendTag.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCNRecommendTag : NSObject
/**
 *  标题
 */
@property(nonatomic, copy) NSString *theme_name;
/**
 *  图片
 */
@property(nonatomic, copy) NSString *image_list;
/**
 *  订阅数
 */
@property(nonatomic, assign) NSInteger sub_number;
@end
