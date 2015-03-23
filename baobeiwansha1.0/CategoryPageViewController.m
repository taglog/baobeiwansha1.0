//
//  PlayPageViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "CategoryPageViewController.h"
#import "TabView.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "TagPageViewController.h"

@interface CategoryPageViewController ()

@property (nonatomic,retain) TabView *tabView0;
@property (nonatomic,retain) TabView *tabView1;
@property (nonatomic,retain) TabView *tabView2;

@property (nonatomic,retain) PostTableViewController *postTableViewController0;
@property (nonatomic,retain) PostTableViewController *postTableViewController1;
@property (nonatomic,retain) PostTableViewController *postTableViewController2;

//刷新年龄
@property (nonatomic,strong) UITableView *ageTableView;
@property (nonatomic,retain) UIButton *ageFilterButton;
@property (nonatomic,retain) UIImageView *ageFilterButtonIcon;
@property (nonatomic,retain) UILabel *ageTitleLabel;
@property (nonatomic,retain) UIButton *mask;
@property (nonatomic,assign) BOOL isAgeTableViewShow;

@property (nonatomic,assign) BOOL isFirstLoad;
@property (nonatomic,assign) NSUInteger activeTabIndex;

//记录上一次和下一次的月份
@property (nonatomic,assign) NSInteger beforeMonth;
@property (nonatomic,assign) NSInteger activeMonth;

//用户生日，和转换为字符串的生日
@property (nonatomic,assign) int babyBirthdayMonth;
@property (nonatomic,retain) NSString *babyBirthday;

//刷新的标识，每次更改年龄后把标识置为NO，这样切换到tab就会自动刷新
@property (nonatomic,assign) BOOL isRefreshed0;
@property (nonatomic,assign) BOOL isRefreshed1;
@property (nonatomic,assign) BOOL isRefreshed2;
@property (nonatomic,assign) BOOL isRefreshed3;

//指示层
@property (nonatomic,strong)JGProgressHUD *HUD;
@property (nonatomic,assign)BOOL isHudShow;

@property (nonatomic,retain)AppDelegate *appDelegate;

@end
@implementation CategoryPageViewController

-(id)init{
    
    self = [super init];
    self.isFirstLoad = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


-(void)initViews{
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self initRightBarButton];
    [self initTitleView];
    [self initUserInfo];
    
    [self initTabViews];
    [self initPageContentViews];
    [self initSlidePagerView];
    
    
    [self initAgeTableView];

    
}

#pragma mark - 初始化views
-(void)initRightBarButton{
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pushTagPageViewController)];
    rightBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}
-(void)pushTagPageViewController{
    TagPageViewController *tagPageViewController = [[TagPageViewController alloc]init];
    [self.navigationController pushViewController:tagPageViewController animated:YES];
}
-(void)initTitleView{
    
    if(self.ageFilterButton == nil){
        self.ageFilterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
        
        self.ageTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
        self.ageTitleLabel.text = @"";
        self.ageTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.ageTitleLabel.textColor = [UIColor colorWithRed:255.0/255.0f green:119/255.0f blue:119/255.0f alpha:1.0f];
        
        self.ageFilterButtonIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"drop_btn"]];
        self.ageFilterButtonIcon.tag = 1;
        self.ageFilterButtonIcon.frame = CGRectMake(100, 17, 10, 10);
        [self.ageFilterButton addTarget:self action:@selector(showAgeTableView) forControlEvents:UIControlEventTouchUpInside];
        
        [self.ageFilterButton addSubview:self.ageFilterButtonIcon];
        [self.ageFilterButton addSubview:self.ageTitleLabel];
        
        self.navigationItem.titleView = self.ageFilterButton;
    }
    
    
    
}

-(void)initUserInfo{
    
    [self getUserInfo];
    
    if(self.babyBirthday){
        if(self.ageTitleLabel){
            self.ageTitleLabel.text = self.babyBirthday;
        }
        self.beforeMonth = self.babyBirthdayMonth;
        self.activeMonth = self.babyBirthdayMonth;
        
    }
    
}
-(void)getUserInfo{
    
    // 取出存储的数据进行初始化
    NSString *filePath = [AppDelegate dataFilePath];
    
    //如果存在userinfo.plist
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSDate *date = [dict objectForKey:@"babyBirthday"];
        NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        int time = [timeStamp intValue];
        NSDate *nowDate = [NSDate date];
        NSString *nowStamp = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
        int now = [nowStamp intValue];
        
        int babyBirthdayStamp = now - time;
        self.babyBirthdayMonth = floor(babyBirthdayStamp/60/60/24/30);
        
        self.babyBirthday = [AppDelegate birthdayMonthToString:self.babyBirthdayMonth];
        
    }else{
        self.babyBirthdayMonth = 0;
        
        self.babyBirthday = [AppDelegate birthdayMonthToString:0];
        
    }
}



-(void)initAgeTableView{
    //增加一个遮罩层
    if(self.mask == nil){
        self.mask = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.mask.hidden = YES;
        [self.mask addTarget:self action:@selector(hideAgeTableView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.mask];
        
        
    }
    //初始化选择年龄tableview
    if(self.ageTableView == nil){
        
        self.ageTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 70, 30, 140, 200)];
        self.ageTableView.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        self.ageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.ageTableView.tag = 1;
        
        self.ageTableView.layer.cornerRadius = 5.0;
        self.ageTableView.delegate = self;
        self.ageTableView.dataSource = self;
        self.ageTableView.alpha = 0;
        self.ageTableView.hidden = YES;
        [self.view addSubview:self.ageTableView];
        self.isAgeTableViewShow = NO;
    }

}

-(void)initTabViews{
    
    self.tabView0 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView0 setNormalIcon:[UIImage imageNamed:@"titlebar_book_gray"] highlightIcon:[UIImage imageNamed:@"titlebar_book"] tabTitle:@"绘本"];
    self.tabView1 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView1 setNormalIcon:[UIImage imageNamed:@"titlebar_toy_gray"] highlightIcon:[UIImage imageNamed:@"titlebar_toy"] tabTitle:@"玩具"];
    self.tabView2 = [[TabView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width/3, 50.0)];
    [self.tabView2 setNormalIcon:[UIImage imageNamed:@"titlebar_game_gray"] highlightIcon:[UIImage imageNamed:@"titlebar_game"] tabTitle:@"游戏"];
    
}

-(void)initPageContentViews{
    
    self.postTableViewController0 = [[PostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/category"} type:1];
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
    
    self.activeTabIndex = index;
    
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
    
    if(self.beforeMonth != self.activeMonth){
        
        [self refreshActiveViewController];
        
    }
    
}
-(void)resetTabViewState{
    
    [self.tabView0 setTabToNormal];
    [self.tabView1 setTabToNormal];
    [self.tabView2 setTabToNormal];
    
}
#pragma mark - ageTableViewDelegate&dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  73;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *ID = @"ageList";
    
    //创建cell
    UITableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:0.9];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    //如果是用户当前月份，显示两个点
    if(indexPath.row == self.babyBirthdayMonth){
        
        cell.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:0.8];
        
    }        //不是用户当前的月份
    
    cell.textLabel.text = [AppDelegate birthdayMonthToString:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:0.8];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //如果选择的年龄和原来的年龄不一样，就进行刷新，如果一样就不进行刷新
    if(self.activeMonth != indexPath.row){
        
        self.beforeMonth = self.activeMonth;
        self.activeMonth = indexPath.row;
        
        //更改title上的年龄
        self.ageTitleLabel.text = [AppDelegate birthdayMonthToString:indexPath.row];
        
        [self resetAgeOfContentViewController:indexPath.row];
        
        [self resetRefreshStatus];
        
        //当前active的页面先刷新
        [self refreshActiveViewController];
        
        [self hideAgeTableView];
    }
}

#pragma mark - 修改日期
-(void)showAgeTableView{
    
    if(self.isFirstLoad == YES){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.babyBirthdayMonth inSection:0];
        [self.ageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        self.isFirstLoad = NO;
        
        
    }
    
    if(self.isAgeTableViewShow == NO){
        [UIView animateWithDuration:0.2
                              delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                  self.ageFilterButtonIcon.transform = CGAffineTransformMakeRotation(-3.14f);
                                  self.ageTableView.hidden = NO;
                                  self.mask.hidden = NO;
                                  self.ageTableView.frame = CGRectMake(self.view.frame.size.width/2 - 70, 70, 140, 200);
                                  self.ageTableView.alpha = 1.0;
                                  
                                  
                              } completion:^(BOOL finished) {
                                  self.isAgeTableViewShow = YES;
                              }];}
    else{
        [self hideAgeTableView];
    }
    
}

-(void)hideAgeTableView{
    [UIView animateWithDuration:0.2
                          delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                              self.ageFilterButtonIcon.transform = CGAffineTransformMakeRotation(0);
                              
                              self.ageTableView.frame = CGRectMake(self.view.frame.size.width/2 - 70, 30, 140, 200);
                              self.ageTableView.alpha = 0.0;
                              
                              
                          } completion:^(BOOL finished) {
                              self.mask.hidden = YES;
                              self.ageTableView.hidden = YES;
                              self.isAgeTableViewShow = NO;
                              
                          }];
}

//重置状态为未刷新
-(void)resetRefreshStatus{
    
    //重新设置controller为未刷新状态，这样切换到这个页面的时候就会自动刷新
    self.isRefreshed0 = NO;
    self.isRefreshed1 = NO;
    self.isRefreshed2 = NO;
    self.isRefreshed3 = NO;
    //更改日期之后，每个controller实例的刷新参数都要恢复为2
    self.postTableViewController0.p = 2;
    self.postTableViewController1.p = 2;
    self.postTableViewController2.p = 2;
    
    
}
-(void)resetAgeOfContentViewController:(NSInteger)age{
    
    //更改目录页刷新的age
    self.postTableViewController0.ageChoosen = age;
    self.postTableViewController0.isAgeSet = YES;
    self.postTableViewController1.ageChoosen = age;
    self.postTableViewController1.isAgeSet = YES;
    self.postTableViewController2.ageChoosen = age;
    self.postTableViewController2.isAgeSet = YES;
    
}
//刷新页面
-(void)refreshActiveViewController{
    
    switch(self.activeTabIndex){
        case 0:
            if(!self.isRefreshed0){
                [self.postTableViewController0 simulatePullDownRefresh];
                self.isRefreshed0 = YES;
            }
            break;
            
        case 1:
            if(!self.isRefreshed1){
                [self.postTableViewController1 simulatePullDownRefresh];
                self.isRefreshed1 = YES;
            }
            
            break;
            
        case 2:
            if(!self.isRefreshed2){
                [self.postTableViewController2 simulatePullDownRefresh];
                self.isRefreshed2 = YES;
            }
            break;
            
        
            break;
        default:
            break;
    }
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
