//
//  XCNTopicVoiceView.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/22.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNTopicVoiceView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XCNTopic.h"
@interface XCNTopicVoiceView ()

@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;



@end

@implementation XCNTopicVoiceView

- (void)setTopic:(XCNTopic *)topic
{
    [super setTopic:topic];
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.big_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _placeholderView.hidden = YES;
    }];
    NSInteger min = topic.voicetime/60;
    NSInteger sec = topic.voicetime%60;
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}

@end
