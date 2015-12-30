//
//  XCNRecommendUserCell.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/23.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCNRecommendUser;
@interface XCNRecommendUserCell : UITableViewCell
/** 用户模型 */
@property(nonatomic, strong) XCNRecommendUser *user;
@end
