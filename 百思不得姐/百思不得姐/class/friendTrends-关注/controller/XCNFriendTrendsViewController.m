//
//  XCNFriendTrendsViewController.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/9.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNFriendTrendsViewController.h"
#import "XCNRecommendFollowViewController.h"
@interface XCNFriendTrendsViewController ()


@end

@implementation XCNFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = XCNColor(206, 206, 206);
    // 设置作标签
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" heightImage:@"friendsRecommentIcon-click" action:@selector(friendTrendClick) target:self];
}



- (void)friendTrendClick {
    [self performSegueWithIdentifier:@"FriendTrends2RecommendFollow" sender:nil];
}
- (IBAction)backToChildViewController:(UIStoryboardSegue *)segue
{
    
}


@end
