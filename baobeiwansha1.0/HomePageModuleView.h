//
//  HomePageModuleView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomePageModuleViewDelegate <NSObject>

-(void)titleViewSelect:(id)sender;

-(void)pushViewControllerWithSender:(id)sender moduleView:(UIView *)view;

@end
@interface HomePageModuleView : UIView

@property (nonatomic,retain) UIButton *titleView;
@property (nonatomic,retain) NSString *title;

@property (nonatomic,weak) id<HomePageModuleViewDelegate> delegate;
@end
