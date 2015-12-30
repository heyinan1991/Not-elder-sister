//
//  XCNTagTextField.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/11/2.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCNTagTextField : UITextField

/** 键盘删除block */
@property(nonatomic, copy) void(^keyBoardDelegateBlcok)();


@end
