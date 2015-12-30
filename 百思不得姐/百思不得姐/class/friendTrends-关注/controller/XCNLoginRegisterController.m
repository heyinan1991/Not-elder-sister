//
//  XCNLoginRegisterController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNLoginRegisterController.h"

@interface XCNLoginRegisterController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation XCNLoginRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [XCNStatusBarViewController shareStatusBarVC].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [XCNStatusBarViewController shareStatusBarVC].statusBarStyle = UIStatusBarStyleDefault;
}
- (IBAction)loginRegisterclick:(UIButton *)button {
    // 正常和选中状态的切换
    button.selected = !button.isSelected;
    if (self.leftMargin.constant) {
        self.leftMargin.constant = 0;
    }else
    {
        self.leftMargin.constant = -self.view.width;
    }
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self.view endEditing:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
