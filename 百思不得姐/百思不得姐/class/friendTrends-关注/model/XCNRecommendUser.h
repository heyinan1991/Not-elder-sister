//
//  XCNRecommendUser.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/23.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCNRecommendUser : NSObject
/** 昵称 */
@property (nonatomic, copy) NSString *screen_name;
/** 粉丝数 */
@property (nonatomic, assign) NSInteger fans_count;
/** 头像 */
@property (nonatomic, copy) NSString *header;
@end
