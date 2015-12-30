//
//  XCNWebViewViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/11.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNWebViewViewController.h"

@interface XCNWebViewViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forWardBtn;

@end

@implementation XCNWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
- (IBAction)backClick {
    [self.webView goBack];
}
- (IBAction)forWardClick {
    [self.webView goForward];
}
- (IBAction)updateClick {
    [self.webView reload];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.backBtn.enabled = webView.canGoBack;
    self.forWardBtn.enabled = webView.canGoForward;
}


@end
