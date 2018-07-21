//
//  WallpaperCateCell.m
//  DDPuzzle
//
//  Created by duodian on 2018/7/2.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import "WallpaperCateCell.h"
@interface WallpaperCateCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;

@end

@implementation WallpaperCateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)setModel:(WallpaperModel *)model {
//    [_iconImage setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@606,695.jpg",model.url]]];
//    _titLabel.text = model.title;
}

@end
