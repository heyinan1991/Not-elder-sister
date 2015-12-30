//
//  XCNRecommendUserCell.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/23.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNRecommendUserCell.h"
#import "XCNRecommendUser.h"
@interface XCNRecommendUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation XCNRecommendUserCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setUser:(XCNRecommendUser *)user
{
    _user = user;
    
    [self.headerImageView setHeaderImageUrl:user.header];
    self.screenNameLabel.text = user.screen_name;
    // 设置粉丝
    if (user.fans_count>10000) {
        self.fansCountLabel.text = [NSString stringWithFormat:@"%.1f万人关注",user.fans_count/10000.0];
    }else{
        self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    }
}

@end
