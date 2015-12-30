//
//  XCNRecommendCategoryCell.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/23.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XCNRecommendCategory;
@interface XCNRecommendCategoryCell : UITableViewCell
/** 左边数据的模型 */
@property(nonatomic, strong) XCNRecommendCategory *category;
@end
