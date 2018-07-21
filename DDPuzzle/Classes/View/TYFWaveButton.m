//
//  TYFWaveButton.m
//  
//
//  Created by ai r on 2017/12/15.
//  Copyright © 2017年 水波按钮. All rights reserved.
//

#import "TYFWaveButton.h"

@interface TYFWaveSet :NSObject

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat starttime;

@property (nonatomic, assign) CGPoint centerofcircle;

@end

@implementation TYFWaveSet

@end

@interface TYFWaveButton ()

@property (nonatomic, strong) NSMutableDictionary *wavedic;

@property (nonatomic, assign) NSInteger numofwavekey;

@end

@implementation TYFWaveButton

- (instancetype)init {
    if (self = [super init]) {
        [self configBtn];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configBtn];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configBtn];
    }
    return self;
}

- (void)configBtn {
    self.numofwavekey = 1;
    self.wavedic = [NSMutableDictionary dictionary];
    [self addTarget:self action:@selector(startanmiation:event:) forControlEvents:UIControlEventTouchUpInside];
    
    self.radiusofWaveStart = 10;
    self.radiusofWaveEnd = 100;
    self.colorofwave = [UIColor colorWithHexString:@"f1f1f1"];
    self.timeofwave = 1.0;
    self.onlycenter = YES;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
        for (TYFWaveSet *set in self.wavedic.allValues) {
            CGContextAddArc(context, set.centerofcircle.x, set.centerofcircle.y , set.radius, 0, 2*M_PI, 0);
            [[self.colorofwave colorWithAlphaComponent:1.00 - ((set.radius-_radiusofWaveStart)/(_radiusofWaveEnd-_radiusofWaveStart))] setStroke];
            [[self.colorofwave colorWithAlphaComponent:1.00 - ((set.radius-_radiusofWaveStart)/(_radiusofWaveEnd-_radiusofWaveStart))] setFill];
            CGContextFillPath(context);
        }
}

- (void)newdata {
    if (!self.centerofcircle.x) {
        self.centerofcircle = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    }
    if (!self.radiusofWaveEnd) {
        if (self.frame.size.width>self.frame.size.height) {
            self.radiusofWaveEnd = self.frame.size.height/2.0f;
        } else {
            self.radiusofWaveEnd = self.frame.size.width/2.0f;
        }
    }
    if (!self.numberofwave) {
        self.numberofwave = 1;
    }
    if (!self.timeofwave) {
        self.timeofwave = 1;
    }
    if (!self.radiusofWaveStart) {
        self.radiusofWaveStart = 0;
    }
    
}


- (void)startanmiation:(UIButton *)btn event:(UIEvent *)event {
    
    [self newdata];
    
    
    UITouch *touch = event.allTouches.allObjects.firstObject;
    CGPoint touchePoint = [touch locationInView:btn];
    
    CGFloat delay = 0.0;
    for (int i = 0; i<self.numberofwave; i++) {
        
        TYFWaveSet *waveset = [[TYFWaveSet alloc] init];
        waveset.color = self.colorofwave;
        waveset.radius = self.radiusofWaveStart;
        waveset.starttime = delay;
        if (self.onlycenter) {
            waveset.centerofcircle = self.centerofcircle;
        } else {
            waveset.centerofcircle = touchePoint;
        }
        
        delay += self.intervaltimeofwave;
        
        NSString *key = [NSString stringWithFormat:@"%ld",self.numofwavekey];
        [self.wavedic setObject:waveset forKey:key];
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.01
                                                 target:self
                                               selector:@selector(Timer:)
                                               userInfo:@{@"key":key}
                                                repeats:YES];
        
        [NSRunLoop.mainRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
        self.numofwavekey ++;
        
    }

}

-(void)Timer:(NSTimer *)timer{
    
    [self setNeedsDisplay];
    
    NSDictionary *userInfo = timer.userInfo;
    
    NSString *key = userInfo[@"key"];
    
    TYFWaveSet *set = [self.wavedic valueForKey:key];
    if (set.starttime <= 0) {
        if (set.radius < self.radiusofWaveEnd) {
            set.radius += (self.radiusofWaveEnd-self.radiusofWaveStart)/(self.timeofwave*100.0);
        } else {
            [self.wavedic removeObjectForKey:key];
            [timer invalidate];
        }
    } else {
        set.starttime -= 0.01;
    }


}

@end
