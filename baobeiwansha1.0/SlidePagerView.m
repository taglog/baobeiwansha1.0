//
//  SlidePagerView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/3.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "SlidePagerView.h"

#define kTabHeight 50.0
#define kTabWidth 105.0

@interface SlidePagerView ()

@property (nonatomic,retain) UIScrollView *tabBar;
@property (nonatomic,retain) UIScrollView *pageScrollView;

@property (nonatomic,retain) UIView *contentView;

@property (nonatomic,assign) NSUInteger count;
@property (nonatomic,assign) CGFloat tabWidth;
@property (nonatomic,assign) CGFloat tabHeight;

@property (nonatomic,retain) NSMutableArray *tabViews;
@property (nonatomic,retain) NSMutableArray *viewControllers;

@property (nonatomic,assign) NSUInteger activeIndex;

@end

@implementation SlidePagerView

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
    
    [self setNeedsLayout];
    
}

-(void)initTabBar{
    
    self.tabBar = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width,kTabHeight)];
    self.tabBar.backgroundColor = [UIColor colorWithRed:250.0/255.0f green:250.0/255.0f blue:250.0/255.0f alpha:1.0f];
    self.tabBar.delegate = self;
    self.tabBar.pagingEnabled = NO;
    self.tabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.tabBar];
    
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
    
    self.pageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTabHeight, self.frame.size.width, self.frame.size.height - kTabHeight)];
    self.pageScrollView.backgroundColor = [UIColor grayColor];
    self.pageScrollView.delegate = self;
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.pageScrollView];

//    [self.pageScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    
    [self initPageScrollViews];
    
}
-(void)initPageScrollViews{
    
    self.pageScrollView.contentSize = CGSizeMake(self.count * self.frame.size.width, self.frame.size.height - self.tabHeight);
    
    for(NSUInteger i = 0;i < self.count;i++){
        UIViewController *contentViewController = [self.dataSource slidePager:self contentViewControllerForTabAtIndex:i];
        [self.viewControllers addObject:contentViewController];
        
        contentViewController.view.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - self.tabHeight);
        [self.pageScrollView addSubview:contentViewController.view];
        

    }
    
}

-(void)tabBarButtonTap:(UITapGestureRecognizer *)sender{
    
    NSLog(@"%ld",(long)[sender.view tag]);
    [self selectTabAtIndex:[sender.view tag]];
    
}

-(void)selectTabAtIndex:(NSUInteger)index{
    self.activeIndex = index;
}


@end

