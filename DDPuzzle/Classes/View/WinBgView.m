//
//  WinBgView.m
//  Puzzle
//
//  Created by duodian on 2018/6/14.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "WinBgView.h"

@interface WinBgView()
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageVie;

@end

@implementation WinBgView
- (void)awakeFromNib {
    [super awakeFromNib];
//    _scoreLabel.alpha = 0;
    _logoView.transform = CGAffineTransformMakeScale(4,4);
    [UIView animateWithDuration:0.2 animations:^{
        _logoView.transform = CGAffineTransformMakeScale(0.5,0.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _logoView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
//                _scoreLabel.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgImageVie.image = _originImage;
}

- (IBAction)knowClicked:(id)sender {
    if (self.knowBlock) {
        self.knowBlock();
    }
}

- (IBAction)saveClicked:(id)sender {
    if (self.saveBlock) {
        self.saveBlock();
    }
}


@end
