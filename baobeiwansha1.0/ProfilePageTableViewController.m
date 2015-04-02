//
//  ProfileTableViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/14.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "ProfilePageTableViewController.h"
#import "TabView.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"


@interface ProfilePageTableViewController ()

@property (nonatomic,retain) TabView *tabView0;
@property (nonatomic,retain) TabView *tabView1;
@property (nonatomic,retain) TabView *tabView2;
@property (nonatomic,retain) TabView *tabView3;

@property (nonatomic,retain) PostTableViewController *postTableViewController0;
@property (nonatomic,retain) PostTableViewController *postTableViewController1;
@property (nonatomic,retain) PostTableViewController *postTableViewController2;
@property (nonatomic,retain) PostTableViewController *postTableViewController3;

//指示层
@property (nonatomic,strong)JGProgressHUD *HUD;
@property (nonatomic,assign)BOOL isHudShow;

@end
@implementation ProfilePageTableViewController

-(id)initWithUrl:(NSDictionary *)url title:(NSString *)title{
    self = [super init];
    self.requestUrl = url;
    self.navigationTitle = title;
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self defaultSettings];
    [self initViews];
    
}

-(void)defaultSettings{
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithRed:255.0/255.0f green:119/255.0f blue:119/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = self.navigationTitle;
    
}
-(void)initLeftBarButton{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initViews{
    
    [self initLeftBarButton];
    [self initTabViews];
    [self initPageContentViews];
    [self initSlidePagerView];
    
}

-(void)initTabViews{
    
    self.tabView0 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView0 setNormalIcon:[UIImage imageNamed:@"titlebar_book_gray"] highlightIcon:[UIImage imageNamed:@"titlebar_book"] tabTitle:@"绘本"];
    self.tabView1 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView1 setNormalIcon:[UIImage imageNamed:@"titlebar_toy_gray"] highlightIcon:[UIImage imageNamed:@"titlebar_toy"] tabTitle:@"玩具"];
    self.tabView2 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView2 setNormalIcon:[UIImage imageNamed:@"titlebar_game_gray"] highlightIcon:[UIImage imageNamed:@"titlebar_game"] tabTitle:@"游戏"];
    self.tabView3 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView3 setNormalIcon:[UIImage imageNamed:@"titlebar_game_gray"] highlightIcon:[UIImage imageNamed:@"titlebar_game"] tabTitle:@"建议"];
    
}

-(void)initPageContentViews{
    
    self.postTableViewController0 = [[PostTableViewController alloc]initWithURL:self.requestUrl type:1];
    self.postTableViewController0.delegate = self;
    self.postTableViewController1 = [[PostTableViewController alloc]initWithURL:self.requestUrl type:2];
    self.postTableViewController1.delegate = self;
    self.postTableViewController2 = [[PostTableViewController alloc]initWithURL:self.requestUrl type:3];
    self.postTableViewController2.delegate = self;
    self.postTableViewController3 = [[PostTableViewController alloc]initWithURL:self.requestUrl type:4];
    self.postTableViewController3.delegate = self;
    
}
-(void)initSlidePagerView{
    
    SlidePagerViewController *slidePager = [[SlidePagerViewController alloc]init];
    slidePager.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    
    slidePager.delegate = self;
    slidePager.dataSource = self;
    
    [slidePager renderViews];
    
    [self.view addSubview:slidePager.view];
    [self addChildViewController:slidePager];
    
    
}

#pragma mark slidPagerDelegate
-(NSUInteger)numberOfTabsForSlidePager:(SlidePagerViewController *)slideView{
    
    return 4;
}

-(UIView *)slidePager:(SlidePagerViewController *)slideView viewForTabAtIndex:(NSUInteger)index{
    
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
            
        case 3:
            tabView = self.tabView3;
            break;
        default:
            break;
    }
    
    return tabView;
    
}

-(UIViewController *)slidePager:(SlidePagerViewController *)slidePager contentViewControllerForTabAtIndex:(NSUInteger)index{
    
    PostTableViewController *vc;
    
    switch (index) {
        case 0:
            vc = self.postTableViewController0;
            break;
        case 1:
            vc = self.postTableViewController1;
            break;
        case 2:
            vc = self.postTableViewController2;
            break;
        case 3:
            vc = self.postTableViewController3;
            break;
        default:
            break;
    }
    
    return vc;
    
}

-(CGFloat)slidePager:(SlidePagerViewController *)slidePager valueForOption:(SlidePagerOption)option withDefault:(CGFloat)value{
    
    switch (option) {
            
        case SlidePagerOptionTabHeight:
            return 50.0f;
        case SlidePagerOptionTabWidth:
            return self.view.frame.size.width/4.0;
        default:
            return value;
    }
    
}

-(void)slidePager:(SlidePagerViewController *)slidePager didChangeTabToIndex:(NSUInteger)index{
    
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
        case 3:
            [self.tabView3 setTabToHighlight];
            break;
        default:
            break;
    }
    
    
    
}
-(void)resetTabViewState{
    
    [self.tabView0 setTabToNormal];
    [self.tabView1 setTabToNormal];
    [self.tabView2 setTabToNormal];
    [self.tabView3 setTabToNormal];

    
}
-(void)showHUD:(NSString*)text{
    //初始化HUD
    if(self.isHudShow == YES){
        [self.HUD dismissAnimated:NO];
    }
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = text;
    [self.HUD showInView:self.view];
    self.isHudShow = YES;
    
}
-(void)dismissHUD{
    [self.HUD dismissAfterDelay:1.0];
    self.isHudShow = NO;
}

@end
