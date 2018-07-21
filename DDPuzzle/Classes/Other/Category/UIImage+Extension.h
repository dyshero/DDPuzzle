//
//  UIImage+Extension.h
//  Puzzle
//
//  Created by duodian on 2018/5/31.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
- (NSArray *)createSubImageWithCount:(NSInteger)count;
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
@end
