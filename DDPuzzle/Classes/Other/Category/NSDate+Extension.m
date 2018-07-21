//
//  NSDate+Extension.m
//  Puzzle
//
//  Created by duodian on 2018/6/13.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
+ (NSString *)currentDateStr {
    NSDate *current = [self date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd";
    return [formatter stringFromDate:current];
}
@end
