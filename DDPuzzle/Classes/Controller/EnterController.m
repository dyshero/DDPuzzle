//
//  EnterController.m
//  Puzzle
//
//  Created by duodian on 2018/5/31.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "EnterController.h"
#import "LevelController.h"
#import "NSDate+Extension.h"
#import "AFNet.h"
#import "WallpaperModel.h"
#import "SetController.h"
#import <YYKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CommonTool.h"
#import "NSString+Extension.h"

@interface EnterController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (nonatomic,strong) AVAudioPlayer *player;
@end

@implementation EnterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IsStopHello] == NO) {
        [self initPlayer];
    }
    
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    UIColor *randColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:0.8];
    _logoImage.image = [[UIImage imageNamed:@"Dandelion1"] imageByTintColor:randColor];
    
    
    NSString *url = [NSString stringWithFormat:@"http://service.aibizhi.adesk.com/v1/lightwp/vertical?adult=0&appid=%@&appver=%@&appvercode=%@&channel=ipicture&first=1&lan=zh-Hans-CN&limit=30&order=hot&skip=30&sys_model=iPhone&sys_name=iOS&sys_ver=%@",[NSString getBundleID],[NSString getLocalAppVersion],[NSString getBuildVersion],[NSString getPhoneVersion]];
    
    [AFNet requestWithUrl:url  requestType:HttpRequestTypeGet parameter:nil completation:^(id object) {
        if ([object[@"code"] integerValue] != 0) {
            return;
        }
        NSArray *list = object[@"res"][@"vertical"];
        NSMutableArray *dataArray = [NSMutableArray array];

        for (NSDictionary *dict in list) {
            WallpaperModel *model = [WallpaperModel modelWithDict:dict];
            [dataArray addObject:model];
        }

        NSInteger index = arc4random()%dataArray.count;
        WallpaperModel *currentModel = dataArray[index];
        [_bgImageView setImageURL:[NSURL URLWithString:currentModel.img]];
    } failure:^(NSError *error) {

    }];
}

- (void)initPlayer {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"welcome" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_player prepareToPlay];
    _player.delegate = self;
    [_player play];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)playClicked:(id)sender {
    LevelController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LevelController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)setClicked:(id)sender {
    SetController *setVC = [[SetController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    player = nil;
}
@end
