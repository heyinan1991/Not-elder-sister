//
//  XCNPublishViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/29.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNPublishViewController.h"
#import "XCNPublishButton.h"
#import "XCNPostWordViewController.h"
#import <POP.h>
@interface XCNPublishViewController ()
/** 动画时间数组 */
@property(nonatomic, strong) NSArray *times;
/**  按钮数组 */
@property(nonatomic, strong) NSMutableArray *buttons;
/** solgan */
@property(nonatomic, weak) UIImageView *solganView;
@end

@implementation XCNPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = NO;
    
    // 添加按钮
    [self addButton];
    // 添加solgan
    [self addSolgan];
}
#pragma mark - 懒加载
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSArray *)times
{
    if (!_times) {
        // 时间间隔
        CGFloat timeInterval = 0.1;
        // 各个按钮的动画时间
        _times = @[@(5*timeInterval),
                   @(4*timeInterval),
                   @(2*timeInterval),
                   @(0*timeInterval),
                   @(3*timeInterval),
                   @(1*timeInterval),
                   @(6*timeInterval)
                   ];
    }
    return _times;
}
#pragma mark - 添加子控件以及动画
/**
 *  添加solgan
 */
- (void)addSolgan
{
    UIImageView *solgan = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
    solgan.centerX = XCNScreenW*0.5;
    solgan.y = -XCNScreenH;
    [self.view addSubview:solgan];
    self.solganView = solgan;
    // 添加动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(XCNScreenH*0.2);
    // 弹簧系数
    anim.springBounciness = 10;
    anim.springSpeed = 5;
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    // 动画完成界面可交互
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.view.userInteractionEnabled = YES;
    }];
    [solgan.layer pop_addAnimation:anim forKey:nil];
}

- (void)addButton
{
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    // 要添加按钮的个数
    NSInteger count = images.count;
    // 一行的列数
    NSInteger maxColsCount = 3;
    // 算出多少行
    NSInteger rowCount = (count + maxColsCount-1)/maxColsCount;
    // 按钮宽高
    CGFloat buttonW = XCNScreenW/maxColsCount;
    CGFloat buttonH = buttonW*0.9;
    // 按钮初始的y值
    CGFloat buttonStartY = (XCNScreenH - rowCount*buttonH)*0.5;
    // 添加按钮
    for (NSInteger i = 0; i<count; i++) {
        XCNPublishButton *btn = [[XCNPublishButton alloc]init];
        btn.y = - XCNScreenH;
        [self.view addSubview:btn];
        [self.buttons addObject:btn];
        
        // 图片
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        // 文字
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        // 添加点击事件
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 添加动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        CGFloat buttonX = (i%maxColsCount)*buttonW;
        CGFloat buttonY = buttonStartY + (i/maxColsCount)*buttonH;
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY-XCNScreenH, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        // 弹簧系数
        anim.springSpeed = 5;
        anim.springBounciness = 10;
        anim.beginTime = CACurrentMediaTime() +  [self.times[i] doubleValue];
        [btn pop_addAnimation:anim forKey:nil]
        ;
    }
}

#pragma mark - 点击事件
- (void)exit:(void(^)())block
{
    self.view.userInteractionEnabled = NO;
    // 按钮消失动画
    for (int i = 0; i<self.buttons.count; i++) {
        XCNPublishButton *btn = self.buttons[i];
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        anim.toValue = @(btn.layer.position.y +XCNScreenH);
        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        [btn.layer pop_addAnimation:anim forKey:nil];
    }
    
    // solgan
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(self.solganView.layer.position.y + XCNScreenH);
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [self.solganView.layer pop_addAnimation:anim forKey:nil];
    // 执行完solgan动画dismiss控制器
    [anim setCompletionBlock:^(POPAnimation *anim , BOOL finished) {
        // dismiss了在执行block
        [self dismissViewControllerAnimated:NO completion:nil];
        // 如果block实现了才执行
        if (block) block();
    }];

}


/**
 *  点击取消按钮dismiss
 */
- (IBAction)cancel{
    [self exit:nil];
}

- (void)buttonClick:(XCNPublishButton *)button
{
    [self exit:^{
        NSInteger index = [self.buttons indexOfObject:button];
        switch (index) {
            case 2:
            {
                XCNPostWordViewController *post = [[XCNPostWordViewController alloc]init];
                [self.view.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:post] animated:YES completion:nil];
            }
                break;
            case 0:
                XCNLog(@"点击了第一个按钮");
                break;
            case 1:
                XCNLog(@"点击了第2个按钮");
                break;
            case 3:
                XCNLog(@"点击了第4个按钮");
                break;
            case 4:
                XCNLog(@"点击了第5个按钮");
                break;
            case 5:
                XCNLog(@"点击了第6个按钮");
                break;
            default:
                break;
        }
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancel];
}

@end
