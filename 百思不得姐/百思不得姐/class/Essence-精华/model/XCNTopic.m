//
//  XCNTopic.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/15.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "XCNTopic.h"
#import "XCNComment.h"
#import "XCNUser.h"
@implementation XCNTopic

- (NSString *)createdAt
{
    /*
     跟系统时间进行比较分:
     1.今年
     1>今天:
     1)大于一小时:2小时前
     2)小于一小时大于一分钟:多少分之前
     3)小于等于1分钟:刚刚
     2>昨天:昨天 12:13:14
     3>大于昨天:月-日 14:24:56
     2.非今年 --> 2014-02-13 17:22:13
     */
    // 当期时间
    NSDate *nowDate = [NSDate date];
    // 转换系统时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *createDate = [fmt dateFromString:_createdAt];
    
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获取年份
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:nowDate];
    NSInteger creatYear = [calendar component:NSCalendarUnitYear fromDate:createDate];
    // 判断年份是否一样
    if (nowYear == creatYear) {
        if ([calendar isDateInToday:createDate]) {//今天
            // 计算时差
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *com = [calendar components:unit fromDate:createDate toDate:nowDate options:kNilOptions];
            if (com.hour>=1) {//大于等于1一小时
                return [NSString stringWithFormat:@"%zd小时前",com.hour];
            }else if (com.minute>=1){//大于一分钟
                return [NSString stringWithFormat:@"%zd分钟前",com.minute];
            }else{
                return @"刚刚";
            }
        }else if ([calendar isDateInYesterday:createDate]){ // 昨天
            fmt.dateFormat = @"HH:mm:ss";
            return [NSString stringWithFormat:@"昨天 %@",[fmt stringFromDate:createDate]];
        }else{
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createDate];
        }
    }else{
        return _createdAt;
    }
    return nil;
}

/**
 *  在这个方法里面同时计算了中间内容的frame和cell的高度
 *
 *  @return cell的高度
 */
- (CGFloat)cellHeight
{
    // 如否计算过cell的高度,就直接返回cell的高度
    if (_cellHeight) return _cellHeight;
    // 文字的Y值
    CGFloat textY = 55;
    CGFloat textMaxW = [UIScreen mainScreen].bounds.size.width - 2 * XCNMargin;
    // 文字的高度
    CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    _cellHeight = textY + textH + XCNMargin;
    // 如中间有内容
    if (self.type != XCNTopicTypeWord) {
        // 中间内容的x值
        CGFloat centerViewX = XCNMargin;
        // 中间内容的Y值
        CGFloat centerViewY = textY + textH + XCNMargin;
        // 中间内容的宽度
        CGFloat centerViewW = textMaxW;
        // 中间内容的高度
        CGFloat centerViewH = self.height * centerViewW / self.width;
        if (centerViewH>[UIScreen mainScreen].bounds.size.height) {
            centerViewH = 200;
            self.isBigPic = YES;
        }
        // 中间内容的frame
        _centerViewFrame = CGRectMake(centerViewX, centerViewY, centerViewW, centerViewH);
        
        _cellHeight += self.centerViewFrame.size.height + XCNMargin;
    }
    // 如果有最热评论
    if (self.top_cmt) {
        CGFloat hotCommentTitleH = 18;
        NSString *hotConent = [NSString stringWithFormat:@"%@:%@",self.top_cmt.user.username,self.top_cmt.content];
        // 评论内容的最大宽度
        CGFloat hotConentMaxW = [UIScreen mainScreen].bounds.size.width - 2*XCNMargin;
        // 评论内容的size
        CGSize hotSize = CGSizeMake(hotConentMaxW, MAXFLOAT);
        
        // 最热评论内容的高度
        CGFloat hotConentH = [hotConent boundingRectWithSize:hotSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        // 最热评论情况下得高度
        _cellHeight += hotCommentTitleH + hotConentH + XCNMargin;
        
    }
    // 底部tabBar的高度
    CGFloat tabBarH = 35;
    // 因为底部我们设置了分割线,但是分割线是我们让cell高度-XCNMargin的结果,所以要加上
    
    _cellHeight += tabBarH + XCNMargin;
//    XCNLog(@"%f",_cellHeight);
    return _cellHeight;
}

@end
