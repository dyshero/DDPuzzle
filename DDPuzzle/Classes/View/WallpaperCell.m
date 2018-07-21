//
//  WallpaperCell.m
//  Puzzle
//
//  Created by duodian on 2018/6/26.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "WallpaperCell.h"
#import "WallpaperModel.h"

@interface WallpaperCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@end

@implementation WallpaperCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)setModel:(WallpaperModel *)model {
//    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
//    NSLog(@"%@",model.thumb);
    [_iconImageView setImageURL:[NSURL URLWithString:model.thumb]];
}

@end
