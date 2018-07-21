//
//  LinkView.m
//  WARFRAME
//
//  Created by CarMayor on 2018/1/6.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import "LoadingGameView.h"

#import "HFParticleSearchAnimateView.h"

typedef void(^CompleteBlock)(NSString *str);

@interface LoadingGameView ()

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIView *loadingPicView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingPic;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (nonatomic, strong) HFParticleSearchAnimateView *animateView;
@property (nonatomic, copy) CompleteBlock completeBlock;
@end

@implementation LoadingGameView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.loadingView.hidden = YES;
    
    
    self.backgroundColor = [UIColor colorWithHexString:@"222222"];
    self.loadingLabel.textColor = [UIColor whiteColor];
//    self.loadingLabel.font = [UIFont systemFontOfSize:FONT_SIZE_4];
//
//    self.line1.backgroundColor = self.line2.backgroundColor = [APPUtils modeLineColor];
    
    self.loadingPic.layer.masksToBounds = NO;
    self.loadingPic.clipsToBounds = NO;
//    self.loadingPic.layer.shadowColor = [APPUtils getThemeColor].CGColor;
    self.loadingPic.layer.shadowRadius = 2;
    self.loadingPic.layer.shadowOpacity = 0.48;
    self.loadingPic.layer.shadowOffset = CGSizeMake(0, 1);
    
}

+ (void)showLoadingViewWithPic:(NSString *)pic color:(NSString *)color complete:(void (^)(NSString *))completeBlock {
    
    LoadingGameView *loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingGameView" owner:nil options:nil] lastObject];
    loadingView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    loadingView.completeBlock = completeBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:loadingView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:loadingView];
    
    [loadingView showAnimationColor:color];
}

- (void)showAnimationColor:(NSString *)color {
    
    self.loadingView.hidden = NO;
    self.loadingView.alpha = 0.f;
    [self.animateView startAnimationWithColor:color];
    
    [UIView animateWithDuration:0.48 animations:^{
        
        self.loadingView.alpha = 1.f;
        
    } completion:^(BOOL finished) {
        
        self.loadingLabel.hidden = NO;

        self.loadingLabel.text = @"建立游戏场景";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.loadingLabel.text = @"正在进入";

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.animateView endAnimation];

                if (self.completeBlock) {
                    self.completeBlock(@"");
                }
                [UIView animateWithDuration:0.72 delay:0.16 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.alpha = 0.f;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
                
            });
        });
        
    }];

}

- (HFParticleSearchAnimateView *)animateView {
    if (_animateView == nil) {
        _animateView = [[HFParticleSearchAnimateView alloc] initWithFrame:self.loadingPicView.bounds];
        [self.loadingPicView addSubview:_animateView];
    }
    return _animateView;
}

@end
