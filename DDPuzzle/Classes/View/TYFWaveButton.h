//
//  TYFWaveButton.h
//
//
//  Created by ai r on 2017/12/15.
//  Copyright © 2017年 水波按钮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYFWaveButton : UIButton

//一次点击出现的水波个数
@property (nonatomic, assign) NSInteger numberofwave;

//一次点击多个水波下每条水波间隔时间
@property (nonatomic, assign) CGFloat intervaltimeofwave;

//每个水波持续时间
@property (nonatomic, assign) CGFloat timeofwave;

//水波开始半径(0表示从圆心开始扩散,默认为0)
@property (nonatomic, assign) CGFloat radiusofWaveStart;

//水波结束半径
@property (nonatomic, assign) CGFloat radiusofWaveEnd;

//水波颜色
@property (nonatomic, strong) UIColor *colorofwave;

//水波圆心始终在按钮正中(如果为No,圆心会在点击的位置)
@property (nonatomic, assign) BOOL onlycenter;

//水波圆心(默认为正中)
@property (nonatomic, assign) CGPoint centerofcircle;

@end
