//
//  LinkView.h
//  WARFRAME
//
//  Created by CarMayor on 2018/1/6.
//  Copyright © 2018年 CarMayor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingGameView : UIView

+ (void)showLoadingViewWithPic:(NSString *)pic color:(NSString *)color complete:(void (^)(NSString *str))completeBlock;
@end
