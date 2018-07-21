//
//  UIView+Extension.m
//  Puzzle
//
//  Created by duodian on 2018/5/31.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (NSMutableArray *)showWithImages:(NSArray *)images andOptionSel:(SEL)sel andContex:(id)contex {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *centers = [NSMutableArray array];
    
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width*0.8;
    CGFloat viewH = [UIScreen mainScreen].bounds.size.width*0.8;
    NSInteger count = images.count;
    int column = sqrt(count);
    
    CGFloat btnW = viewW / column;
    CGFloat btnH = viewH / column;
    
    for (int i = 0 ;i < count; ++i) {
        CGFloat btnX = (i % column) * btnW;
        CGFloat btnY = (i / column) * btnH;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setBackgroundImage:images[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:contex action:sel forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = [[UIColor blackColor] CGColor];
        btn.layer.borderWidth = 0.3;
        if (i != count - 1) {
            [self addSubview:btn];
        }
        [centers addObject:NSStringFromCGPoint(btn.center)];
    }
    return centers;
}
@end
