//
//  LevelController.m
//  Puzzle
//
//  Created by duodian on 2018/6/1.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "LevelController.h"
#import "UIImage+Extension.h"
#import "LevelCell.h"
#import "LevelModel.h"
#import "LevelGroupModel.h"
#import "GameCenterController.h"
#import "LoadingGameView.h"
#import <SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNet.h"
#import "WallpaperModel.h"
#import "WallpaperCell.h"
#import "PreviewController.h"
#import "WallpaperCateCell.h"
#import "CommonTool.h"
#import "NSString+Extension.h"
#import <MJRefresh.h>

#define BottomH 40
#define ColsCount 2

@interface LevelController ()<AVAudioPlayerDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) AVAudioPlayer *clickPlayer;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UICollectionView *leftView;
@property (nonatomic,strong) UICollectionView *middleView;
@property (nonatomic,strong) UICollectionView *rightView;
@property (nonatomic,assign) NSInteger leftPage;
@property (nonatomic,assign) NSInteger middlePage;
@property (nonatomic,assign) NSInteger rightPage;
@property (nonatomic,strong) NSMutableArray *leftArray;
@property (nonatomic,strong) NSMutableArray *middleArray;
@property (nonatomic,strong) NSMutableArray *rightArray;
@property (weak, nonatomic) UISegmentedControl *segment;
@property (nonatomic,strong) NSArray *titArray;
@end

@implementation LevelController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES animated:NO];

//    if (_index == nil) {
//        _titArray = @[@"最热",@"最新",@"分类"];
//    } else {
//        _titArray = @[@"最热",@"最新"];
//    }
    
    _titArray = @[@"最热",@"最新"];

    [self configScrollView];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:_titArray];
    segment.frame = CGRectMake(0,0, _titArray.count*50, 30);
    segment.tintColor = [UIColor whiteColor];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    _segment = segment;
    self.navigationItem.titleView = segment;
}

- (void)configScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusHeight + 10 + 29 + 10, kScreenWidth, kScreenHeight - (kStatusHeight + 10 + 29 + 10) - (BottomH + kSafeAreaBottom + 20 + 10))];
    _scrollView.contentSize = CGSizeMake(kScreenWidth*_titArray.count, 0);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    CGFloat itemW = (kScreenWidth - 4*5)/3.0;
    layout.itemSize = CGSizeMake(itemW, itemW*540/350);
    _leftView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _scrollView.height) collectionViewLayout:layout];
    _leftView.delegate = self;
    _leftView.dataSource = self;
    [_leftView registerNib:[UINib nibWithNibName:@"WallpaperCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    MJRefreshBackNormalFooter *leftFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _leftPage ++;
        [self loadLeftData];
    }];
    _leftView.mj_footer = leftFooter;
    
    MJRefreshHeader *leftHeader = [MJRefreshHeader headerWithRefreshingBlock:^{
        _leftPage = 0;
        _leftArray = [NSMutableArray array];
        [self loadLeftData];
    }];
    _leftView.mj_header = leftHeader;
    [_scrollView addSubview:_leftView];
    
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.minimumLineSpacing = 5;
    layout1.minimumInteritemSpacing = 5;
    layout1.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layout1.itemSize = CGSizeMake(itemW, itemW*540/350);
    _middleView = [[UICollectionView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _scrollView.height) collectionViewLayout:layout1];
    _middleView.delegate = self;
    _middleView.dataSource = self;
    [_middleView registerNib:[UINib nibWithNibName:@"WallpaperCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    MJRefreshBackNormalFooter *middleFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _middlePage ++;
        [self loadmiddleData];
    }];
    _middleView.mj_footer = middleFooter;

    MJRefreshHeader *middleHeader = [MJRefreshHeader headerWithRefreshingBlock:^{
        _middlePage = 0;
        _middleArray = [NSMutableArray array];
        [self loadmiddleData];
    }];
    _middleView.mj_header = middleHeader;
    [_scrollView addSubview:_middleView];
    
    if (_index == nil) {
        UICollectionViewFlowLayout *layout3 = [[UICollectionViewFlowLayout alloc] init];
        layout3.minimumLineSpacing = 5;
        layout3.minimumInteritemSpacing = 5;
        layout3.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout3.itemSize = CGSizeMake((kScreenWidth - 3*5)/2.0, ((kScreenWidth - 3*5)/2.0)*606/659);
        _rightView = [[UICollectionView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, _scrollView.height) collectionViewLayout:layout3];
        _rightView.delegate = self;
        _rightView.dataSource = self;
        [_rightView registerNib:[UINib nibWithNibName:@"WallpaperCateCell" bundle:nil] forCellWithReuseIdentifier:@"cateCell"];
        MJRefreshBackNormalFooter *rightFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _rightPage ++;
            [self loadRightData];
        }];
        _rightView.mj_footer = rightFooter;
        
        MJRefreshHeader *rightHeader = [MJRefreshHeader headerWithRefreshingBlock:^{
            _rightPage = 0;
            _rightArray = [NSMutableArray array];
            [self loadRightData];
        }];
        _rightView.mj_header = rightHeader;
        [_scrollView addSubview:_rightView];
    }

    [self.view addSubview:_scrollView];
    
    _leftArray = [[NSMutableArray alloc] init];
    [self loadLeftData];
}

- (void)loadLeftData {
    
    NSString *url = @"";
    
    [AFNet requestWithUrl:url requestType:HttpRequestTypeGet parameter:nil completation:^(id object) {
        if (_leftView.mj_header.isRefreshing) {
            [_leftView.mj_header endRefreshing];
        }
        
        if (_leftView.mj_footer.isRefreshing) {
            [_leftView.mj_footer endRefreshing];
        }
        
        if ([object[@"code"] integerValue] != 0) {
            return;
        }
        
        NSArray *list = object[@"res"][@"vertical"];
        for (NSDictionary *dict in list) {
            WallpaperModel *model = [WallpaperModel modelWithDict:dict];
            [_leftArray addObject:model];
        }
        
        [self.leftView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadmiddleData {
    
    NSString *url = @"";
    
    [AFNet requestWithUrl:url requestType:HttpRequestTypeGet parameter:nil completation:^(id object) {
        if (_middleView.mj_header.isRefreshing) {
            [_middleView.mj_header endRefreshing];
        }
        
        if (_middleView.mj_footer.isRefreshing) {
            [_middleView.mj_footer endRefreshing];
        }
        
        if ([object[@"code"] integerValue] != 0) {
            return;
        }
        
        NSArray *list = object[@"res"][@"vertical"];
        
        for (NSDictionary *dict in list) {
            WallpaperModel *model = [WallpaperModel modelWithDict:dict];
            [_middleArray addObject:model];
        }
        [_middleView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadRightData {
    [AFNet requestWithUrl:@"" requestType:HttpRequestTypeGet parameter:nil completation:^(id object) {
        if (_rightView.mj_header.isRefreshing) {
            [_rightView.mj_header endRefreshing];
        }
        
        if (_rightView.mj_footer.isRefreshing) {
            [_rightView.mj_footer endRefreshing];
        }
        
        if ([object[@"msgCode"] integerValue] ==1) {
            return;
        }
        
        NSArray *list = object[@"body"][@"cats"];
        for (NSDictionary *dict in list) {
            WallpaperModel *model = [WallpaperModel modelWithDict:dict];
            [_rightArray addObject:model];
        }
        [_rightView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        NSInteger index = scrollView.contentOffset.x/kScreenWidth;
        _segment.selectedSegmentIndex = index;
        [self loadDataWithIndex:index];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _leftView) {
        return _leftArray.count;
    } else if (collectionView == _middleView) {
        return _middleArray.count;
    }
    return _rightArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *baseCell = nil;
    if (collectionView != _rightView) {
        WallpaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (collectionView == _leftView) {
            cell.model = _leftArray[indexPath.item];
        } else {
            cell.model = _middleArray[indexPath.item];
        }
        baseCell = cell;
    } else {
        WallpaperCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cateCell" forIndexPath:indexPath];
        cell.model = _rightArray[indexPath.item];
        baseCell = cell;
    }
    return baseCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView != _rightView) {
        PreviewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PreviewController"];
        WallpaperModel *model = nil;
        if (collectionView == _leftView) {
            model = _leftArray[indexPath.item];
        } else {
            model = _middleArray[indexPath.item];
        }
        vc.url = model.img;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LevelModel *model = _rightArray[indexPath.item];
        LevelController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LevelController"];
        vc.index = model.Id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IsStopAnimate] == YES) {
        return;
    }
    NSArray *array = collectionView.indexPathsForVisibleItems;
    if (array.count == 0)return;
    NSIndexPath *firstIndexPath = array[0];
    if (firstIndexPath.row < indexPath.row) {
        CATransform3D rotation;//3D旋转
        rotation =CATransform3DMakeTranslation(0 ,150 ,20);
        rotation = CATransform3DRotate(rotation,M_PI, 0, 0.5, 0.0);
            CATransform3DMakeRotation(M_PI, 0, 0.5, 0.0);
        //逆时针旋转
        rotation = CATransform3DScale(rotation,0.9,0.9,1);
        rotation.m34 = 1.0/ -600;
        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.layer.shadowOffset =CGSizeMake(10,10);
        cell.alpha =0;
        cell.layer.transform = rotation;
        [UIView animateWithDuration:1.0 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.alpha = 1;
            cell.layer.shadowOffset = CGSizeMake(0,0);
        }];
    }
}

- (void)segmentValueChange:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    [_scrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];
    [self loadDataWithIndex:index];
}

- (void)loadDataWithIndex:(NSInteger)index {
    if (index == 0) {
        if (_leftArray == nil) {
            _leftArray = [NSMutableArray array];
            [self loadLeftData];
        }
    } else if (index == 1){
        if (_middleArray == nil) {
            _middleArray = [NSMutableArray array];
            [self loadmiddleData];
        }
    } else {
        if (_rightArray == nil) {
            _rightArray = [NSMutableArray array];
            [self loadRightData];
        }
    }
}

- (IBAction)closeClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_player stop];
    _player = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    player = nil;
}

@end
