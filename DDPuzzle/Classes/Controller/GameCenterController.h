//
//  GameCenterController.h
//  Puzzle
//
//  Created by duodian on 2018/5/31.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelModel.h"
typedef void(^CompleteGameBlock)(void);

@interface GameCenterController : UIViewController
@property (nonatomic,strong) UIImage *iconImage;
@property (nonatomic,strong) UIImage *originImage;

@property (nonatomic,strong) CompleteGameBlock completeGameBlock;
@end
