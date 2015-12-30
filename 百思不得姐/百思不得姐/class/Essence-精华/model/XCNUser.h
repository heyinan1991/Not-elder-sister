//
//  XCNUser.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/18.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCNUser : NSObject
/**
 *  最热评论用户名
 */
@property(nonatomic, copy) NSString *username;
/** 头像 */
@property(nonatomic, copy) NSString *profile_image;
/** 性别 */
@property(nonatomic, copy) NSString *sex;


@end
