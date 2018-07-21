//
//  NSString+Extension.m
//  DDPuzzle
//
//  Created by duodian on 2018/6/28.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (NSInteger)fileSize
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 1.先判断是否存在
    BOOL isDirectory = NO;
    BOOL exist = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    // 文件不存在
    if (exist == NO) return 0;
    
    // 2.先判断类型（文件夹\文件）
    if (isDirectory) { // 文件夹
        NSInteger size = 0;
        
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        for (NSString *subpath in enumerator) {
            // 获得文件的全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            
            // 获得属性
            NSDictionary *attrs = [mgr attributesOfItemAtPath:fullSubpath error:nil];
            // 过滤掉文件夹
            if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
            
            size += [attrs[NSFileSize] integerValue];
        }
        
        return size;
    }
    
    // 3.文件
    return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
}

- (NSString *)fileSizeString
{
    NSInteger fileSize = self.fileSize;
    CGFloat unit = 1000.0;
    
    if (fileSize >= unit * unit * unit) { // fileSize >= 1GB
        return [NSString stringWithFormat:@"%.1fGB", fileSize/(unit * unit * unit)];
    } else if (fileSize >= unit * unit) { // 1GB > fileSize >= 1MB
        return [NSString stringWithFormat:@"%.1fMB", fileSize/(unit * unit)];
    } else if (fileSize >= unit) { // 1MB > fileSize >= 1KB
        return [NSString stringWithFormat:@"%.1fKB", fileSize/ unit];
    } else { // 1KB > fileSize
        return [NSString stringWithFormat:@"%zdB", fileSize];
    }
}

+ (NSString *)getLocalAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getBundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)getPhoneVersion {
    return [[UIDevice currentDevice] systemVersion];
}

@end
