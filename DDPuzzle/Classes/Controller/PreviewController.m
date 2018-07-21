//
//  PreviewController.m
//  Puzzle
//
//  Created by duodian on 2018/6/26.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "PreviewController.h"
#import "RSKImageCropper.h"
#import "DDPuzzle-Swift.h"
#import "GameCenterController.h"
#import "CommonTool.h"
#import "LoadingGameView.h"
#import <AVFoundation/AVFoundation.h>

@interface PreviewController ()<RSKImageCropViewControllerDelegate,AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;
@property (nonatomic,assign) BOOL isHiddenBtm;
@property (nonatomic,strong) UIImageView *homeImageView;
@property (nonatomic,strong) UIImageView *lockImageView;
@property (nonatomic,weak) RSKImageCropViewController *imageCropVC;
@property (nonatomic,strong) AVAudioPlayer *circlePlayer;
@property (nonatomic,assign) BOOL isCompleteGame;
@end

@implementation PreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    _bottomView.hidden = YES;
    _bottomHeightConstraint.constant = 10 + 32 + 10 + kSafeAreaBottom;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    [self.view addSubview:activityIndicator];
    activityIndicator.frame= CGRectMake(0, 0, 100, 100);
    activityIndicator.center = self.view.center;
    [activityIndicator startAnimating];
    
    [_imageView setImageWithURL:[NSURL URLWithString:_url] placeholder:nil options:YYWebImageOptionUseNSURLCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD showInfoWithStatus:@"加载失败"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            _bottomView.hidden = NO;
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.15 animations:^{
            if (!_isHiddenBtm) {
                _bottomView.layer.transform = CATransform3DMakeTranslation(0, _bottomHeightConstraint.constant, 0);
            } else {
                _bottomView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
            }
        } completion:^(BOOL finished) {
            _isHiddenBtm = !_isHiddenBtm;
        }];
    }];
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}


- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)homeClicked:(id)sender {
    [self.view addSubview:self.homeImageView];
    [UIView animateWithDuration:0.15 animations:^{
        self.homeImageView.frame = [UIScreen mainScreen].bounds;
        _bottomView.layer.transform = CATransform3DMakeTranslation(0, _bottomHeightConstraint.constant, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)lockClicked:(id)sender {
    [self.view addSubview:self.lockImageView];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    [UIView animateWithDuration:0.15 animations:^{
        self.lockImageView.frame = [UIScreen mainScreen].bounds;
        _bottomView.layer.transform = CATransform3DMakeTranslation(0, _bottomHeightConstraint.constant, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)downloadClicked:(id)sender {
    if (_isCompleteGame) {
        StoryMakeImageEditorViewController *storyMakerVc = [[StoryMakeImageEditorViewController alloc] initWithImage:_imageView.image];
        [self presentViewController:storyMakerVc animated:YES completion:nil];
        return;
    }
    LMLDropdownAlertView *alertView = [[LMLDropdownAlertView alloc] initWithFrame:self.view.bounds];
    [alertView showAlertWithTitle:@"提示" detail_Title:@"需要进入并完成游戏才能下载" cancleButtonTitle:@"取消" confirmButtonTitle:@"进入" action:^(UIButton * _Nonnull btn) {
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:_imageView.image cropMode:RSKImageCropModeSquare];
        self.imageCropVC = imageCropVC;
        imageCropVC.delegate = self;
        [self.navigationController pushViewController:imageCropVC animated:YES];
    }];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    GameCenterController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GameCenterController"];
    vc.completeGameBlock = ^{
        _isCompleteGame = YES;
    };
    vc.iconImage = croppedImage;
    vc.originImage = _imageView.image;
    
    NSString *path_document = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/pic.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(croppedImage) writeToFile:imagePath atomically:YES];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"circle" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _circlePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _circlePlayer.delegate = self;
    [_circlePlayer prepareToPlay];
    [_circlePlayer play];
    
    [LoadingGameView showLoadingViewWithPic:@"" color:@"222222" complete:^(NSString *str) {
        [self presentViewController:vc animated:YES completion:^{
            NSMutableArray *viewCtrs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewCtrs removeObject:self.imageCropVC];
            [self.navigationController setViewControllers:viewCtrs animated:YES];
        }];
    }];
}


- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)homeImageView {
    if (!_homeImageView) {
        _homeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        NSInteger w = kScreenHeight;
        NSString *imageStr = [NSString stringWithFormat:@"home_%ldh",w];
        _homeImageView.image = [UIImage imageNamed:imageStr];
        _homeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [UIView animateWithDuration:0.3 animations:^{
                _homeImageView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
            } completion:^(BOOL finished) {
                [_homeImageView removeFromSuperview];
                _homeImageView = nil;
                _bottomView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
            }];
        }];
        [_homeImageView addGestureRecognizer:tap];
    }
    return _homeImageView;
}

- (UIImageView *)lockImageView {
    if (!_lockImageView) {
        _lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        NSString *imageStr = @"lock_ios7_p5_white";
        if (kScreenWidth == 320 && kScreenHeight == 480) {
            imageStr = @"lock_ios7_p4_white";
        } else if (kIsiPhoneX) {
            imageStr = @"lock_ios7_px_white";
        }
        _lockImageView.image = [UIImage imageNamed:imageStr];
        _lockImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

            [UIView animateWithDuration:0.3 animations:^{
                _lockImageView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
            } completion:^(BOOL finished) {
                [_lockImageView removeFromSuperview];
                _lockImageView = nil;
                _bottomView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
            }];
        }];
        [_lockImageView addGestureRecognizer:tap];
    }
    return _lockImageView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([_circlePlayer isPlaying]) {
        [_circlePlayer stop];
    }
    _circlePlayer = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    player = nil;
}

@end
