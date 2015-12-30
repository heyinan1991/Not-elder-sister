//
//  UIBarButtonItem+XCNExtension.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/9.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XCNExtension)
+ (instancetype)itemWithImage:(NSString *)image heightImage:(NSString *)heightImage action:(SEL)action target:(id)target;
@end
