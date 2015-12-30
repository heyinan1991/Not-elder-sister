//
//  XCNTopic.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/15.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XCNComment;
@class XCNTopicPictureView;
typedef enum{
    /** 全部 */
    XCNTopicTypeAll = 1,
    /** 图片 */
    XCNTopicTypePicture = 10,
    /** 文字 */
    XCNTopicTypeWord = 29,
    /** 声音 */
    XCNTopicTypeVoice = 31,
    /** 视频 */
    XCNTopicTypeViedo = 41,
} XCNTopicTpye;

@interface XCNTopic : NSObject
// 用户 -- 发帖者
/** 帖子id */
@property(nonatomic, copy) NSString *id;

/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profileImage;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *createdAt;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/**最热评论模型*/
@property(nonatomic, strong) XCNComment *top_cmt;
/**帖子类型*/
@property(nonatomic, assign) XCNTopicTpye type;
/** 大图片 */
@property(nonatomic, copy) NSString *big_image;
/** 中图片 */
@property(nonatomic, copy) NSString *middle_image;
/** 小图 */
@property(nonatomic, copy) NSString *small_image;
/** 是否是gif图片 */
@property(nonatomic, assign) BOOL is_gif;
/** 声音播放次数 */
@property(nonatomic, assign) NSInteger playcount;
/** 声音播放时长 */
@property(nonatomic, assign) NSInteger voicetime;
/** 视频播放时间 */
@property(nonatomic, assign) NSInteger videotime;

/**图片的宽*/
@property(nonatomic, assign) CGFloat width;
/**图片的高*/
@property(nonatomic, assign) CGFloat height;
/** 图片是否超过屏幕长度 */
@property(nonatomic, assign,getter=isBigPic) BOOL isBigPic;

/**辅助属性*/
/**中间View的frame*/
@property(nonatomic, assign) CGRect centerViewFrame;
/** cell的高度 */
@property(nonatomic, assign) CGFloat cellHeight;
@end
