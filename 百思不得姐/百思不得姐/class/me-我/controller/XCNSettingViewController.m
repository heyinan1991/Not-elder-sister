//
//  XCNSettingViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/12.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNSettingViewController.h"
#import "XCNCleanCachesCell.h"
#import "XCNFunctionCell.h"
#import "XCNOtherCell.h"
@interface XCNSettingViewController ()

@end

@implementation XCNSettingViewController
static NSString * const cleanCellId = @"CleanCachesCell";
static NSString * const functionCellId = @"functionCell";
static NSString * const otherCellId = @"other";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    // 注册settingcell
    [self.tableView registerClass:[XCNCleanCachesCell class] forCellReuseIdentifier:cleanCellId];
    // function
    [self.tableView registerClass:[XCNFunctionCell class] forCellReuseIdentifier:functionCellId];
    // other
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCNOtherCell class]) bundle:nil] forCellReuseIdentifier:otherCellId];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
        return 20;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:cleanCellId];
    }else if (indexPath.section == 1){
        XCNFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:functionCellId];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"检查更新";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"给我们评分";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"推送设置";
        } else {
            cell.textLabel.text = @"关于我们";
        }
        return cell;
    }else{
        return [tableView dequeueReusableCellWithIdentifier:otherCellId];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"清理";
    }else if (section == 1){
        return @"功能模块";
    }else
    {
        return @"其他";
    }
}

@end
