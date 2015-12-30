//
//  XCNCommentCell.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/26.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNCommentCell.h"
#import "XCNComment.h"
#import "XCNUser.h"
@interface XCNCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end



@implementation XCNCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setComment:(XCNComment *)comment
{
    _comment = comment;
    
//    if (arc4random_uniform(100) > 50) {
//                comment.voicetime = arc4random_uniform(60);
//                comment.voiceuri = @"http://123.mp3";
//                comment.content = nil;
//            }
    // 头像
    [self.profileImageView setHeaderImageUrl:self.comment.user.profile_image];
    // 性别
    NSString *sexImageName = [comment.user.sex isEqualToString:@"m"]?@"Profile_manIcon":@"Profile_womanIcon";
    self.sexImageView.image = [UIImage imageNamed:sexImageName];
    // 用户名
    self.userNameLabel.text = comment.user.username;
    // 正文
    self.contentLabel.text = comment.content;
    // 点赞数
    self.likeLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    // 音频
    if (self.comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
    }else
    {
        self.voiceButton.hidden = YES;
    }
    
}



@end
