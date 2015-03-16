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

@property (nonatomic,retain) PostTableViewController *postTableViewController0;
@property (nonatomic,retain) PostTableViewController *postTableViewController1;
@property (nonatomic,retain) PostTableViewController *postTableViewController2;

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
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = self.navigationTitle;
    
}
-(void)initLeftBarButton{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
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
    [self.tabView0 setNormalIcon:[UIImage imageNamed:@"home"] highlightIcon:[UIImage imageNamed:@"home"] tabTitle:@"绘本"];
    self.tabView1 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView1 setNormalIcon:[UIImage imageNamed:@"home"] highlightIcon:[UIImage imageNamed:@"home"] tabTitle:@"玩具"];
    self.tabView2 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView2 setNormalIcon:[UIImage imageNamed:@"home"] highlightIcon:[UIImage imageNamed:@"home"] tabTitle:@"游戏"];
    
}

-(void)initPageContentViews{
    
    self.postTableViewController0 = [[PostTableViewController alloc]initWithURL:self.requestUrl type:1];
    self.postTableViewController0.delegate = self;
    self.postTableViewController1 = [[PostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/category"} type:2];
    self.postTableViewController1.delegate = self;
    
    self.postTableViewController2 = [[PostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/category"} type:3];
    self.postTableViewController2.delegate = self;
    
    
    
}
-(void)initSlidePagerView{
    
    SlidePagerViewController *slidePager = [[SlidePagerViewController alloc]init];
    slidePager.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49);
    
    slidePager.delegate = self;
    slidePager.dataSource = self;
    
    [slidePager renderViews];
    
    [self.view addSubview:slidePager.view];
    [self addChildViewController:slidePager];
    
    
}

#pragma mark slidPagerDelegate
-(NSUInteger)numberOfTabsForSlidePager:(SlidePagerViewController *)slideView{
    
    return 3;
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
            return self.view.frame.size.width/3.0;
        default:
            return value;
    }
    
}

-(void)slidePager:(SlidePagerViewController *)slidePager didChangeTabToIndex:(NSUInteger)index{
    
    
}

#pragma mark - 指示层delegate
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