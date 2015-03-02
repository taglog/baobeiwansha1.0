//
//  HomePageViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageProfileView.h"
#import "HomePageAbilityView.h"
#import "HomePageLocationView.h"
#import "HomePageTableView.h"

@interface HomePageViewController ()
@property (nonatomic,retain) UIScrollView *homeScrollView;
@end

@implementation HomePageViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"宝贝玩啥";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initViews];

}

-(void)initViews{

    [self initScrollView];
    //一共4个section
    [self initProfileView];
    [self initViewSection1];
    [self initViewSection2];
    [self initViewSection3];
    
}

-(void)initScrollView{
    
    if(!self.homeScrollView){
        self.homeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:self.homeScrollView];
        self.homeScrollView.backgroundColor = [UIColor colorWithRed:245.0/255.0f green:245.0/255.0f blue:245.0/255.0f alpha:1.0];
        self.homeScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 900);
        self.homeScrollView.delegate = self;
    }
}
-(void)initProfileView{
    
    HomePageProfileView *homePageProfileView = [[HomePageProfileView alloc]init];
    [homePageProfileView setDict:nil frame:self.view.frame];
    [self.homeScrollView addSubview:homePageProfileView];
    

}
-(void)initViewSection1{
    
    
    HomePageAbilityView *homePageAbilityView = [[HomePageAbilityView alloc]initWithFrame:CGRectMake(0, 260, self.view.frame.size.width, 160)];

    homePageAbilityView.title = @"这些潜能要大发展啦，快抓住时机跟我玩吧~";
    [self.homeScrollView addSubview:homePageAbilityView];

}

-(void)initViewSection2{
    
    HomePageLocationView *homePageLocationView = [[HomePageLocationView alloc]initWithFrame:CGRectMake(0, 435, self.view.frame.size.width, 175)];
    
    [self.homeScrollView addSubview:homePageLocationView];
    
    homePageLocationView.title = @"不同的场合，我要有不一样的玩法~";
    
    
}

-(void)initViewSection3{
    
    HomePageTableView *homePageTableView = [[HomePageTableView alloc]initWithFrame:CGRectMake(0, 620, self.view.frame.size.width, 225)];
    [self.homeScrollView addSubview:homePageTableView];
    
    
    homePageTableView.title = @"寓教于乐可没那么简单，父母也来学习吧~";
}

#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y < 0){
        CGPoint point = CGPointMake(0, 0);
        scrollView.contentOffset = point;
    }
    
    if(scrollView.contentOffset.y > 20){
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.alpha = 1;
        }];
    }
    
}

@end
