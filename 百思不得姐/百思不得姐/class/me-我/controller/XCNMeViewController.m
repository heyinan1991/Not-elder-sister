//
//  XCNMeViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/9.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNMeViewController.h"
#import "XCNSettingViewController.h"
#import "XCNMeFooterView.h"
#import "XCNMeCell.h"
@interface XCNMeViewController ()

@end

@implementation XCNMeViewController
#pragma mark - 初始化设置
static NSString * const meCellId = @"meCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化设置
    [self setUpNav];
    
    // 设置线条
    [self serupTable];
    
    // 注册cell
    [self.tableView registerClass:[XCNMeCell class]forCellReuseIdentifier:meCellId];
}

- (void)serupTable
{
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = XCNMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(XCNMargin-XCNGroupFristCellY, 0, 0, 0);
    // 设置九宫格View
    self.tableView.tableFooterView = [[XCNMeFooterView alloc]init];
}

/**
 *  初始化设置
 */
- (void)setUpNav
{
    self.view.backgroundColor = XCNColor(206, 206, 206);
    // 设置左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_coin_icon" heightImage:@"nav_coin_icon-click" action:@selector(meClick) target:self];
    // 设置右边的按钮
    UIBarButtonItem *item1 = [UIBarButtonItem itemWithImage:@"mine-setting-icon" heightImage:@"mine-setting-icon-click" action:@selector(settingClick) target:self];
    UIBarButtonItem *item2 = [UIBarButtonItem itemWithImage:@"mine-moon-icon" heightImage:@"mine-moon-icon-click" action:@selector(moonClick) target:self];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}

#pragma mark - 监听
- (void)settingClick
{
    XCNFuc;
    XCNSettingViewController *settingVC = [[XCNSettingViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)moonClick
{
    XCNFuc;
}

- (void)meClick
{
    XCNFuc;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCNMeCell *cell = [tableView dequeueReusableCellWithIdentifier:meCellId];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登陆/注册";
        cell.imageView.image = [UIImage imageNamed:@"publish-audio"];
    }else{
        cell.textLabel.text = @"离线下载";
        cell.imageView.image = nil;
    }
    return cell;
}


@end
