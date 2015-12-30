//
//  XCNPostWordViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/29.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNPostWordViewController.h"
#import "XCNPlaceHolderTextView.h"
#import "XCNPostWordToolBar.h"
@interface XCNPostWordViewController ()<UITextViewDelegate>
/** 占位文字 */
@property(nonatomic, weak) XCNPlaceHolderTextView *textView;
/** 工具条 */
@property(nonatomic, weak) XCNPostWordToolBar *toolBar;

@end

@implementation XCNPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置Nav
    [self setUpNav];
    
    // 占位的textView
    [self setUpTextView];
    
    // 设置工具条
    [self setUpTabBar];
    
}
#pragma mark - 初始化设置
- (void)setUpTabBar
{
    XCNPostWordToolBar *toolBar = [XCNPostWordToolBar postWordToolBar];
    toolBar.x = 0;
    toolBar.y = self.view.height - toolBar.height;
    toolBar.width = self.view.width;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 监听键盘改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyBoardDidChange:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        // 工具条平移的距离 = 屏幕高度-工具条的y值
        CGFloat transationY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - XCNScreenH;
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, transationY);
//        XCNLog(@"%f",transationY);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setUpNav
{
    self.title = @"发表评论";
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancleClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 强制更新(能马上更新现在的状态)
    [self.navigationController.navigationBar layoutIfNeeded];
}
- (void)setUpTextView
{
    /*
     UITextField:有占位文字,但是最多只能输入一行文字
     UITextView:没有占位文字,能输入人一行文字
     需要:有占位文字,也能输入任意行文字-->继承自UITextView的自定义类
     */
    XCNPlaceHolderTextView *textView = [[XCNPlaceHolderTextView alloc]init];
    textView.frame = self.view.bounds;
    // 不管有多少内容,竖直方向永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理";
    
    [self.view addSubview:textView];
    self.textView = textView;
}

#pragma mark - 按钮监听

- (void)post
{
    XCNFuc;
}


- (void)cancleClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  拖拽键盘退下
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

@end
