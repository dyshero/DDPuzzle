//
//  BuyServiceView.h
//  DDPuzzle
//
//  Created by duodian on 2018/6/28.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYFWaveButton.h"
typedef void(^ServiceBtnBlock)(NSInteger index);

@interface BuyServiceView : UIView
@property (strong, nonatomic) TYFWaveButton *buyBtn;
@property (strong, nonatomic) TYFWaveButton *resetBtn;
@property (strong, nonatomic) TYFWaveButton *cancelBtn;
@property (nonatomic,strong) ServiceBtnBlock serviceBtnBlock;
@end
