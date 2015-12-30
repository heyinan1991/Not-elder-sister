//
//  XCNTopicCenterView.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/22.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNTopicCenterView.h"
#import "XCNSeeBigImageViewViewController.h"
@interface XCNTopicCenterView ()
/**
 *  背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  占位图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@end


@implementation XCNTopicCenterView

+ (instancetype)centerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:0].firstObject;
}

- (void)awakeFromNib
{
    // 去除默认的autoresizing设置,防止xib加载到别的控制器的view上变形
    self.autoresizingMask = UIViewAutoresizingNone;
    // 监听图片点击
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)]];

}

- (void)imageViewClick
{
    if (self.imageView.image == nil) return;
    
    XCNSeeBigImageViewViewController *seeVc = [[XCNSeeBigImageViewViewController alloc]init];
    seeVc.topic = self.topic;
    [self.window.rootViewController presentViewController:seeVc animated:YES completion:nil];
}

@end
