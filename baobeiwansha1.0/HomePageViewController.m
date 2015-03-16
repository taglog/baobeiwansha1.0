//
//  HomePageViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageViewController.h"
#import "TagPageViewController.h"
#import "TagPostTableViewController.h"
#import "PostViewController.h"
#import "UserInfoSettingViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface HomePageViewController ()
@property (nonatomic,retain) UIScrollView *homeScrollView;
@property (nonatomic,assign) BOOL isNavigationHidden;
@property (nonatomic,retain) NSMutableDictionary *userInfoDict;
@property (nonatomic,assign) int babyDay;
@property (nonatomic,assign) int babyMonth;
@property (nonatomic,retain) HomePageProfileView *homePageProfileView;
@property (nonatomic,retain) HomePageAbilityView *homePageAbilityView;
@property (nonatomic,retain) HomePageLocationView *homePageLocationView;
@property (nonatomic,retain) HomePageTableView *homePageTableView;

@property (nonatomic,retain) NSDictionary *responseDict;

@property (nonatomic,retain) NSDictionary *abilityDict;
@property (nonatomic,retain) NSArray *locationArray;
@property (nonatomic,retain) NSArray *postArray;

@property (nonatomic,retain) AppDelegate *appDelegate;
@property (nonatomic,assign) CGFloat navBarAlpha;


@end

@implementation HomePageViewController

-(id)init{
    self = [super init];
    self.isNavigationHidden = NO;
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setNavigationBarTransparent];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.isNavigationHidden == YES){
        [self setNavigationBarColorWithAlpha:self.navBarAlpha];
        
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self setNavigationBarColorWithAlpha:1.0f];
    
    
    
}

-(void)setNavigationBarTransparent{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationController.navigationBar.alpha = 1.0f;

    
}

-(void)setNavigationBarColorWithAlpha:(CGFloat)alpha{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationController.navigationBar.alpha = alpha;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"宝贝玩啥";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.responseDict = [[NSDictionary alloc]init];
    self.locationArray = [[NSArray alloc]init];
    self.postArray = [[NSArray alloc]init];
    
    [self initUserInfo];
    [self getInfoFromServer];
    [self initViews];

}

-(void)initUserInfo{
    
    // 取出存储的数据进行初始化
    NSString *filePath = [AppDelegate dataFilePath];
    
    //如果存在userinfo.plist
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.userInfoDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSDate *date = [self.userInfoDict objectForKey:@"babyBirthday"];
        NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        int time = [timeStamp intValue];
        NSDate *nowDate = [NSDate date];
        NSString *nowStamp = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
        int now = [nowStamp intValue];
        
        int babyBirthdayStamp = now - time;
        
        self.babyDay = floor(babyBirthdayStamp/60/60/24);
        
        self.babyMonth = floor(babyBirthdayStamp/60/60/24/30);
        
        NSString *babyMonthString = [AppDelegate birthdayMonthToString:self.babyMonth];
        
        [self.userInfoDict setObject:babyMonthString forKey:@"babyMonthString"];
        
        
    }
    
}

-(void)getInfoFromServer{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"index/home";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if(responseObject != nil){
            
            self.responseDict = [responseObject valueForKey:@"data"];
            self.abilityDict = [self.responseDict objectForKey:@"dailyMessage"];
            self.locationArray = [self.responseDict objectForKey:@"taglist"];
            self.postArray = [self.responseDict objectForKey:@"postlist"];
            [self.userInfoDict setObject:[self.abilityDict valueForKey:@"days_message"] forKey:@"days_message"];
            
            [self.homePageProfileView setDict:self.userInfoDict frame:self.view.frame];
            [self.homePageAbilityView setDict:self.abilityDict];

            [self.homePageLocationView setArray:self.locationArray];
            [self.homePageTableView setArray:self.postArray];
            
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"%@",error);
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }];
    
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
    
    self.homePageProfileView = [[HomePageProfileView alloc]init];
    self.homePageProfileView.delegate = self;
    [self.homeScrollView addSubview:self.homePageProfileView];
    

}

-(void)initViewSection1{
    
    self.homePageAbilityView = [[HomePageAbilityView alloc]initWithFrame:CGRectMake(0, 260, self.view.frame.size.width, 160)];
    
    self.homePageAbilityView.title = @"这些潜能要大发展啦，快抓住时机跟我玩吧~";
    self.homePageAbilityView.tag = 0;
    self.homePageAbilityView.delegate = self;
    [self.homeScrollView addSubview:self.homePageAbilityView];

}

-(void)initViewSection2{
    
    self.homePageLocationView = [[HomePageLocationView alloc]initWithFrame:CGRectMake(0, 430, self.view.frame.size.width, 175)];
    
    self.homePageLocationView.tag = 1;
    self.homePageLocationView.delegate = self;
    
    [self.homeScrollView addSubview:self.homePageLocationView];
    
    self.homePageLocationView.title = @"不同的场合，我要有不一样的玩法~";
    
}

-(void)initViewSection3{
    
    self.homePageTableView = [[HomePageTableView alloc]initWithFrame:CGRectMake(0, 615, self.view.frame.size.width, 225)];
    
    self.homePageTableView.tag = 2;
    self.homePageTableView.delegate = self;
    
    [self.homeScrollView addSubview:self.homePageTableView];
    
    
    self.homePageTableView.title = @"寓教于乐可没那么简单，父母也来学习吧~";
    
}

#pragma mark - sectionDelegateMethod

-(void)titleViewSelect:(id)sender{
    
    TagPageViewController *tagPageViewController = [[TagPageViewController alloc]init];
    tagPageViewController.hidesBottomBarWhenPushed = YES;
    
    switch ([[sender superview] tag]) {
        case 0:
            [self.navigationController pushViewController:tagPageViewController animated:YES];
            break;
        case 1:
            
            [self.navigationController pushViewController:tagPageViewController animated:YES];
            break;
        case 2:
            
            break;
        default:
            break;
    }
    
}

#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat startPointY = 20;
    CGFloat endPointY = 200;
    
    if(scrollView.contentOffset.y < 0){
        CGPoint point = CGPointMake(0, 0);
        scrollView.contentOffset = point;
        
    }
    
    if(scrollView.contentOffset.y >= startPointY && scrollView.contentOffset.y < endPointY){
        
        self.navBarAlpha = scrollView.contentOffset.y/(endPointY - startPointY);
        
        [self setNavigationBarColorWithAlpha:self.navBarAlpha];
        
        self.isNavigationHidden = YES;
        
    }else if(scrollView.contentOffset.y >= endPointY){
        
        [self setNavigationBarColorWithAlpha:1.0f];

    }else if(scrollView.contentOffset.y < startPointY){
        
        [self setNavigationBarTransparent];
        self.isNavigationHidden = NO;
    }
    
}

#pragma mark homePageModuleView
-(void)pushViewControllerWithSender:(id)sender moduleView:(UIView *)view{
    
    TagPostTableViewController *tagPostViewController;
    switch (view.tag) {
        case 0:
            tagPostViewController = [[TagPostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/tag"} tag:sender];
            tagPostViewController.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:tagPostViewController animated:YES];
            
            break;
            
        case 1:
            tagPostViewController = [[TagPostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/tag"} tag:sender];
            tagPostViewController.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:tagPostViewController animated:YES];
            
            break;
        case 2:
            [self pushPostViewController:[sender integerValue]];
            
            break;
        default:
            break;
    }
}

#pragma mark homePageProfileViewDelegate
-(void)pushProfilePageSettingViewController{
    
    UserInfoSettingViewController *profilePageSetting = [[UserInfoSettingViewController alloc]init];
    profilePageSetting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profilePageSetting animated:YES];
    
}

-(void)pushBabyConditionViewController{
    
    if([self.responseDict valueForKey:@"days_detail_post_id"]!= (id)[NSNull null]){
        [self pushPostViewController:[[self.responseDict valueForKey:@"days_detail_post_id"]integerValue]];

    }
}

-(void)pushPostViewController:(NSInteger)postID{

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    PostViewController *post = [[PostViewController alloc] init];
    post.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:postID],@"postID",self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"post/post";
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];

    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",postRequestUrl);
    NSLog(@"%@",requestParam);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        if(responseDict != (id)[NSNull null]){
            
            [post initViewWithDict:responseDict];
            
        }else{
            
            [post noDataAlert];
            
        }
        
        [post dismissHUD];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@",error);
              [post dismissHUD];
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }];
    [post showHUD];
    
    [self.navigationController pushViewController:post animated:YES];

}

@end
