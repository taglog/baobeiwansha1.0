//
//  HomePageAdviceController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/19.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageAdviceController.h"
#import "HomePageTableViewCell.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "JGProgressHUD.h"

@interface HomePageAdviceController ()

@property (nonatomic,retain) UITableView *homePageAdviceTableView;
@property (nonatomic,retain) NSMutableArray *adviceArray;

@property (nonatomic,retain) UITableView *homeTableView;

//刷新 view
@property (nonatomic,retain) EGORefreshView *refreshHeaderView;

@property (nonatomic,retain) EGORefreshView *refreshFooterView;

@property (nonatomic,assign) BOOL reloading;

@property (nonatomic,retain) AppDelegate *appDelegate;

@property(nonatomic,strong) JGProgressHUD *HUD;

@property (nonatomic,strong) UILabel *noDataAlert;

@property (nonatomic,strong) UIView *tableViewMask;

@property (nonatomic,assign) NSInteger p;

@end
@implementation HomePageAdviceController

-(id)initWithURL:(NSDictionary *)dict{
    self = [super init];
    self.p = 2;
    self.requestURL = dict;
    self.view.backgroundColor = [UIColor whiteColor];
    return self;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.adviceArray = [[NSMutableArray alloc] initWithObjects:@{@"":@"",@"":@""},@{@"":@"",@"":@""},@{@"":@"",@"":@""}, nil];

    
    [self defaultSettings];
    
    self.navigationItem.title = @"智玩建议";
    
    if(self){
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [self initViews];
        
    }
}
-(void)defaultSettings{
    self.view.backgroundColor = [UIColor whiteColor];

    [self initLeftBarButton];
}
-(void)initLeftBarButton{
    
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)popViewController{
    
    [self.navigationController  popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)initViews{
    //初始化PostTableViewCell
    self.adviceArray = [[NSMutableArray alloc]init];
    
    [self initTableView];
    [self initRefreshHeaderView];
    [self simulatePullDownRefresh];
    
}

//初始化tableView
-(void)initTableView{
    
    
    if(_homeTableView == nil){
        _homeTableView = [[UITableView alloc] init];
        _homeTableView.frame = CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height - 24);
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        
        self.tableViewMask = [UIView new];
        self.tableViewMask.backgroundColor =[UIColor clearColor];
        _homeTableView.tableFooterView = self.tableViewMask;
        
        [_homeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_homeTableView];
    
    
}

//初始化下拉刷新header
-(void)initRefreshHeaderView{
    
    //初始化headerView
    if(_refreshHeaderView == nil){
        _refreshHeaderView = [[EGORefreshView alloc] initWithScrollView:_homeTableView position:EGORefreshHeader ];
        _refreshHeaderView.delegate = self;
        
        [_homeTableView addSubview:_refreshHeaderView];
        
    }
    
}
-(void)initRefreshFooterView{
    
    if(_refreshFooterView == nil){
        
        _refreshFooterView = [[EGORefreshView alloc] initWithScrollView:_homeTableView position:EGORefreshFooter];
        _refreshFooterView.delegate = self;
        
        _homeTableView.tableFooterView = _refreshFooterView;
    }
    
}

//如果没有数据，那么要告诉用户表是空的
-(void)showNoDataAlert{
    
    
    
    self.tableViewMask = [UIView new];
    self.tableViewMask.backgroundColor =[UIColor clearColor];
    _homeTableView.tableFooterView = self.tableViewMask;
    
    if(self.noDataAlert == nil){
        self.noDataAlert = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, self.view.frame.size.width, 40.0f)];
        self.noDataAlert.text = @"暂时没有内容哦~";
        self.noDataAlert.textAlignment = NSTextAlignmentCenter;
        self.noDataAlert.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        self.noDataAlert.textAlignment = NSTextAlignmentCenter;
        self.noDataAlert.font = [UIFont systemFontOfSize:14.0f];
        [_homeTableView addSubview:self.noDataAlert];
    }
    
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.adviceArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"List";
    
    //创建cell
    HomePageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if(self.adviceArray[indexPath.row]){
        [cell setDict:self.adviceArray[indexPath.row] frame:self.view.frame];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    PostViewController *post = [[PostViewController alloc] init];
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[self.adviceArray[indexPath.row] objectForKey:@"ID"],@"postID",self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"/post/post";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        
        if(responseDict != (id)[NSNull null]){
            [post initViewWithDict:responseDict];
            post.indexPath = indexPath;
        }else{
            [post noDataAlert];
        }
        [post dismissHUD];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [post dismissHUD];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    [post showHUD];
    [self.navigationController pushViewController:post animated:YES];
    
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

-(void)simulatePullDownRefresh{
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    _homeTableView.contentOffset = CGPointMake(0, -60);
    [self performPullDownRefresh];
}

-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    NSString *postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSDictionary *postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:1],@"p",nil];
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSLog(@"%@",postRequestUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            
            [self.adviceArray removeAllObjects];
            
            if(self.noDataAlert){
                self.noDataAlert.hidden = YES;
                [self.noDataAlert removeFromSuperview];
            }
            
            for(NSDictionary *responseDict in responseArray){
                [self.adviceArray addObject:responseDict];
            }
            if([self.adviceArray count]>4){
                if(self.tableViewMask){
                    self.tableViewMask = nil;
                    [self.tableViewMask removeFromSuperview];
                }
                [self initRefreshFooterView];
                
            }else{
                //去除分割线
                _homeTableView.tableFooterView = self.tableViewMask;
                
            }
            
            [_homeTableView reloadData];
            self.p = 2;
            
        }else{
            [self showHUD:@"没有内容~"];
            [self dismissHUD];
            [self showNoDataAlert];
            
        }
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        [self showHUD:@"网络请求失败~"];
        [self dismissHUD];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    
}
-(void)performPullUpRefresh{
    
    _reloading = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
    
    
    postRouter = [self.requestURL valueForKey:@"requestRouter"];
    
    postParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.p],@"p",nil];
    
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        if(responseArray == (id)[NSNull null]){
            //如果是最后一页
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            [self showHUD:@"已经是最后一页了~"];
            [self dismissHUD];
            
        }else{
            
            for(NSDictionary *responseDict in responseArray){
                [self.adviceArray addObject:responseDict];
            }
            [_homeTableView reloadData];
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            self.p++;
            
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        [self showHUD:@"网络请求失败~"];
        [self dismissHUD];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
}
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_homeTableView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_homeTableView];
    
}


#pragma mark - EGOPullRefreshDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshView *)view{
    
    [self reloadTableViewDataSource];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshView *)view{
    
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshView *)view{
    
    return [NSDate date];
    
}

-(void)showHUD:(NSString *)text{
    //显示hud层
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = text;
    [self.HUD showInView:self.view];
}

-(void)dismissHUD{
    [self.HUD dismiss];
}

@end
