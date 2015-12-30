//
//  XCNTagTextField.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/11/2.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNTagTextField.h"

@implementation XCNTagTextField

- (void)deleteBackward
{
    if (self.keyBoardDelegateBlcok) {
        self.keyBoardDelegateBlcok();
    }
    [super deleteBackward];
}

@end
