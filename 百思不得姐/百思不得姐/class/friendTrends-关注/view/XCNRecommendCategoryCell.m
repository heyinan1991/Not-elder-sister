//
//  XCNRecommendCategoryCell.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/23.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNRecommendCategoryCell.h"
#import "XCNRecommendCategory.h"
@interface XCNRecommendCategoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedIndicatorView;


@end


@implementation XCNRecommendCategoryCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) { // 选中
        self.nameLabel.textColor = [UIColor redColor];
        self.selectedIndicatorView.backgroundColor = [UIColor redColor];
        self.selectedIndicatorView.hidden = NO;
    } else { // 取消选中
        self.nameLabel.textColor = [UIColor darkGrayColor];
        self.selectedIndicatorView.hidden = YES;
    }

}

- (void)setCategory:(XCNRecommendCategory *)category
{
    _category = category;
    self.nameLabel.text = [NSString stringWithFormat:@"%@",category.name];
}

@end
