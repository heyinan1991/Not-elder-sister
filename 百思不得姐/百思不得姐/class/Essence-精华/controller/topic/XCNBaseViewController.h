//
//  XCNBaseViewController.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/22.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCNTopic.h"
@interface XCNBaseViewController : UITableViewController
/** 帖子类型 */
//@property(nonatomic, assign) XCNTopicTpye type;
- (XCNTopicTpye)type;
@end
