//
//  XCNTopicCell.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/16.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNTopicCell.h"
#import "XCNTopic.h"
#import "XCNComment.h"
#import "XCNUser.h"
#import "XCNTopicPictureView.h"
#import "XCNTopicVoiceView.h"
#import "XCNTopicVideoView.h"
@interface XCNTopicCell ()
/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 创建时间 */
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
/** 正文 */
@property (weak, nonatomic) IBOutlet UILabel *text_Label;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 最热评论 */
@property (weak, nonatomic) IBOutlet UIView *hotCommentView;
@property (weak, nonatomic) IBOutlet UILabel *hotContentLabel;
/** 图片view */
@property(nonatomic, weak) XCNTopicPictureView *pictureView;
/** 声音view */
@property(nonatomic, weak) XCNTopicVoiceView *voiceView;
/** 声音view */
@property(nonatomic, weak) XCNTopicVideoView *videoView;

@end

@implementation XCNTopicCell
- (XCNTopicPictureView *)pictureView
{
    if (!_pictureView) {
        XCNTopicPictureView *pictureView = [XCNTopicPictureView centerView];
        [self.contentView addSubview:pictureView];
        self.pictureView = pictureView;
    }
    return _pictureView;
}

- (XCNTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        XCNTopicVoiceView *voiceView = [XCNTopicVoiceView centerView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (XCNTopicVideoView *)videoView
{
    if (!_videoView) {
        XCNTopicVideoView *videoView = [XCNTopicVideoView centerView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}
- (void)awakeFromNib
{
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    self.hotCommentView.hidden = YES;
}

- (void)setTopic:(XCNTopic *)topic
{
    _topic = topic;
    /** 头像 */
    [self.profileImageView setHeaderImageUrl:topic.profileImage];
    /** 昵称 */
    self.nameLabel.text = topic.name;
    
    /** 正文 */
    self.text_Label.text = topic.text;
    
    /** 顶 */
    [self setUpButton:self.dingButton number:topic.ding title:@"顶"];
    // 踩
    [self setUpButton:self.caiButton number:topic.cai title:@"踩"];
    // 分享
    [self setUpButton:self.repostButton number:topic.repost title:@"分享"];
    // 评论
    [self setUpButton:self.commentButton number:topic.comment title:@"评论"];
    /** 创建时间 */
    // 在模型内部处理数据
    self.createdLabel.text = topic.createdAt;
    // 控制器最热评论的显示
    if (topic.top_cmt) {
        self.hotCommentView.hidden = NO;
        // 内容
        NSString *com = topic.top_cmt.content;
        // 用户名
        NSString *name = topic.top_cmt.user.username;
        self.hotContentLabel.text = [NSString stringWithFormat:@"%@:%@",name,com];
        
    }else{
        self.hotCommentView.hidden = YES;
    }
    
    // 往中间添加内容
    if (topic.type == XCNTopicTypePicture) {
        self.pictureView.hidden = NO;
         self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        // 设置frame
        self.pictureView.frame = topic.centerViewFrame;
        // 设置数据
        self.pictureView.topic = topic;
    }else if (topic.type == XCNTopicTypeViedo){
        self.pictureView.hidden = YES;
         self.voiceView.hidden = YES;
        self.videoView.hidden= NO;
        self.videoView.frame = topic.centerViewFrame;
        self.videoView.topic = topic;
        
    }else if (topic.type == XCNTopicTypeVoice){
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
        // 设置frame
        self.voiceView.frame = topic.centerViewFrame;
        // 设置数据
        self.voiceView.topic = topic;
    }else{
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
}

- (void)setUpButton:(UIButton *)button number:(NSInteger)num title:(NSString *)title
{
    if (num==0) {
        return [button setTitle:title forState:UIControlStateNormal];
    }else if (num>=10000){
        return [button setTitle:[NSString stringWithFormat:@"%.1f万",num/10000.0] forState:UIControlStateNormal];
    }else{
        return[button setTitle:[NSString stringWithFormat:@"%zd",num] forState:UIControlStateNormal];
    }
}


- (void)setFrame:(CGRect)frame
{
    frame.origin.y +=XCNMargin;
    frame.size.height -=XCNMargin;
    
    [super setFrame:frame];
}
- (IBAction)moreClick:(id)sender {
    
    // iOS8以后弹框合并成一种:UIAltertcontroller
    // iOS8之前:UIAlertView和UIActionSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        XCNLog(@"点击了收藏");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         XCNLog(@"点击了分享");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        XCNLog(@"点击了取消");
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


@end
