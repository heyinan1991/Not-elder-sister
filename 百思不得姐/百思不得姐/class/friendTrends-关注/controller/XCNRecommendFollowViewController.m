//
//  XCNRecommendFollowViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/23.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNRecommendFollowViewController.h"
#import "XCNHTTPSessionManager.h"
#import <MJExtension.h>
#import "XCNRecommendCategory.h"
#import "XCNRecommendCategoryCell.h"
#import "XCNRefreshHeader.h"
#import "XCNRefreshFooter.h"
#import "XCNRecommendUser.h"
#import "XCNRecommendUserCell.h"
#import <SVProgressHUD.h>
@interface XCNRecommendFollowViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoryTable;
@property (weak, nonatomic) IBOutlet UITableView *userTable;
/** 网络管理者 */
@property(nonatomic, strong) XCNHTTPSessionManager *manager;
/** 左边组模型 */
@property(nonatomic, strong) NSArray<XCNRecommendCategory *> *categories;
/** 用户数据 */
//@property(nonatomic, strong) NSArray<XCNRecommendUser *> *users;
@end

@implementation XCNRecommendFollowViewController
static NSString * const categoryId = @"category";
static NSString * const userId = @"user";
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化table
    [self setupTable];
    // 刷新
    [self setupRefresh];
    // 获取左边的网络数据
    [self loadCategorySource];
    
    
}
/**
 *  初始化table
 */
- (void)setupTable
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = XCNColor(206, 206, 206);
    self.categoryTable.contentInset = UIEdgeInsetsMake(XCNTopMargin, 0, 0, 0);
    self.categoryTable.scrollIndicatorInsets = self.categoryTable.contentInset;
    self.userTable.contentInset = self.categoryTable.contentInset;
    self.userTable.scrollIndicatorInsets = self.categoryTable.contentInset;
}
/**
 *  刷新请求
 */
- (void)setupRefresh
{
    //下拉刷新
    self.userTable.header = [XCNRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadUserSource)];
    // 上拉刷新
    self.userTable.footer = [XCNRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSource)];
}

#pragma mark -懒加载
- (XCNHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [XCNHTTPSessionManager manager];
    }
    return _manager;
}
#pragma mark - 资源请求

/**
 *  下拉刷新获取更多数据
 */
- (void)loadMoreSource
{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 当前选中行对应的类别模型
    XCNRecommendCategory *category = self.categories[self.categoryTable.indexPathForSelectedRow.row];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = category.id;
    // 如果用模型属性category.page直接赋值给params[@"page"],那么在下拉刷新还没有刷新到最大数据的时候上拉刷新了,那么此时的category.page又会变成1,但是这时页面应该对应的page不是1,再下拉刷新出来的数据会和前面的有重复
    // 解决办法:不直接用category.page赋值,用一个中间变量,
    NSInteger page = category.page + 1;
    params[@"page"]= @(page);
    __weak typeof(self) weakSelf = self;
    [self.manager GET:XCNRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        category.page = page;
        // 字典数组---模型数组 获取的更多的数据
        NSArray *moreArray = [XCNRecommendUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 将获得的新数据拼接到原来的数据后面,因为是上拉刷新,一般下拉刷新是获取新数据覆盖掉原来的数据
        [category.users addObjectsFromArray:moreArray];
        // 刷新表格
        [weakSelf.userTable reloadData];
        // 如果数据已经加载完了,没有数据加载了,就提示刷新完毕
        if (category.users.count == category.total) {
            self.userTable.footer.hidden = YES;
        }else{//没有加载完毕,就先停止刷新
            [self.userTable.footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.userTable.footer endRefreshing];
        XCNLog(@"%@",error);
    }];

}
/**
 *  加载用户数据
 */
- (void)loadUserSource
{
    // 取消之前的请求:解决当点击一个类别没有刷新完毕,有点击一个类别刷新导致上一个类别的数据还显示到下一个点击的界面
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 当前选中行对应的类别模型
    XCNRecommendCategory *category = self.categories[self.categoryTable.indexPathForSelectedRow.row];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = category.id;
    __weak typeof(self) weakSelf = self;
    [self.manager GET:XCNRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        category.page = 1;
        // 字典数组---模型数组
        category.users = [XCNRecommendUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 当前的总数
        category.total = [responseObject[@"total"] integerValue];
        
        // 刷新表格
        [weakSelf.userTable reloadData];
        // 停止刷新
        [self.userTable.header endRefreshing];
        
        // 此时虽然上拉刷新但是也要判断当前数据加载完了没有,加载完了就提醒用户
        if (category.users.count == category.total) {
            self.userTable.footer.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.userTable.header endRefreshing];
        XCNLog(@"%@",error);
    }];
}
/**
 *  请求左边的数据
 */
- (void)loadCategorySource
{
    // 添加蒙版
    [SVProgressHUD showWithStatus:@"正在加在数据" maskType:SVProgressHUDMaskTypeBlack];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    __weak typeof(self) weakSelf = self;
    [self.manager GET:XCNRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        XCNWriteToPlist(responseObject, @"xxx000");
        weakSelf.categories = [XCNRecommendCategory objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [weakSelf.categoryTable reloadData];
        // 进入界面就刷新
        [weakSelf.categoryTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self.userTable.header beginRefreshing];
        // 取出蒙版
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        XCNLog(@"%@",error);
    }];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTable ) {// 类别表格
        return self.categories.count;
    }else{// 用户表格
        // 取出当前的类别模型
        XCNRecommendCategory *category = self.categories[self.categoryTable.indexPathForSelectedRow.row];
        
        return category.users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.categoryTable) {
        XCNRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryId];
        cell.category = self.categories[indexPath.row];
        return cell;
    }else
    {
        XCNRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:userId];
        XCNRecommendCategory *category = self.categories[self.categoryTable.indexPathForSelectedRow.row];
        // 取出当前选中的类别模型,将类别模型里面的模型数组信息传给用户模型,然后进行设置
        cell.user = category.users[indexPath.row];
        return cell;
    }
}

#pragma mark - 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTable) {
        // 判断当前选中行的user数组有无数据,如果有数据就不下拉刷新,直接刷新现有数据,没有就下拉刷新
        XCNRecommendCategory *category = self.categories[indexPath.row];
        if (category.users.count==0) {
            // 判断当前有无刷新在执行,如有执行,就取消,不然下一个刷新任务进行不了,因为获取数据的方法,设置有取消当前所有任务,
            if (self.userTable.header.isRefreshing) {
                [self.userTable.header endRefreshing];
            }
            [self.userTable.header beginRefreshing];
        }else{
            [self.userTable reloadData];
        }
        
    }else
    {
        XCNLog(@"%zd",indexPath.row);
    }
}

@end
