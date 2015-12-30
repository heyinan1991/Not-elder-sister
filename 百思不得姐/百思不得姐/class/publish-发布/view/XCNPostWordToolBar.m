//
//  XCNPostWordToolBar.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/30.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNPostWordToolBar.h"
#import "XCNAddTagViewController.h"
#import "XCNNavigationController.h"
@interface XCNPostWordToolBar ()
@property (weak, nonatomic) IBOutlet UIView *topView;


@end


@implementation XCNPostWordToolBar


- (void)awakeFromNib
{
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn sizeToFit];
    [self.topView addSubview:addBtn];
}
/**
 *  点击添加按钮push到下一个添加标签的控制器
 */
- (void)addClick
{
    XCNAddTagViewController *add = [[XCNAddTagViewController alloc]init];
    XCNNavigationController *nav = [[XCNNavigationController alloc]initWithRootViewController:add];
    // 拿到根控制器modal出来的控制器然后再modal
    UIViewController *vc = self.window.rootViewController.presentedViewController;
    [self endEditing:YES];
    [vc presentViewController:nav animated:YES completion:nil];
}

+ (instancetype)postWordToolBar
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:0].firstObject;
}


@end
