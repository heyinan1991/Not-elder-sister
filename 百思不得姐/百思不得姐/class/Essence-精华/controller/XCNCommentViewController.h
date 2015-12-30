//
//  XCNCommentViewController.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/24.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCNTopic;
@interface XCNCommentViewController : UIViewController
/** 帖子模型 */
@property(nonatomic, strong) XCNTopic *topic;
@end
