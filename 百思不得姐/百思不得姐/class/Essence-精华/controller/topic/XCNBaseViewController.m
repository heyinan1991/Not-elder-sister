//
//  XCNBaseViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/15.
//  Copyright © 2015年 xuchuangnan. Base rights reserved.
//

#import "XCNBaseViewController.h"
#import <MJExtension/MJExtension.h>
#import "XCNHTTPSessionManager.h"
#import "XCNTopic.h"
#import "XCNTopicCell.h"
#import <MJRefresh/MJRefresh.h>
#import "XCNRefreshHeader.h"
#import "XCNRefreshFooter.h"
#import "XCNNewViewController.h"
#import "XCNEssenceViewController.h"
#import "XCNCommentViewController.h"
@interface XCNBaseViewController ()
/**
 *  请求管理者
 */
@property(nonatomic, weak) XCNHTTPSessionManager *manager;
/**
 *  帖子数组
 */
@property(nonatomic, strong) NSMutableArray *topics;
/**
 *  用来加载下一页数据的参数
 */
@property(nonatomic, copy) NSString *maxtime;
/** 帖子是否新帖类型 */
@property(nonatomic, copy) NSString *listType;

@end

@implementation XCNBaseViewController

- (XCNTopicTpye)type{ return 0;}

static NSString * const topicId = @"topic";
#pragma mark - 初始化设置
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化设置
    [self setupInit];
    // 刷新
    [self setUpRefresh];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCNTopicCell class]) bundle:nil] forCellReuseIdentifier:topicId];
    // 监听tabBar按钮点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonClick) name:XCNTabBarButtonRepeatClickNotfication object:nil];
    // 监听菜单栏按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonClick) name:XCNTitleButtonRepeatClickNotfication object:nil];
}

- (void)setupInit
{
    // 设置内边距
    self.tableView.contentInset = UIEdgeInsetsMake(104, 0, 49, 0);
    // 设置右边指示器的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    // 设置不要分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 背景
    self.tableView.backgroundColor = XCNColor(206, 206, 206);
}
#pragma mark- 监听tabBaran按钮的重复点击
- (void)tabBarButtonClick
{
    // 如果发现控制器的view不再程序主窗口上就直接返回,不刷新
    if (self.view.window == nil) return;
    
    // 这个控制器的view在程序主窗口上
    // 将view的坐标系转换成程序主窗口的坐标系
    CGRect viewRect = [self.view convertRect:self.view.bounds toView:nil];
    
    // 窗口的坐标系
    CGRect windowRect = self.view.window.bounds;
    if (!CGRectContainsRect(windowRect, viewRect)) return;
    // 只有当前控制器的view在window的坐标系有交界,才进行刷新
    [self.tableView.header beginRefreshing];
}
- (void)titleButtonClick
{
    [self tabBarButtonClick];
}
#pragma mark - 懒加载
- (XCNHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [XCNHTTPSessionManager manager];
    }
    return _manager;
}
#pragma mark - 刷新
- (void)setUpRefresh
{
    // 下拉刷新
    self.tableView.header = [XCNRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 已进入界面就开始刷新
    [self.tableView.header beginRefreshing];
    // 上拉刷新
    self.tableView.footer = [XCNRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (NSString *)listType
{
    if ([self.parentViewController isKindOfClass:[XCNNewViewController class]]) {
        return @"newlist";
    }
    return @"list";
}


/**
 获取网络数据
 */
- (void)loadNewTopics
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.listType;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    __weak typeof(self) weakSelf = self;
    [self.manager GET:XCNRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        XCNWriteToPlist(responseObject[@"list"], responseObject);
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        // 字典数组--->模型
        weakSelf.topics = [XCNTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 刷新表格
        [weakSelf.tableView reloadData];
        // 停止刷新
        [weakSelf.tableView.header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        // 出现网络错误了就停止刷新
        [weakSelf.tableView.header endRefreshing];
        //        XCNLog(@"%@",error);
    }];
}
/**
 *  获取更多网络数据
 */
- (void)loadMoreTopics
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.listType;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"maxtime"] = self.maxtime;
    __weak typeof(self) weakSelf = self;
    [self.manager GET:XCNRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        // 字典数组--->模型
        // 更多的以前的帖子
        NSArray *moreTopic = [XCNTopic objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 添加到原来的帖子数组的后面
        [weakSelf.topics addObjectsFromArray:moreTopic];
        // 刷新表格
        [weakSelf.tableView reloadData];
        // 停止刷新
        [weakSelf.tableView.footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        // 出现网络错误了就停止刷新
        [weakSelf.tableView.footer endRefreshing];
        XCNLog(@"%@",error);
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    XCNTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topicId];
    // 传递数据
    cell.topic = self.topics[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCNTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCNCommentViewController *commentVc = [[XCNCommentViewController alloc]init];
    commentVc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVc animated:YES];
}


@end
