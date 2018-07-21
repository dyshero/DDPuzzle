//
//  Macro.h
//  Puzzle
//
//  Created by duodian on 2018/6/1.
//  Copyright © 2018年 丁远帅. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

#define kIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kSafeAreaBottom (kIsiPhoneX ? 34 : 0)

#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define kStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define Level @"level"

#define Time @"kDateTime"
#define Score @"kScore"
#define IsVIP @"kIsVIP"
#define IsStopHello @"kIsStopHello"
#define IsStopAnimate @"kIsStopAnimate"

#endif /* Macro_h */
