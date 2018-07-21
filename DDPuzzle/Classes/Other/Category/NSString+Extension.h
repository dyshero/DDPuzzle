//
//  NSString+Extension.h
//  DDPuzzle
//
//  Created by duodian on 2018/6/28.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (NSInteger)fileSize;
/**
 *  获得文件大小（18.7GB\10.9MB）
 *
 *  @return 获得字符串形式的文件大小
 */
- (NSString *)fileSizeString;

+ (NSString *)getLocalAppVersion;
+ (NSString *)getBundleID;
+ (NSString *)getBuildVersion;
+ (NSString *)getPhoneVersion;
@end
