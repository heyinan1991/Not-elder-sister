//
//  XCNComment.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/18.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XCNUser;
@interface XCNComment : NSObject
/**
 *  最热评论内容
 */
@property(nonatomic, copy) NSString *content;
/**
 *  发表这条评论的用户
 */
@property(nonatomic, strong) XCNUser *user;

/** 点赞数量 */
@property(nonatomic, assign) NSInteger  like_count;


/** 评论的id */
@property(nonatomic, copy) NSString *id;

/** 用户语音的路径 */
@property(nonatomic, copy) NSString *voiceuri;
/** 音频文件的时长 */
@property(nonatomic, assign) NSInteger voicetime;


@end
