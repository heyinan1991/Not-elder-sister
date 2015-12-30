//
//  XCNCommentCell.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/26.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCNComment;
@interface XCNCommentCell : UITableViewCell
/** 评论模型 */
@property(nonatomic, strong) XCNComment *comment;
@end
