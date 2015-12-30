//
//  UIImage+XCNExtension.h
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/10.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XCNExtension)
/** 圆角图片*/
- (instancetype)circleImage;
+ (instancetype)cirlceImageName:(NSString *)name;
@end
