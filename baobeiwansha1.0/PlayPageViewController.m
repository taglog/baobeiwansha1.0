//
//  PlayPageViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "PlayPageViewController.h"
#import "TabView.h"
#import "PostTableViewController.h"
#import "PlayPageContentViewController.h"

@interface PlayPageViewController ()

@property (nonatomic,retain) TabView *tabView0;
@property (nonatomic,retain) TabView *tabView1;
@property (nonatomic,retain) TabView *tabView2;

@property (nonatomic,retain) PlayPageContentViewController *playPageContentViewController0;
@property (nonatomic,retain) PostTableViewController *postTableViewController1;
@property (nonatomic,retain) PostTableViewController *postTableViewController2;

@end
@implementation PlayPageViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.title = @"玩啥";
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initViews];
}

-(void)initViews{
    
    [self initTabViews];
    [self initPageContentViews];
    [self initSlidePagerView];
    
}
-(void)initTabViews{
    
    self.tabView0 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView0 setNormalIcon:[UIImage imageNamed:@"home"] highlightIcon:[UIImage imageNamed:@"home"] tabTitle:@"绘本"];
    self.tabView1 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView1 setNormalIcon:[UIImage imageNamed:@"home"] highlightIcon:[UIImage imageNamed:@"home"] tabTitle:@"玩具"];
    self.tabView2 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView2 setNormalIcon:[UIImage imageNamed:@"home"] highlightIcon:[UIImage imageNamed:@"home"] tabTitle:@"游戏"];
    
}
-(void)initPageContentViews{
    
    self.playPageContentViewController0 = [[PlayPageContentViewController alloc]init];
    self.postTableViewController1 = [[PostTableViewController alloc]init];
    self.postTableViewController2 = [[PostTableViewController alloc]init];
    
    
}

-(void)initSlidePagerView{
    
    SlidePagerView *slidePager = [[SlidePagerView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    
    slidePager.delegate = self;
    slidePager.dataSource = self;
    
    [slidePager renderViews];
    
    [self.view addSubview:slidePager];
    
}

-(NSUInteger)numberOfTabsForSlidePager:(SlidePagerView *)slideView{
    
    return 3;
}

-(UIView *)slidePager:(SlidePagerView *)slideView viewForTabAtIndex:(NSUInteger)index{
    
    TabView *tabView;
    switch (index) {
        case 0:
            tabView = self.tabView0;
            break;
            
        case 1:
            tabView = self.tabView1;
            break;
            
        case 2:
            tabView = self.tabView2;
            break;
            
        default:
            break;
    }
    
    return tabView;
    
}

-(UIViewController *)slidePager:(SlidePagerView *)slidePager contentViewControllerForTabAtIndex:(NSUInteger)index{
    
    PlayPageContentViewController *vc;
    
    switch (index) {
        case 0:
            vc = self.playPageContentViewController0;
            break;
        case 1:
            vc = self.postTableViewController1;
            break;
        case 2:
            vc = self.postTableViewController2;
            break;
        default:
            break;
    }
    
    return vc;
    
}

-(CGFloat)slidePager:(SlidePagerView *)slidePager valueForOption:(SlidePagerOption)option withDefault:(CGFloat)value{
    
    switch (option) {
       
        case SlidePagerOptionTabHeight:
            return 50.0f;
        case SlidePagerOptionTabWidth:
            return self.view.frame.size.width/3.0;
        default:
            return value;
    }
    
}

-(void)slidePager:(SlidePagerView *)slidePager didChangeTabToIndex:(NSUInteger)index{
    
    [self resetTabViewState];
    
    switch (index) {
        case 0:
            [self.tabView0 setTabToHighlight];
            break;
        case 1:
            [self.tabView1 setTabToHighlight];
            break;
        case 2:
            [self.tabView2 setTabToHighlight];
            break;
        default:
            break;
    }
    
}
-(void)resetTabViewState{
    [self.tabView0 setTabToNormal];
    [self.tabView1 setTabToNormal];
    [self.tabView2 setTabToNormal];
}
@end
