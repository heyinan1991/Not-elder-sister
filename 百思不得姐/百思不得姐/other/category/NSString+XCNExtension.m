//
//  NSString+XCNExtension.m
//  百思不得姐
//
//  Created by xuchuangnan on 15/10/12.
//  Copyright © 2015年 xuchuangnan. All rights reserved.
//

#import "NSString+XCNExtension.h"

@implementation NSString (XCNExtension)
- (unsigned long long)fileSize
{
    // 文件管理者
    NSFileManager *manager = [NSFileManager defaultManager];
    // 是否为文件夹
    BOOL isDirectory = NO;
    // 先判断路径的存在性
    BOOL exists = [manager fileExistsAtPath:self isDirectory:&isDirectory];
    
    // 路径不存在直接返回
    if (exists == NO) return 0;
    if (isDirectory) {
        // 文件总大小
        unsigned long long fileSize = 0;
        // 遍历所有文件
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 完整路径
            NSString *fullPath = [self stringByAppendingPathComponent:subpath];
            fileSize +=[manager attributesOfItemAtPath:fullPath error:nil].fileSize;
        }
        return fileSize;
    }
    
    // 如果是文件,直接计算返回大小
    return [manager attributesOfItemAtPath:self error:nil].fileSize;
    
}
@end
