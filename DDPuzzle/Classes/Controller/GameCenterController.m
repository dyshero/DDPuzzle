//
//  EnterController.m
//  Puzzle
//
//  Created by duodian on 2018/5/31.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "GameCenterController.h"
#import "LevelGroupModel.h"
#import "LevelModel.h"
#import "PuzzleStatus.h"
#import "JXBreadthFirstSearcher.h"
#import "JXDoubleBreadthFirstSearcher.h"
#import "JXAStarSearcher.h"
#import "TYFWaveButton.h"
#import "YQInAppPurchaseTool.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DDPuzzle-Swift.h"
#import "WinBgView.h"
#import <AVFoundation/AVFoundation.h>
#import "WHStoryMakerHeader.h"

@interface GameCenterController()<YQInAppPurchaseToolDelegate,AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
/// 图片
@property (nonatomic, strong) UIImage *image;
/// 矩阵阶数
@property (nonatomic, assign) NSInteger matrixOrder;
/// 当前算法。1：广搜； 2：双向广搜； 3：A*算法
@property (nonatomic, assign) NSInteger algorithm;

#pragma mark - 状态
/// 当前游戏状态
@property (nonatomic, strong) PuzzleStatus *currentStatus;
/// 完成时的游戏状态
@property (nonatomic, strong) PuzzleStatus *completedStatus;
/// 保存的游戏状态
@property (nonatomic, strong) PuzzleStatus *savedStatus;

/// 标记正在自动拼图
@property (nonatomic, assign) BOOL isAutoGaming;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *autotimer;
@property (nonatomic,assign) NSInteger mytimeCount;
@property (nonatomic,assign) NSInteger gainScoreNum;

@property (weak, nonatomic) IBOutlet TYFWaveButton *resetBtn;
@property (weak, nonatomic) IBOutlet TYFWaveButton *autoBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (nonatomic,weak) WinBgView *winBgView;
@property (nonatomic,strong) AVAudioPlayer *sosoPlayer;
@property (nonatomic,strong) AVAudioPlayer *movePiecePlayer;
@property (nonatomic,strong) AVAudioPlayer *bgPlayer;
@property (nonatomic,strong) AVAudioPlayer *byePlayer;
@property (nonatomic,strong) AVAudioPlayer *winPlayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (nonatomic,assign) dispatch_semaphore_t sema;
@end

@implementation GameCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    _downloadBtn.hidden = YES;
    self.matrixOrder = 3;
    self.algorithm = 3;
    _previewImage.image = _iconImage;
    NSString *path_document = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/pic.png"];
    self.image = [UIImage imageWithContentsOfFile:imagePath];
    [self randomPiece];
    
    _resetBtn.layer.cornerRadius = 20;
    _resetBtn.clipsToBounds = YES;
    
    _autoBtn.layer.cornerRadius = 20;
    _autoBtn.clipsToBounds = YES;
    
    [self initPlayer];
    
    if (kScreenWidth == 320) {
        _scrollView.contentSize = CGSizeMake(0, 600);
        _scrollView.contentSize = CGSizeMake(0, _viewHeightConstraint.constant);
    } else {
        _viewHeightConstraint.constant = kScreenHeight - kSafeAreaBottom - kStatusHeight;
        _scrollView.contentSize = CGSizeMake(0, _viewHeightConstraint.constant);
    }
    _scrollView.bounces = NO;
}

- (IBAction)downloadClicked:(UIButton *)sender {
    StoryMakeImageEditorViewController *storyMakerVc = [[StoryMakeImageEditorViewController alloc] initWithImage:_originImage];
    [self presentViewController:storyMakerVc animated:YES completion:nil];
}


- (void)initPlayer {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gamecenter" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _bgPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _bgPlayer.numberOfLoops = -1;
    _bgPlayer.delegate = self;
    [_bgPlayer prepareToPlay];
    [_bgPlayer play];
}

- (void)beginGame {
    if (_autotimer) {
        if ([_autotimer isValid]) {
            [_autotimer invalidate];
        }
        _autotimer = nil;
    }
    _autotimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:self repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_autotimer forMode:NSDefaultRunLoopMode];
}

- (void)updateTimer {
    self.mytimeCount += 1;
}

- (void)setMytimeCount:(NSInteger)timeCount {
    _mytimeCount = timeCount;
    if (timeCount > 99*60) {
        [self onResetButton:nil];
        return;
    }
    NSInteger minute = timeCount/60;
    NSInteger second = timeCount%60;
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.text = timeStr;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self enterAnimation];
    
    if (_bgPlayer) {
        [_bgPlayer play];
    }
}

- (void)enterAnimation {
    self.view.alpha = 0;
    self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.84, 0.84);
    self.view.center = [UIApplication sharedApplication].keyWindow.center;
    [UIView animateWithDuration:0.36 animations:^{
        self.view.alpha = 1.f;
        self.view.transform = CGAffineTransformIdentity;
        self.view.center = [UIApplication sharedApplication].keyWindow.center;
    }];
}

- (void)randomPiece {
    PuzzleStatus *status = self.currentStatus;
    NSInteger pieceIndex = arc4random() % 9;
    
    PuzzlePiece *piece = [status.pieceArray objectAtIndex:pieceIndex];
    
    // 挖空一格
    if (status.emptyIndex < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            piece.alpha = 0;
        }];
        status.emptyIndex = pieceIndex;
        self.completedStatus = [self.currentStatus  copyStatus];
    }
    
    __weak typeof(self) ws = self;
    [self onShuffleButton:^{
        self.mytimeCount = 0;
        [ws beginGame];
    }];
}

/// 点击方块
- (void)onPieceTouch:(PuzzlePiece *)piece {
    if (self.isAutoGaming) {
        return;
    }
    
    if (_movePiecePlayer) {
        if ([_movePiecePlayer isPlaying]) {
            [_movePiecePlayer stop];
        }
        _movePiecePlayer = nil;
    }
    
    PuzzleStatus *status = self.currentStatus;
    NSInteger pieceIndex = [status.pieceArray indexOfObject:piece];
    
    // 挖空一格
    if (status.emptyIndex < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            piece.alpha = 0;
        }];
        status.emptyIndex = pieceIndex;
        self.completedStatus = [self.currentStatus  copyStatus];
        return;
    }
    
    if (![status canMoveToIndex:pieceIndex]) {
        NSLog(@"无法移动，target index:%@",  @(pieceIndex));
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"movepiece" ofType:@"mp3"];
    NSInteger index = arc4random()%5;
    if (index == 0) {
        NSInteger rand = arc4random()%4;
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sound_%ld",rand] ofType:@"mp3"];
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    _movePiecePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _movePiecePlayer.delegate = self;
    [_movePiecePlayer prepareToPlay];
    [_movePiecePlayer play];
    
    [status moveToIndex:pieceIndex];
    [self reloadWithStatus:self.currentStatus];
    
    if ([status equalWithStatus:self.completedStatus]) {
        [self gameEnd];
    }
}

- (void)showCurrentStatusOnView:(UIView *)view {
    CGFloat size = kScreenWidth*0.9 / self.matrixOrder;
    NSInteger index = 0;
    for (NSInteger row = 0; row < self.matrixOrder; ++ row) {
        for (NSInteger col = 0; col < self.matrixOrder; ++ col) {
            PuzzlePiece *piece = self.currentStatus.pieceArray[index ++];
            piece.frame = CGRectMake(col * size, row * size, size, size);
            [view addSubview:piece];
        }
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self onResetButton:nil];
}

- (void)reloadWithStatus:(PuzzleStatus *)status {
    [UIView animateWithDuration:0.25 animations:^{
        CGSize size = status.pieceArray.firstObject.frame.size;
        NSInteger index = 0;
        for (NSInteger row = 0; row < self.matrixOrder; ++ row) {
            for (NSInteger col = 0; col < self.matrixOrder; ++ col) {
                PuzzlePiece *piece = status.pieceArray[index ++];
                piece.frame = CGRectMake(col * size.width, row * size.height, size.width, size.height);
            }
        }
    }];
}

- (void)setMatrixOrder:(NSInteger)matrixOrder {
    _matrixOrder = matrixOrder;
    [self onResetButton:nil];
}

- (void)onShuffleButton:(void (^)())complete{
    if (self.isAutoGaming) {
        return;
    }
    if (self.currentStatus.emptyIndex < 0) {
        return;
    }
    
    NSLog(@"打乱顺序：当前为%@阶方阵, 随机移动%@步", @(self.matrixOrder), @(self.matrixOrder * self.matrixOrder * 10));
    [self.currentStatus shuffleCount:self.matrixOrder * self.matrixOrder * 10];
    [self reloadWithStatus:self.currentStatus];
    if (complete) {
        complete();
    }
}

- (IBAction)onResetButton:(UIButton *)sender {
    if (self.isAutoGaming) {
        return;
    }
    if (!self.image) {
        return;
    }
    
    if (_sosoPlayer) {
        if ([_sosoPlayer isPlaying]) {
            [_sosoPlayer stop];
        }
        _sosoPlayer = nil;
    }
    NSString *path = [[NSBundle mainBundle]pathForResource:@"soso" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _sosoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _sosoPlayer.delegate = self;
    [_sosoPlayer prepareToPlay];
    [_sosoPlayer play];
    
    _autoBtn.enabled = YES;
    [_autoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.currentStatus) {
        [self.currentStatus removeAllPieces];
    }
    self.currentStatus = [PuzzleStatus statusWithMatrixOrder:self.matrixOrder image:self.image];
    [self.currentStatus.pieceArray enumerateObjectsUsingBlock:^(PuzzlePiece * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = YES;
        [obj addTarget:self action:@selector(onPieceTouch:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    self.completedStatus = nil;
    [self showCurrentStatusOnView:self.bgView];
    [self randomPiece];
}

#pragma mark 自动
- (IBAction)onAutoButton:(UIButton *)sender {
    if (self.isAutoGaming) {
        return;
    }
    if (self.currentStatus.emptyIndex < 0) {
        return;
    }
    sender.enabled = NO;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IsVIP]) {
        [self autoMove];
        return;
    }
    //点击自动完成的时候先将计时器静止
    if (_autotimer) {
        if ([_autotimer isValid]) {
            [_autotimer invalidate];
        }
        _autotimer = nil;
    }
    
    YQInAppPurchaseTool *IAPTool = [YQInAppPurchaseTool defaultTool];
    IAPTool.delegate = self;
    IAPTool.CheckAfterPay = NO;
    [SVProgressHUD showWithStatus:@"处理中..."];
    [IAPTool requestProductsWithProductArray:@[@"com.dys.puzzle01"]];
}

- (void)setIsAutoGaming:(BOOL)isAutoGaming {
    _isAutoGaming = isAutoGaming;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isAutoGaming) {
            _resetBtn.enabled = NO;
        } else {
            _resetBtn.enabled = YES;
        }
    });
}

- (void)gameEnd {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"win" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _winPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _winPlayer.delegate = self;
    [_winPlayer prepareToPlay];
    [_winPlayer play];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _autoBtn.enabled = NO;
        [_autoBtn setTitleColor:[UIColor colorWithHexString:@"ababab"] forState:UIControlStateNormal];
        
        _resetBtn.enabled = YES;
        [_resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.currentStatus.pieceArray enumerateObjectsUsingBlock:^(PuzzlePiece * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.enabled = NO;
        }];
        
        _downloadBtn.hidden = NO;
        StoryMakeImageEditorViewController *storyMakerVc = [[StoryMakeImageEditorViewController alloc] initWithImage:_originImage];
        [self presentViewController:storyMakerVc animated:YES completion:nil];
    });
    
    if (_autotimer) {
        if ([_autotimer isValid]) {
            [_autotimer invalidate];
        }
        _autotimer = nil;
    }
    
    if (self.completeGameBlock) {
        self.completeGameBlock();
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } else {
        [SVProgressHUD showInfoWithStatus:@"保存失败"];
    }
}

- (IBAction)closeClicked:(id)sender {
    LMLDropdownAlertView *alertView = [[LMLDropdownAlertView alloc] initWithFrame:self.view.bounds];
    [alertView showAlertWithTitle:@"提示" detail_Title:@"确定要退出游戏?" cancleButtonTitle:@"取消" confirmButtonTitle:@"确定" action:^(UIButton * _Nonnull btn) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bye" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        _byePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _byePlayer.delegate = self;
        [_byePlayer prepareToPlay];
        [_byePlayer play];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_autotimer) {
        if ([_autotimer isValid]) {
            [_autotimer invalidate];
        }
        _autotimer = nil;
    }
    
    if (self.beingDismissed) {
        [_bgPlayer stop];
        _bgPlayer = nil;
    } else {
        [_bgPlayer pause];
    }
    
    [SVProgressHUD dismiss];
}

#pragma mark --------YQInAppPurchaseToolDelegate
//IAP工具已获得可购买的商品
-(void)IAPToolGotProducts:(NSMutableArray *)products {
    [self BuyProduct:@"com.dys.puzzle01"];
}

//支付失败/取消
-(void)IAPToolCanceldWithProductID:(NSString *)productID {
    [SVProgressHUD dismiss];
    _autoBtn.enabled = YES;
    self.mytimeCount += 1;
    [self beginGame];
    NSLog(@"Cancel");
}

//支付成功了，并开始向苹果服务器进行验证（若CheckAfterPay为NO，则不会经过此步骤）
-(void)IAPToolBeginCheckingdWithProductID:(NSString *)productID {
    NSLog(@"BeginChecking:%@",productID);
}

//商品被重复验证了
-(void)IAPToolCheckRedundantWithProductID:(NSString *)productID {
    [SVProgressHUD showInfoWithStatus:@"重复验证了"];
}

//商品完全购买成功且验证成功了。（若CheckAfterPay为NO，则会在购买成功后直接触发此方法）
-(void)IAPToolBoughtProductSuccessedWithProductID:(NSString *)productID
                                          andInfo:(NSDictionary *)infoDic {
    dispatch_async(dispatch_get_main_queue(), ^{
        _autoBtn.enabled = NO;
        [_autoBtn setTitleColor:[UIColor colorWithHexString:@"ababab"] forState:UIControlStateNormal];
        
        _resetBtn.enabled = NO;
        [_resetBtn setTitleColor:[UIColor colorWithHexString:@"ababab"] forState:UIControlStateNormal];
        
        [self autoMove];
    });
    
    [SVProgressHUD dismiss];
    _autoBtn.enabled = YES;
    NSLog(@"购买成功");
}

- (void)autoMove {
    JXPathSearcher *searcher = nil;
    switch (self.algorithm) {
        case 1:
            NSLog(@"----- 广度优先搜索 -----");
            searcher = [[JXBreadthFirstSearcher alloc] init];
            break;
        case 2:
            NSLog(@"----- 双向广度优先搜索 -----");
            searcher = [[JXDoubleBreadthFirstSearcher alloc] init];
            break;
        case 3:
            NSLog(@"----- A*搜索 -----");
            searcher = [[JXAStarSearcher alloc] init];
            break;
        default:
            break;
    }
    
    searcher.startStatus = [self.currentStatus copyStatus];
    searcher.targetStatus = [self.completedStatus copyStatus];
    [searcher setEqualComparator:^BOOL(PuzzleStatus *status1, PuzzleStatus *status2) {
        return [status1 equalWithStatus:status2];
    }];
    // 开始搜索
    NSMutableArray<PuzzleStatus *> *path = [searcher search];
    __block NSInteger pathCount = path.count;
    NSLog(@"需要移动：%@步", @(pathCount));
    
    if (!path || pathCount == 0) {
        return;
    }
    
    // 开始自动拼图
    self.isAutoGaming = YES;
    [self beginGame];
    
    // 定时信号，控制拼图速度
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    _sema = sema;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateSema) userInfo:nil repeats:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [path enumerateObjectsUsingBlock:^(PuzzleStatus * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 等待信号
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            // 刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                // 显示排列
                [self reloadWithStatus:obj];
            });
        }];
        
        // 拼图完成
        [_timer invalidate];
        [self gameEnd];
        self.currentStatus = [path lastObject];
        self.isAutoGaming = NO;
    });
}

- (void)updateSema {
    dispatch_semaphore_signal(_sema);
}

//商品购买成功了，但向苹果服务器验证失败了
//2种可能：
//1，设备越狱了，使用了插件，在虚假购买。
//2，验证的时候网络突然中断了。（一般极少出现，因为购买的时候是需要网络的）
-(void)IAPToolCheckFailedWithProductID:(NSString *)productID
                               andInfo:(NSData *)infoData {
    [SVProgressHUD showErrorWithStatus:@"Error"];
}

//内购系统错误了
-(void)IAPToolSysWrong {
    [SVProgressHUD showErrorWithStatus:@"Error"];
}

//购买商品
-(void)BuyProduct:(NSString *)productId {
    [[YQInAppPurchaseTool defaultTool] buyProduct:productId];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (player == _byePlayer) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    player = nil;
}

- (void)dealloc {
    NSLog(@"=========");
}
@end

