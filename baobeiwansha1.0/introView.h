//
//  introView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/20.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroView : UIView

-(id)initWithFrame:(CGRect)frame customViews:(NSArray *)customViews background:(UIImage *)backgroundImage;

-(void)performAnimation;

@end
