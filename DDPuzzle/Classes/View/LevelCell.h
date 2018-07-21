//
//  LevelCell.h
//  Puzzle
//
//  Created by duodian on 2018/6/1.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LevelModel;

@interface LevelCell : UITableViewCell
@property (nonatomic,weak) LevelModel *model;
@end
