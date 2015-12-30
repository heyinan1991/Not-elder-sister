//
//  XCNRecommendTagController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNRecommendTagController.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "XCNRecommendTag.h"
#import "XCNRecommendTagCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface XCNRecommendTagController ()
@property(nonatomic, strong) NSArray *recommendTags;
/**
 * 任务管理者
 */
@property(nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation XCNRecommendTagController
static NSString * const ID = @"recommendTag";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XCNColor(206, 206, 206);
    // 标题
    self.navigationItem.title = @"精华推荐";
    // cell高度
    self.tableView.rowHeight = 70;
    // 不要分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 发送网络请求,或取出数据
    [self loadNewRecommendTags];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCNRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:ID];
}
#pragma mark -获取网络数据
- (void)loadNewRecommendTags
{
    [SVProgressHUD show];
    // 创建网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    self.manager = manager;
    // 参数数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    // 发送get请求
    __weak typeof(self) weakSelf = self;
    [self.manager GET:XCNRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 字典数据转换成模型数据
        weakSelf.recommendTags = [XCNRecommendTag objectArrayWithKeyValuesArray:responseObject];
        // 一定记得刷新表格
        [weakSelf.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        // 手动取消,直接返回
        if (error.code == NSURLErrorCancelled) return;
        // 错误蒙版
        [SVProgressHUD showErrorWithStatus:@"网络故障"];
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    // 去除蒙版
    [SVProgressHUD dismiss];
    // 取消任务
    [self.manager invalidateSessionCancelingTasks:YES];
    // 或者
//    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendTags.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCNRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.recommendTag = self.recommendTags[indexPath.row];
    return cell;
}
@end
