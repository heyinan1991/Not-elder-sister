//
//  XCNPlaceHolderTextView.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/29.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCNPlaceHolderTextView : UITextView
/** 占位文字 */
@property(nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property(nonatomic, weak) UIColor *placeholderColor;
@end
