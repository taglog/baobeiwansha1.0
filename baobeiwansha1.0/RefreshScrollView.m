//
//  RefreshScrollView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/4.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "RefreshScrollView.h"
@interface RefreshScrollView ()

@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) EGORefreshView *refreshHeaderView;
@property (nonatomic,retain) EGORefreshView *refreshFooterView;

@property (nonatomic,assign) BOOL reloading;
@end

@implementation RefreshScrollView

-(id)initWithScrollView:(UIScrollView *)scrollView  {
    self = [super init];
    self.scrollView = scrollView;
    [self initViews];
    return self;
}

-(void)initViews{
    
    self.frame = self.scrollView.frame;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    [self initRefreshHeaderView];
    [self initRefreshFooterView];
    
}

-(void)initRefreshHeaderView{
    
    if(!self.refreshHeaderView){
        self.refreshHeaderView = [[EGORefreshView alloc]initWithScrollView:self.scrollView position:EGORefreshHeader];
        self.refreshHeaderView.delegate = self;
        
        [self.scrollView addSubview:self.refreshHeaderView];
    }
    
}

-(void)initRefreshFooterView{
    
    if(!self.refreshFooterView){
        self.refreshFooterView = [[EGORefreshView alloc]initWithScrollView:self.scrollView position:EGORefreshFooter];
        self.refreshFooterView.delegate = self;
        
        [self.scrollView addSubview:self.refreshFooterView];
    }
    
}

-(void)simulatePullDownRefresh{
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    
    self.scrollView.contentOffset = CGPointMake(0, -64);
    
    [self performPullDownRefresh];
    
}

#pragma mark EGORefreshReloadData
- (void)reloadTableViewDataSource{
    
    //下拉刷新的数据处理
    if(_refreshHeaderView.pullDown){
        [self performPullDownRefresh];
    }
   
    //上拉刷新的数据处理
    if(_refreshFooterView.pullUp){
        [self performPullUpRefresh];
    }
    
}



-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    [self.delegate pullDownRefresh];
}

-(void)performPullUpRefresh{
    
    _reloading = YES;
    
    [self.delegate pullDownRefresh];
    
}


- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
    [self.refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
    
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"11111");
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [self.refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshView *)view{
    
    [self reloadTableViewDataSource];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshView *)view{
    
    return self.reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshView *)view{
    
    return [NSDate date];
    
}

@end
