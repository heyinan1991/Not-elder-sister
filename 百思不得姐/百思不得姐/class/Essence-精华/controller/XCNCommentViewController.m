//
//  XCNCommentViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/24.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNCommentViewController.h"
#import "XCNTopic.h"
#import "XCNTopicCell.h"
#import "XCNHTTPSessionManager.h"
#import "XCNComment.h"
#import <MJExtension.h>
#import "XCNCommentCell.h"
#import "XCNRefreshFooter.h"
#import "XCNRefreshHeader.h"
#import "XCNCommentHeaderView.h"
@interface XCNCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
/** 网路管理者 */
@property(nonatomic, strong) XCNHTTPSessionManager *manager;
/** 最热评论数组 */
@property(nonatomic, strong) NSArray<XCNComment *> *hotComment;
/** 最新评论 */
@property(nonatomic, strong) NSMutableArray<XCNComment *> *latestComment;
/** 记录最热评论 */
@property(nonatomic, strong) id top_cmt;

@end

@implementation XCNCommentViewController
#pragma mark - 懒加载
/** manager属性的懒加载 */
- (XCNHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [XCNHTTPSessionManager manager];
    }
    return _manager;
}
#pragma mark - 初始化
static NSString * const commentCellId = @"comment";
static NSString * const headerViewId = @"headerView";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.navigationItem.title = @"评论";
    
    // 设置tableView
    [self setupTable];
    
    // 设置头部View
    [self setupTableHeaderView];
    
    // 上下拉刷新
    [self setUpRefresh];
    
}
/**
 *初始化table
 */
- (void)setupTable
{
    // 监听键盘的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XCNCommentCell class]) bundle:nil] forCellReuseIdentifier:commentCellId];
    // 注册headerView
    [self.tableView registerClass:[XCNCommentHeaderView class] forHeaderFooterViewReuseIdentifier:headerViewId];
    // 背景
    self.tableView.backgroundColor = XCNColor(206, 206, 206);
    // 内边距
    self.tableView.contentInset = UIEdgeInsetsMake(XCNTopMargin, 0, 0, 0);
    // 告诉cell让他自己计算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.tableView.estimatedRowHeight = 100;
    
   
}

- (void)setupTableHeaderView
{
    // 判断当前如果有最热评论,就清空最热评论,让cell为0,因为在计算没有进入评论界面的时候已经计算过高度,这个时候取出最热评论cell不会重新计算高度,除非将cell的高度设置为0,让cell重新计算高度
    if (self.topic.top_cmt) {
        self.top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        self.topic.cellHeight = 0;
    }
    // 头部控件
    UIView *headerView = [[UIView alloc]init];
    // 添加cell到view上
    XCNTopicCell *cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([XCNTopicCell class]) owner:nil options:0].firstObject;
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, XCNScreenW, self.topic.cellHeight);
    [headerView addSubview:cell];
    // 这里设置高度+XCNMargin是因为cell在计算时设置frame-10;
    headerView.height = cell.height+XCNMargin;
    self.tableView.tableHeaderView = headerView;
}


#pragma mark - 监听键盘的改变
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 在监听结束后如果有最热评论重新赋值回最热评论,并重新计算高度
    if (self.top_cmt) {
        self.topic.top_cmt = self.top_cmt;
        self.topic.cellHeight = 0;
    }
}
/**
 *  监听键盘的frame的改变
 *
 *  @param note 键盘信息
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
//    XCNLog(@"%@",note);
    CGRect end = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 根据键盘frame的改变而改变底部工具条的frame
    self.bottomLayout.constant = [UIScreen mainScreen].bounds.size.height-end.origin.y;
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
#pragma mark - 刷新

- (void)setUpRefresh
{
    // 下拉刷新
    self.tableView.header = [XCNRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewSource)];
    // 进入评论界面就刷新
    [self.tableView.header beginRefreshing];
    
    // 上拉刷新
    self.tableView.footer = [XCNRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSource)];
}


#pragma mark - 获取服务器数据

- (void)loadMoreSource
{
    // 这是如果正在下拉刷新就取消任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.id;
    // 上一页帖子的id
    params[@"lastcid"] = self.latestComment.lastObject.id;
    __weak typeof(self) weakSelf = self;
    [self.manager GET:XCNRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 刷新的同时如果服务器返回数据,会出现崩溃,这个时候返回的也是数组,要停止刷新
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [self.tableView.footer endRefreshing];
            return;
        }
        // 获得更多数据
        NSArray *more  = [XCNComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 添加进最新评论数组后面显示出来
        [weakSelf.latestComment addObjectsFromArray:more];
        // 刷新表格
        [self.tableView reloadData];
        // 判断当前最新评论数据是否加载完毕,加载完毕就隐藏刷新
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComment.count == total) {
            self.tableView.footer.hidden = YES;
        }else
        {
            // 停止刷新
            [self.tableView.footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        // 出现网络错误也要停止刷新
        [self.tableView.footer endRefreshing];
        
    }];

}


- (void)loadNewSource
{
    // 这是如果正在下上拉刷新就取消任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"hot"] = @"1";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.id;
    __weak typeof(self) weakSelf = self;
    [self.manager GET:XCNRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 如果没有评论数据,服务器返回的是数组,这时候会崩溃,这个时候不做刷新
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [self.tableView.header endRefreshing];
            return;
        }
        weakSelf.hotComment = [XCNComment objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        weakSelf.latestComment = [XCNComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 刷新表格
        [self.tableView reloadData];
        // 停止刷新
        [self.tableView.header endRefreshing];
        
        // 判断当前评论数据是否加载完毕,加载完毕隐藏刷新
        NSInteger total = [responseObject[@"total"] integerValue];
        if (self.latestComment.count == total) {
            self.tableView.footer.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        // 出现网络错误也要停止刷新
        [self.tableView.header endRefreshing];
        
    }];
}


#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 如果有最热评论,那么一定有最新评论
    if (self.hotComment.count) return 2;
    // 能来到这里说明没有最热评论
    if (self.latestComment.count) return 1;
    // 能来到这里说明没用评论
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 如果有最热评论,并且在第0组
    if (self.hotComment.count && section == 0) return self.hotComment.count;
    // 能来到这里说明没有最热评论
    return self.latestComment.count;
    
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XCNCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
    if (self.hotComment.count && indexPath.section == 0) {
        cell.comment = self.hotComment[indexPath.row];
    }else{
        cell.comment = self.latestComment[indexPath.row];
    }
    return cell;
}


/**
 *  设置headerView的内容
 *
 *  @param tableView 那个tableView
 *  @param section   哪一组
 *
 *  @return 返回设置的view
 */
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = XCNColor(206, 206, 206);
    // 创建label
    UILabel *label = [[UILabel alloc]init];
    
    label.font = [UIFont systemFontOfSize:14];
    label.x = 10;
    label.y = 0;
    label.width = 100;
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    label.textColor = [UIColor darkGrayColor];
    [headerView addSubview:label];
    if (self.hotComment.count && section == 0) {
       label.text = @"最热评论";
    }else{
        label.text = @"最新评论";
    }
    return headerView;
}
*/
// 或者这样也可以
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XCNCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    
    if (self.hotComment.count && section == 0) {
        headerView.text = @"最热评论";
    }else{
        headerView.text = @"最新评论";
    }
    return headerView;
}




#pragma mark - scrollView方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


@end
