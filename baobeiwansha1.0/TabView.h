//
//  TabView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/3.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabView : UIView

@property (nonatomic,retain) NSString *tabTitle;
@property (nonatomic,retain) UIImageView *tabIcon;
@property (nonatomic,retain) UILabel *tabLabel;

-(void)setNormalIcon:(UIImage *)normalIcon highlightIcon:(UIImage *)highlightIcon tabTitle:(NSString *)tabTitle;
-(void)setTabToNormal;
-(void)setTabToHighlight;

@end
