//
//  StoryMakeStickerFootSingleViewController.m
//  GetZSCStoryMaker
//
//  Created by whbalzac on 09/08/2017.
//  Copyright © 2017 makeupopular.com. All rights reserved.
//

#import "StoryMakeStickerFootSingleViewController.h"
#import "StoryMakeStickerFooterCell.h"
#import "WHStoryMakerHeader.h"

@interface StoryMakeStickerFootSingleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) StoryMakeStickerFootSingleType type;
@property (nonatomic, strong) UICollectionView   *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) NSArray *imageUrlArray;
@end

@implementation StoryMakeStickerFootSingleViewController

- (instancetype)initWithType:(StoryMakeStickerFootSingleType)type imageUrlArray:(NSArray *)array
{
    if (self = [super init]) {
        self.type = type;
        _imageUrlArray = array;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageUrlArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StoryMakeStickerFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[StoryMakeStickerFooterCell identifierForReuseCell] forIndexPath:indexPath];
    
    if (indexPath.section >= _imageUrlArray.count) {
        return cell;
    }
    NSString *url = _imageUrlArray[indexPath.item];
    [cell.imageView setImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionUseNSURLCache];;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StoryMakeStickerFooterCell *cell = (StoryMakeStickerFooterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.imageView.image && self.delegate && [self.delegate respondsToSelector:@selector(singleViewControllerDidSelectedImage:)])
    {
        [self.delegate singleViewControllerDidSelectedImage:cell.imageView.image];
    }
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[StoryMakeStickerFooterCell class]
            forCellWithReuseIdentifier:[StoryMakeStickerFooterCell identifierForReuseCell]];
    }
    
    return _collectionView;
}

-(UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(SCREENAPPLYSPACE(100), SCREENAPPLYSPACE(100));
        _flowLayout.sectionInset = UIEdgeInsetsMake(SCREENAPPLYSPACE(4), SCREENAPPLYSPACE(18), SCREENAPPLYSPACE(4), SCREENAPPLYSPACE(18));
        _flowLayout.minimumLineSpacing = SCREENAPPLYSPACE(18);
    }
    
    return _flowLayout;
}

@end
