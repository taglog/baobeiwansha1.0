//
//  ButtonCanDragScrollView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/22.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "ButtonCanDragScrollView.h"

@implementation ButtonCanDragScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}

@end
