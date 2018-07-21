//
//  CommonTool.h
//  Puzzle
//
//  Created by duodian on 2018/6/27.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject
+ (void)replaceVC:(UINavigationController*)navigationController fromVc:(UIViewController*)fromVc toVc:(UIViewController*)toVc;
+ (BOOL)isGame;
@end
