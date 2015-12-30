//
//  XCNStatusBarViewController.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/26.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCNStatusBarViewController : UIViewController
+ (void)show;

+ (instancetype)shareStatusBarVC;
/** 状态栏显隐 */
@property(nonatomic, assign,getter=isstatusBarHidden) BOOL statusBarHidden;
/** 状态栏样式 */
@property(nonatomic, assign) UIStatusBarStyle  statusBarStyle;
@end
