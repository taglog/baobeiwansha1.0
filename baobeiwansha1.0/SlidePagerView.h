//
//  SlidePagerView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/3.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlidePagerViewDelegate;
@protocol SlidePagerViewDataSource;

typedef NS_ENUM(NSUInteger, SlidePagerOption) {
    SlidePagerOptionTabHeight,
    SlidePagerOptionTabWidth,
};



@interface SlidePagerView : UIView <UIScrollViewDelegate>

@property (nonatomic,assign) id <SlidePagerViewDelegate> delegate;
@property (nonatomic,assign) id <SlidePagerViewDataSource> dataSource;

-(void)renderViews;

@end


@protocol SlidePagerViewDataSource <NSObject>
@required
//tab button个数
-(NSUInteger)numberOfTabsForSlidePager:(SlidePagerView *)slideView;

//tabView
-(UIView *)slidePager:(SlidePagerView *)slideView viewForTabAtIndex:(NSUInteger)index;

//viewPager
-(UIViewController *)slidePager:(SlidePagerView *)slidePager contentViewControllerForTabAtIndex:(NSUInteger)index;

@end

@protocol SlidePagerViewDelegate <NSObject>
@required
- (CGFloat)slidePager:(SlidePagerView *)slidePager valueForOption:(SlidePagerOption)option withDefault:(CGFloat)value;

@end
