//
//  XCNMeFooterView.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/11.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNMeFooterView.h"
#import <MJExtension/MJExtension.h>
#import "XCNMeSquare.h"
#import "XCNMeSquareButton.h"
#import "XCNWebViewViewController.h"
@implementation XCNMeFooterView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 发送网络请求
        // 请求数据
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        __weak typeof(self) weakSelf = self;
        [[XCNHTTPSessionManager manager] GET:XCNRequestURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            XCNWriteToPlist(responseObject, responseObject);
            // 字典数组转模型
            NSArray *meSquare = [XCNMeSquare objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            // 根据模型创建九宫格
            [weakSelf creatSquare:meSquare];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    return self;
}

- (void)creatSquare:(NSArray *)square
{
    // 列数
    NSInteger count = 4;
    // 宽度
    CGFloat buttonW = self.width/count;
    CGFloat buttonH = buttonW;
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    // 添加按钮九宫格
    for (NSInteger i = 0 ; i<square.count; i++) {
        XCNMeSquareButton *btn = [XCNMeSquareButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        // 计算按钮frame
        
        buttonX = (i%count)*buttonW;
        buttonY = (i/count)*buttonH;
        
        
        // 设置btn的frame
        // 这里设置宽高-1是为了设置分割线
        // 或者设置footerView背景为白色,然后设置按钮带灰色边框的图片
        // btn.frame = CGRectMake(buttonX, buttonY, buttonW-1, buttonH-1);
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        btn.square = square[i];
    }
    // 设置footerview的高度
    // 这样设置footerView的高度,会出现上拉拉不到底的问题,这是因为设置高度晚了
    self.height = self.subviews.lastObject.bottom;
    // 重新设置
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
    // 设置contenSize,防止拖动底部留有间隙
    tableView.contentSize = CGSizeMake(0, self.bottom);
    
//    // 或者footerView的高度也可以这样设置
//    // 总共的行数*按钮高度
//    // 计算总得行数=(总个数+每行最大个数-1)/每行最大个数
//    NSInteger rowCount = (square.count+count)/count;
//    self.height = rowCount*buttonH;
//    UITableView *tableView = (UITableView *)self.superview;
//    tableView.tableFooterView = self;
    // 设置contenSize,防止拖动底部留有间隙
//    tableView.contentSize = CGSizeMake(0, self.bottom);
}

- (void)btnClick:(XCNMeSquareButton *)button
{
    XCNLog(@"%@,%@",button.square.name,button.square.url);
    NSString *url = button.square.url;
    // 分情况处理
    if ([url hasPrefix:@"mod://"]) {
        XCNLog(@"跳转到mod控制器");
    }else if ([url hasSuffix:@"App_To_SearchUser"]){
        XCNLog(@"跳转打牌search控制器");
    }else if ([url hasPrefix:@"http://"]){
        XCNWebViewViewController *web = [[XCNWebViewViewController alloc]init];
        web.url = button.square.url;
        // 接下来要push到下一个控制器了,但是当钱不是控制器,也没有导航控制器push不了,也modal不了,这个时候就要拿到当前控制器的导航控制器
        // 先拿到导航控制器的根控制器
        UITabBarController *root = (UITabBarController*)self.window.rootViewController;
        // 既然要操作当前界面的按钮,那么当前选中的一定是"我"这个控制器的导航控制器
        UINavigationController *nav = root.selectedViewController;
        [nav pushViewController:web animated:YES];
    }
}

@end
