//
//  LevelCell.m
//  Puzzle
//
//  Created by duodian on 2018/6/1.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "LevelCell.h"
#import "LevelModel.h"

@interface LevelCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidthConstaint;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@end

@implementation LevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _leftConstraint.constant = kScreenWidth*0.1;
    _rightConstraint.constant = kScreenWidth*0.05;
}

- (void)setModel:(LevelModel *)model {
    _titLabel.text = model.name;
    _iconImg.image = [UIImage imageNamed:model.icon];
    if ([model.isPass integerValue] == 0) { // 未通过
        _iconImg.image = [UIImage imageNamed:@"lock"];
        _imgWidthConstaint.constant = 40;
    } else {
        _iconImg.image = [UIImage imageNamed:model.icon];
        _imgWidthConstaint.constant = 60;
    }
}
@end
