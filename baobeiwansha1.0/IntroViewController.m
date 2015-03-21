//
//  IntroViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/20.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@property (nonatomic,assign) NSUInteger count;

@property (nonatomic,retain) UIScrollView *pageScrollView;

@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,retain) NSMutableArray *viewControllers;

@property (nonatomic,assign) NSUInteger activeTabIndex;


@end
@implementation IntroViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
-(void)viewDidLoad{
    [super viewDidLoad];
    

}
-(void)renderViews{
    
    [self defaultSetting];
    [self initViews];
    
}
-(void)defaultSetting{
    
    if ([self.dataSource respondsToSelector:@selector(numberOfViewsForIntro:)]) {
        self.count = [self.dataSource numberOfViewsForIntro:self];
    }
    
}
-(void)initViews{
    
        
    [self initPageScrollView];
    [self initPageControl];
    
}

-(void)initPageScrollView{
    
    
    self.pageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height)];
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.delegate = self;
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.pageScrollView];
    
    [self initContentViews];
    
    
}
-(void)initContentViews{
    
    self.pageScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.count, self.view.frame.size.height);

    for(NSUInteger i = 0;i < self.count;i++){
        UIViewController *contentViewController = [self.dataSource introView:self contentViewControllerForViewAtIndex:i];
        [self.viewControllers addObject:contentViewController];
        
        [self addChildViewController:contentViewController];
        contentViewController.view.frame = CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.pageScrollView addSubview:contentViewController.view];
        
        
    }
    //选中第一个
    if ([self.delegate respondsToSelector:@selector(introView:didChangeTabToIndex:)]) {
        [self.delegate introView:self didChangeTabToIndex:0];
    }

}
-(void)initPageControl{
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2, self.view.frame.size.height - 80, 200, 40)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
    
}

-(void)selectViewAtIndex:(NSUInteger)index{
    
    self.activeTabIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(introView:didChangeTabToIndex:)]) {
        [self.delegate introView:self didChangeTabToIndex:self.activeTabIndex];
    }
    self.pageControl.currentPage = self.activeTabIndex;

    
}
-(void)selectContentViewControllerAtIndex:(NSUInteger)index{
    
    [self.pageScrollView setContentOffset:CGPointMake(index * self.view.frame.size.width, 0) animated:YES];
    self.pageControl.currentPage = index;
    
}

#pragma mark 主视图滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.pageScrollView) {
        
        int i = (int)scrollView.contentOffset.x/self.view.frame.size.width;
        if(i != self.activeTabIndex){
            [self selectViewAtIndex:i];
            
        }
        
    }
}

@end