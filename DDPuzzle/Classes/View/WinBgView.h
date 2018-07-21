//
//  WinBgView.h
//  Puzzle
//
//  Created by duodian on 2018/6/14.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^KnowBlock)(void);
typedef void(^SaveBlock)(void);

@interface WinBgView : UIView
@property (nonatomic,strong) KnowBlock knowBlock;
@property (nonatomic,strong) SaveBlock saveBlock;
@property (nonatomic,strong) UIImage *originImage;
@end
