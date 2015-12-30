//
//  XCNTopicCenterView.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/22.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCNTopic;
@interface XCNTopicCenterView : UIView
{
   __weak UIImageView *_imageView;
    __weak UIImageView *_placeholderView;
}


+ (instancetype)centerView;
/** 帖子模型 */
@property(nonatomic, strong) XCNTopic *topic;
@end
