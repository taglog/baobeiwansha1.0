//
//  RefreshScrollView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/4.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshView.h"

@protocol RefreshScrollViewDelegate
@required

-(void)pullDownRefresh;
-(void)pullUpRefresh;

@end
@interface RefreshScrollView : UIView <EGORefreshViewDelegate,UIScrollViewDelegate>

@property (nonatomic,assign) id <RefreshScrollViewDelegate> delegate;
-(id)initWithScrollView:(UIScrollView *)scrollView;

-(void)simulatePullDownRefresh;
-(void)doneLoadingTableViewData;

@end
