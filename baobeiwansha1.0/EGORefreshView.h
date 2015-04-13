//
//  EGORefreshView.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/4.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//Position of EGORefresh
typedef enum {
    EGORefreshHeader = 0,
    EGORefreshFooter,
}EGORefreshPosition;

//state of EGORefresh
typedef enum{
    EGOOPullRefreshPulling = 0,
    EGOOPullRefreshNormal,
    EGOOPullRefreshLoading,
} EGOPullRefreshState;

@protocol EGORefreshViewDelegate;

@interface EGORefreshView : UIView
//属性
@property(nonatomic,assign) EGOPullRefreshState state;
@property(nonatomic,assign) EGORefreshPosition position;

//判断是上拉还是下拉
@property(nonatomic,assign) BOOL pullUp;
@property(nonatomic,assign) BOOL pullDown;

@property (nonatomic,assign) BOOL isTextColorBlack;

@property(nonatomic,retain) UIScrollView *scrollView;

@property(nonatomic,strong) UILabel *lastUpdateLabel;

@property(nonatomic,strong) UILabel *statusLabel;

@property(nonatomic,strong) CALayer *arrowImage;

@property(nonatomic,strong) UIActivityIndicatorView *activityView;

@property(nonatomic,retain)id <EGORefreshViewDelegate> delegate;

//方法
- (id)initWithScrollView:(UIScrollView *)scrollView position:(EGORefreshPosition)position;

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)setState:(EGOPullRefreshState)aState;

@end

//委托的方法
@protocol EGORefreshViewDelegate <NSObject>

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshView *)view;

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshView *)view;

@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshView *)view;


@end
