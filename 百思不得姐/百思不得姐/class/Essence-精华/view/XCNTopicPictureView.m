//
//  XCNTopicPictureView.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/18.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNTopicPictureView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XCNTopic.h"
#import <DALabeledCircularProgressView.h>
#import "XCNSeeBigImageViewViewController.h"
@interface XCNTopicPictureView ()

/**
 *  上边gif标示
 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/**
 *  点击看大图按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

/**
 *  进度图片
 */
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView*progressView;


@end

@implementation XCNTopicPictureView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];

}

- (void)setTopic:(XCNTopic *)topic
{
    [super setTopic:topic];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.big_image] placeholderImage:nil options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // 正在下载的提醒
        self.progressView.hidden = NO;
        _placeholderView.hidden = NO;
        // 设置下载进度
        self.progressView.progress = 1.0 * receivedSize/expectedSize;
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",self.progressView.progress*100];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _progressView.hidden = YES;
        _placeholderView.hidden = YES;
    } ];
    // 大图
    if (topic.isBigPic) {
        _imageView.contentMode = UIViewContentModeTop;
        _imageView.clipsToBounds = YES;
    }else
    {
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.clipsToBounds = NO;
    }
    // 设置gif显示隐藏
    self.gifView.hidden = !topic.is_gif;
    
    // 设置按钮显示隐藏
    self.seeBigPictureButton.hidden = !topic.isBigPic;
    
}

@end
