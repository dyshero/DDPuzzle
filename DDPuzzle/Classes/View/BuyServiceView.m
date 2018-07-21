//
//  BuyServiceView.m
//  DDPuzzle
//
//  Created by duodian on 2018/6/28.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "BuyServiceView.h"

@interface BuyServiceView()
@end

@implementation BuyServiceView

- (void)serviceBtnClicked:(TYFWaveButton *)sender {
    if (self.serviceBtnBlock) {
        self.serviceBtnBlock(sender.tag);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 22)];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont systemFontOfSize:17];
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"说明";
    [self addSubview:topLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topLabel.frame) + 30, self.width, 22)];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = [UIFont systemFontOfSize:14];
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.text = @"付费之后可以自动完成所有游戏";
    [self addSubview:bottomLabel];
    
    _buyBtn = [self configBtnWithFrame:CGRectMake(0, CGRectGetMaxY(bottomLabel.frame) + 40, 120, 30) title:@"确定购买" tag:1];
    [self addSubview:_buyBtn];
    
    _resetBtn = [self configBtnWithFrame:CGRectMake(0, CGRectGetMaxY(_buyBtn.frame) + 10, 120, 30) title:@"恢复购买" tag:2];
    [self addSubview:_resetBtn];
    
    _cancelBtn = [self configBtnWithFrame:CGRectMake(0, CGRectGetMaxY(_resetBtn.frame) + 10, 120, 30) title:@"取消" tag:3];
    [self addSubview:_cancelBtn];
}

- (TYFWaveButton *)configBtnWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    TYFWaveButton *btn = [TYFWaveButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = frame;
    btn.tag = tag;
    btn.centerX = self.centerX;
    [btn addTarget:self action:@selector(serviceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 15;
    btn.clipsToBounds = YES;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1;
    return btn;
}


@end
