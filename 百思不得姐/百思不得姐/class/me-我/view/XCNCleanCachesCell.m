//
//  XCNCleanCachesCell.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/12.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNCleanCachesCell.h"
#import <SVProgressHUD.h>
@implementation XCNCleanCachesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.text = @"清除缓存";
        self.userInteractionEnabled = NO;
        // 添加菊花指示器
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.accessoryView = activity;
        // 菊花指示器要启动动画
        [activity startAnimating];
        
        // 一旦缓存比较大,就需要在子线程计算
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 模拟缓存较多
            [NSThread sleepForTimeInterval:6.0];
            // 计算大小
            unsigned long long fileSize = XCNCacheFilePath.fileSize;
            // 定义单位
            double unit = 1000.0;
            // 标签文字
            NSString *fileSizeText = nil;
            if (fileSize>=pow(unit, 3)) { // GB
                fileSizeText = [NSString stringWithFormat:@"%.2fGB",fileSize/pow(unit, 3)];
            }else if (fileSize>=pow(unit, 2)){//mb
                fileSizeText = [NSString stringWithFormat:@"%.2fMB",fileSize/ pow(unit, 2)];
            }else if (fileSize>=unit){//KB
                fileSizeText = [NSString stringWithFormat:@"%.2fKb",fileSize/unit];
            }else{
                fileSizeText = [NSString stringWithFormat:@"%lluB",fileSize];
            }
            NSString *text =  [NSString stringWithFormat:@"清除缓存(%@)",fileSizeText];
            // 回主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置标签文字
                self.textLabel.text = text;
                
                // 去掉菊花指示器
                self.accessoryView = nil;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.userInteractionEnabled = YES;
            });
        });
        // 添加手势
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleanCache)]];
    }
    return self;
}

- (void)cleanCache
{
//    if (self.accessoryView) return;
    // 添加提示
    [SVProgressHUD showErrorWithStatus:@"正在清除缓存" maskType:SVProgressHUDMaskTypeBlack];
    // 在子线程删除缓存
    [[[NSOperationQueue alloc] init]addOperationWithBlock:^{
        // 删除缓存
//        [NSThread sleepForTimeInterval:2.0];
        [[NSFileManager defaultManager] removeItemAtPath:XCNCacheFilePath error:nil];
        // 在主线程修改标签文字
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.textLabel.text = @"清除缓存(0B)";
            [SVProgressHUD showSuccessWithStatus:@"清除完成"];
        }];
    }];
}

/**
 *  当控件从没有显示到控制器到显示到控制器就会调用一次
    当控件的尺寸发生变化时就会调用
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 当cell离开当前界面时, UIActivityIndicatorView的动画就会被停止,这是核心动画的规则
    // 当cell显示到当前界面时,就应该重新调用 UIActivityIndicatorView的startAnimating 开始动画
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)self.accessoryView;
    [activity startAnimating];
    
    
}


@end
