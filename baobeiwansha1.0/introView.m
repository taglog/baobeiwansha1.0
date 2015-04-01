//
//  introView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/20.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "introView.h"
@interface IntroView ()

@property (nonatomic,retain) NSArray *customViews;
@property (nonatomic,assign) BOOL isAnimated;

@end
@implementation IntroView
//初始化view
-(id)initWithFrame:(CGRect)frame customViews:(NSArray *)customViews background:(UIImage *)backgroundImage{
    
    self = [super initWithFrame:frame];
    
    self.layer.contents = (id) backgroundImage.CGImage;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;;
    
    self.customViews = customViews;
    self.isAnimated = NO;
    
    return self;
}

//遍历views，根据传入的参数设置动画
-(void)performAnimation{
    
    if(self.isAnimated == NO){
        
        for(UIView * customView in self.customViews){
            UIView *view = [customView valueForKey:@"view"];
            float delay = [[customView valueForKey:@"delay"] floatValue];
            
            if( delay > 0){
                
                CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
                view.transform = transform;
                [self addSubview:view];
                [self performSelector:@selector(performInitialAnimation:) withObject:view afterDelay:delay];
                
            }else{
                [self addSubview:view];
            }
            
            
        }
        self.isAnimated = YES;
    }
}

//初始化动画效果
-(void)performInitialAnimation:(UIView *)view{
    
    float initialDuration = 0.5;
    CAKeyframeAnimation *initAnimationBoundce = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    initAnimationBoundce.values = @[@0,@1.3,@1];
    initAnimationBoundce.duration = initialDuration;
    initAnimationBoundce.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    initAnimationBoundce.fillMode = kCAFillModeForwards;
    initAnimationBoundce.removedOnCompletion = NO;
    
    [view.layer addAnimation:initAnimationBoundce forKey:@"transform.scale"];
}



@end
