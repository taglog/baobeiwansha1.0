//
//  SlidePagerViewController.m
//  
//
//  Created by 上海震渊信息技术有限公司 on 15/3/6.
//
//

#import "SlidePagerViewController.h"

#define kTabHeight 50.0
#define kTabWidth 105.0

@interface SlidePagerViewController ()

@property (nonatomic,retain) UIScrollView *tabBar;
@property (nonatomic,retain) UIScrollView *pageScrollView;

@property (nonatomic,retain) UIView *contentView;

@property (nonatomic,assign) NSUInteger count;
@property (nonatomic,assign) CGFloat tabWidth;
@property (nonatomic,assign) CGFloat tabHeight;

@property (nonatomic,retain) NSMutableArray *tabViews;
@property (nonatomic,retain) NSMutableArray *viewControllers;

@property (nonatomic,assign) NSUInteger activeTabIndex;

@property (nonatomic,assign) CGFloat pageScrollViewContentOffsetX;

@end

@implementation SlidePagerViewController

-(void)renderViews{
    
    [self defaultSetting];
    [self initViews];
    
}

-(void)defaultSetting{
    
    if ([self.dataSource respondsToSelector:@selector(numberOfTabsForSlidePager:)]) {
        self.count = [self.dataSource numberOfTabsForSlidePager:self];
    }
    
    if([self.delegate respondsToSelector:@selector(slidePager:valueForOption:withDefault:)]){
        
        self.tabWidth = [self.delegate slidePager:self valueForOption:SlidePagerOptionTabWidth withDefault:kTabWidth];
        
        self.tabHeight = [self.delegate slidePager:self valueForOption:SlidePagerOptionTabHeight withDefault:kTabHeight];
    }
    
}

-(void)initViews{
    
    [self initTabBar];
    [self initPageScrollView];
    
}

-(void)initTabBar{
    
    self.tabBar = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.tabHeight)];
    self.tabBar.backgroundColor = [UIColor colorWithRed:250.0/255.0f green:250.0/255.0f blue:250.0/255.0f alpha:1.0f];
    self.tabBar.delegate = self;
    self.tabBar.pagingEnabled = NO;
    self.tabBar.showsHorizontalScrollIndicator = NO;
    self.tabBar.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tabBar];
    
    [self initTabViews];
    
    
}


-(void)initTabViews{
    
    self.tabBar.contentSize = CGSizeMake(self.tabWidth * self.count, 50);
    
    if([self.dataSource respondsToSelector:@selector(slidePager:viewForTabAtIndex:)]){
        self.tabViews = [[NSMutableArray alloc]init];
        for(NSUInteger i = 0;i < self.count;i++){
            
            UIView *tabViewContent = [self.dataSource slidePager:self viewForTabAtIndex:i];
            UIView *tabView = [[UIView alloc]initWithFrame:CGRectMake(i*self.tabWidth, 0, self.tabWidth, self.tabHeight)];
            tabView.tag = i;
            [tabView addSubview:tabViewContent];
            
            UITapGestureRecognizer *tabViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabBarButtonTap:)];
            [tabView addGestureRecognizer:tabViewTapGesture];
            [self.tabBar addSubview:tabView];
            
        }
        
    }
    
}


-(void)initPageScrollView{
    
    self.pageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.tabHeight, self.view.frame.size.width, self.view.frame.size.height - self.tabHeight)];
    self.pageScrollView.backgroundColor = [UIColor colorWithRed:250.0/255.0f green:250.0/255.0f blue:250.0/255.0f alpha:1.0f];
    self.pageScrollView.delegate = self;
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.pageScrollView];
    
    
    [self initPageScrollViews];
    
}

-(void)initPageScrollViews{
    
    self.pageScrollView.contentSize = CGSizeMake(self.count * self.view.frame.size.width, self.view.frame.size.height - self.tabHeight);
    
    for(NSUInteger i = 0;i < self.count;i++){
        UIViewController *contentViewController = [self.dataSource slidePager:self contentViewControllerForTabAtIndex:i];
        
        [self addChildViewController:contentViewController];
        contentViewController.view.frame = CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabHeight);
        [self.viewControllers addObject:contentViewController];
        [self.pageScrollView addSubview:contentViewController.view];


    }

    //选中第一个
    if ([self.delegate respondsToSelector:@selector(slidePager:didChangeTabToIndex:)]) {
        [self.delegate slidePager:self didChangeTabToIndex:0];

    }
    
}

-(void)tabBarButtonTap:(UITapGestureRecognizer *)sender{
    
    [self selectTabAtIndex:[sender.view tag]];
    [self selectContentViewControllerAtIndex:[sender.view tag]];
    
}


-(void)selectTabAtIndex:(NSUInteger)index{
    
    self.activeTabIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(slidePager:didChangeTabToIndex:)]) {
        [self.delegate slidePager:self didChangeTabToIndex:self.activeTabIndex];
    }
    
}

-(void)selectContentViewControllerAtIndex:(NSUInteger)index{
    
    [self.pageScrollView setContentOffset:CGPointMake(index * self.view.frame.size.width, 0) animated:YES];
    
}

#pragma mark 主视图滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.pageScrollView) {
        
        int i = (int)scrollView.contentOffset.x/self.view.frame.size.width;
        if(i != self.activeTabIndex){
            [self selectTabAtIndex:i];
        }
        
    }
}


@end
