//
//  IntroViewController.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/20.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroViewControllerDataSource;
@protocol IntroViewControllerDelegate;

@interface IntroViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,retain) UIPageControl *pageControl;

@property (nonatomic,assign) id <IntroViewControllerDelegate> delegate;
@property (nonatomic,assign) id <IntroViewControllerDataSource> dataSource;

-(void)renderViews;
@end
@protocol IntroViewControllerDataSource <NSObject>

-(NSUInteger)numberOfViewsForIntro:(IntroViewController *)introViewController;

//viewPager
-(UIViewController *)introView:(IntroViewController *)introViewController contentViewControllerForViewAtIndex:(NSUInteger)index;
@end

@protocol IntroViewControllerDelegate <NSObject>

-(void)introView:(IntroViewController *)introViewController didChangeTabToIndex:(NSUInteger)index;

@end