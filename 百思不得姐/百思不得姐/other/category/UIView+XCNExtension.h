//
//  UIView+XCNExtension.h
//  baisibudejie
//
//  Created by xuchuangnan on 15/10/4.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XCNExtension)
@property(nonatomic,assign) CGFloat x;
@property(nonatomic,assign) CGFloat y;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,assign) CGFloat centerX;
@property(nonatomic,assign) CGFloat centerY;

/** 控件最左边那根线的位置 */
@property(nonatomic, assign) CGFloat left;

/** 控件最顶部那根线的位置 */
@property(nonatomic, assign) CGFloat top;
/** 控件最右边那根线的位置 */
@property(nonatomic, assign) CGFloat right;
/** 控件最下边那根线的位置 */
@property(nonatomic, assign) CGFloat bottom;

@end
