//
//  NSObject+Model.m
//  FindDifferent
//
//  Created by duodian on 2018/4/24.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "NSObject+Model.h"

@implementation NSObject (Model)
- (id)initWithDict:(NSDictionary *)dict{
    if (self = [self init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (id)modelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
