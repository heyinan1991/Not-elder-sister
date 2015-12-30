//
//  XCNRecommendCategory.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/23.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCNRecommendCategory : NSObject
/** id */
@property(nonatomic, copy) NSString *id;
/** 名字 */
@property(nonatomic, copy) NSString *name;

/** 用户数据 */
@property(nonatomic, strong) NSMutableArray *users;

/** 当前页数 */
@property(nonatomic, assign) NSInteger page;

/** 总页数 */
@property(nonatomic, assign) NSInteger total;

@end
