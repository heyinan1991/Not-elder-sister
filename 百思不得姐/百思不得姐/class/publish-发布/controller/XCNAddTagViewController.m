//
//  XCNAddTagViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/30.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNAddTagViewController.h"
#import "XCNTagButton.h"
#import "XCNTagTextField.h"
@interface XCNAddTagViewController ()<UITextFieldDelegate>
/** 标签容器 */
@property(nonatomic, weak) UIView *contentView;
/** 文本框 */
@property(nonatomic, weak) UITextField *textField;
/** 提醒按钮 */
@property(nonatomic, weak) UIButton *tipButton;
/** 标签按钮数组 */
@property(nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation XCNAddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置Nav
    [self setUpNav];
    // 添加contentView
    [self setupContentView];
    // 添加标签
    [self setUpTextField];
    
}
#pragma mark - 懒加载
- (UIButton *)tipButton
{
    if (!_tipButton) {
        UIButton *tipButton = [[UIButton alloc]init];
        tipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [tipButton addTarget:self action:@selector(tipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        tipButton.backgroundColor = XCNTagBgColor;
        tipButton.x = 0;
        tipButton.width = self.contentView.width;
        tipButton.height = 25;
        // 设置按钮内部文字靠右左显示
        tipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 左边设置一定边距
        tipButton.contentEdgeInsets = UIEdgeInsetsMake(0, XCNSmallMargin, 0, 0);
        [self.contentView addSubview:tipButton];
        _tipButton = tipButton;
    }
    return _tipButton;
}

- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

#pragma mark - 初始化
- (void)setupContentView
{
    UIView *contentView = [[UIView alloc]init];
    contentView.x = XCNSmallMargin;
    contentView.y = XCNTopMargin + XCNSmallMargin;
    contentView.width = XCNScreenW - 2*contentView.x;
    contentView.height = XCNScreenH;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setUpTextField
{
    XCNTagTextField *textField = [[XCNTagTextField alloc]init];
    textField.delegate = self;
    // 监听文本框的改变
    [textField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    // 高度,宽度
    textField.width = self.contentView.width;
    textField.height = 25;
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    textField.placeholderColor = [UIColor darkGrayColor];
    textField.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:textField];
    [textField becomeFirstResponder];
    // 刷新前提是:这个控件已经被添加到父控件中
    [textField layoutIfNeeded];
    self.textField = textField;
    // 设置点击删除键需要做的操作
    textField.keyBoardDelegateBlcok = ^{
        // 如果有文字就执行正常的操作不执行删除标签的操作
        if (self.textField.hasText) return;
        // 相当于点击按钮删除最后一个标签按钮
        [self tagClick:self.tagButtons.lastObject];
    };
}


- (void)setUpNav
{
    self.title = @"发表评论";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancleClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(success)];
}



#pragma mark - 按钮点击监听
/**
 *  监听提醒按钮的点击
 */
- (void)tipButtonClick
{
    if (self.textField.hasText == NO) return;
    // 添加标签按钮
    XCNTagButton *newTagButton = [[XCNTagButton alloc]init];
    // 设置文字,重写了setTitle:方法,自动适配标签按钮的高度,宽度,间距
    [newTagButton setTitle:self.textField.text forState:UIControlStateNormal];
    // 添加点击事件
    [newTagButton addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:newTagButton];
    // 排布按钮
    [self arrangeButton:newTagButton referenceTagButton:self.tagButtons.lastObject];
   
    // 隐藏提示按钮
    self.tipButton.hidden = YES;
    // 清空输入的文字
    self.textField.text = nil;
    // 添加到数组中
    [self.tagButtons addObject:newTagButton];
    
    // 排布文本框:要先将新按钮添加进数组中,不然调用下面的方法.数组里面还没有元素,取出来的是空,那么添加第一个按钮时,占位文字不会正常显示
    [self arrangeTextField];   
    
}

/**
 *  监听文本框改变
 */
- (void)textChange
{
    // 添加提醒按钮--设置Y值和显隐性
    if (self.textField.hasText) {
        // 当有逗号时需要换行
        NSString *lastChar = [self.textField.text substringFromIndex:self.textField.text.length - 1];
        if ([lastChar isEqualToString:@","]||[lastChar isEqualToString:@"，"]) {//中文和英文状态下的逗号
            // 截取字符串
            self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
            // 这个时候调用这个方法相当于点击了提醒按钮
            [self tipButtonClick];
        }else{
            // 排布文本框(当输入文字大于右边剩余宽度时换行)
            // 首先算出文字宽度
            [self arrangeTextField];
        }
        
       self.tipButton.hidden = NO;
       self.tipButton.y = CGRectGetMaxY(self.textField.frame) + XCNSmallMargin;
        [self.tipButton setTitle:[NSString stringWithFormat:@"添加标签:%@",self.textField.text] forState:UIControlStateNormal];
    }else{
        self.tipButton.hidden = YES;
    }
    
    
}
/**
 *  标签按钮的点击,删除标签按钮
 *
 *  @param tabButton 点击了哪一个标签按钮
 */
- (void)tagClick:(XCNTagButton *)clickTagButton
{
    // 取出点击的标签按钮
    NSInteger index = [self.tagButtons indexOfObject:clickTagButton];
    // 删除
    [clickTagButton removeFromSuperview];
    
    // 从数组删除
    [self.tagButtons removeObject:clickTagButton];
    //遍历删除按钮后面的按钮
    for (NSInteger i = index; i<self.tagButtons.count; i++) {
        // 被删除的按钮
        XCNTagButton *tagButton = self.tagButtons[i];
        // 被删除的按钮的上一个按钮
        XCNTagButton *previousTagButton = (i==0) ? nil :self.tagButtons[i-1];
        // 排布按钮
        [self arrangeButton:tagButton referenceTagButton:previousTagButton];
    }
    
    // 重新排布文本和提示框
    [self arrangeTextField];
    
}

/**
 *  排布目标按钮的位置
 *
 *  @param tagButton    目标按钮
 *  @param referenceBtn 对比的按钮
 */
- (void)arrangeButton:(XCNTagButton *)tagButton referenceTagButton:(XCNTagButton *)referenceBtn
{
    if (referenceBtn==nil) {// 是第一个按钮
        tagButton.x = 0;
        tagButton.y = 0;
    }else{//不是第一个按钮
        // 2中情况:1.被删按钮后面的按钮宽度大于剩余宽度,2.被删按钮后面按钮宽度小于剩余宽度
        CGFloat leftWidth = CGRectGetMaxX(referenceBtn.frame) + XCNSmallMargin;
        CGFloat rightWidth = self.contentView.width - leftWidth;
        if (rightWidth>=tagButton.width) {//按钮宽度<剩余宽度
            tagButton.x = leftWidth;
            tagButton.y = referenceBtn.y;
        }else{//宽度>剩余宽度
            tagButton.x = 0;
            tagButton.y = CGRectGetMaxY(referenceBtn.frame)  +XCNSmallMargin;
        }
    }

}

/**
 *  重新排布文本和提示框
 */
- (void)arrangeTextField
{
    // 计算出来文字所占的大小
     CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName:self.textField.font}].width;
    // 重新排布文本
    XCNTagButton *lastButton = self.tagButtons.lastObject;
    CGFloat leftWidth =CGRectGetMaxX(lastButton.frame) + XCNSmallMargin;
    CGFloat rightWidth = self.contentView.width - leftWidth;
    textW = MAX(100, textW);
    if (rightWidth>=textW) {// 同一行
        self.textField.x = leftWidth;
        self.textField.y = lastButton.y;
    }else{//不同行
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastButton.frame) +XCNSmallMargin;
    }
    
    //重新排布提示框
    self.tipButton.y = CGRectGetMaxY(lastButton.frame)+ XCNSmallMargin;
}

/**
 *  成功按钮监听
 */
- (void)success
{
    XCNFuc;
}
/**
 *  取消按钮监听
 */
- (void)cancleClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self tipButtonClick];
    return YES;
}

@end
