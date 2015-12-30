//
//  XCNRecommendTagCell.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNRecommendTagCell.h"
#import "XCNRecommendTag.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface XCNRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunNumberLabel;

@end

@implementation XCNRecommendTagCell

- (void)setRecommendTag:(XCNRecommendTag *)recommendTag
{
    _recommendTag = recommendTag;
    // 标题
    self.themeNameLabel.text = recommendTag.theme_name;
    // 订阅数
    if (recommendTag.sub_number>10000) {
        self.sunNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅",recommendTag.sub_number/10000.0];
    }else{
        self.sunNumberLabel.text = [NSString stringWithFormat:@"%ld人订阅",recommendTag.sub_number];
    }
    // 头像
    [self.imageListView setHeaderImageUrl:recommendTag.image_list];
}
/**
 *  设置分割线
 */

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
