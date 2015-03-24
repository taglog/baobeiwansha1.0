//
//  ContentViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "TagPostTableViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "JGProgressHUD.h"

@interface TagPostTableViewController ()

@property (nonatomic,assign) NSInteger tagID;

@property (nonatomic,assign) BOOL isTagIDSet;

@property (nonatomic,retain) UITableView *homeTableView;

@property (nonatomic,strong) NSMutableArray *postTableArray;
//刷新 view
@property (nonatomic,retain) EGORefreshView *refreshHeaderView;

@property (nonatomic,retain) EGORefreshView *refreshFooterView;

@property (nonatomic,assign) BOOL reloading;

@property (nonatomic,retain) AppDelegate *appDelegate;

@property (nonatomic,strong) JGProgressHUD *HUD;

@property (nonatomic,strong) UILabel *noDataAlert;

@property (nonatomic,strong) UIView *tableViewMask;

@property (nonatomic,assign) NSInteger p;
@end

@implementation TagPostTableViewController

-(id)initWithURL:(NSDictionary *)dict tagID:(NSInteger)tagID tag:(NSString *)tag{
    self = [super init];
    self.isTagIDSet = YES;
    self.p = 2;
    self.requestURL = dict;
    self.tag = tag;
    self.tagID = tagID;
    
    self.view.backgroundColor = [UIColor whiteColor];
    return self;
    
}

-(id)initWithURL:(NSDictionary *)dict tag:(NSString *)tag{
    self = [super init];
    self.isTagIDSet = NO;
    self.p = 2;
    self.requestURL = dict;
    self.tag = tag;
    
    self.view.backgroundColor = [UIColor whiteColor];
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self defaultSettings];
    
    self.navigationItem.title = self.tag;
    
    if(self){
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [self initViews];
        
    }
}

-(void)defaultSettings{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
        
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
    
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
    self.postTableArray = [[NSMutableArray alloc]init];
    
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
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return self.postTableArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"List";
    
    //创建cell
    PostTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if(self.postTableArray[indexPath.row]){
        [cell setDataWithDict:self.postTableArray[indexPath.row] frame:self.view.frame indexPath:indexPath];
    }
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
    PostViewController *post = [[PostViewController alloc] init];
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[self.postTableArray[indexPath.row] objectForKey:@"ID"],@"postID",self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"/post/post";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        
        if(responseDict != (id)[NSNull null]){
            [post initViewWithDict:responseDict];
            post.indexPath = indexPath;
            post.delegate = self;
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
    NSDictionary *postParam;
    
    if (self.isTagIDSet == YES) {
        postParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:1],@"p", [NSNumber numberWithInteger:self.tagID],@"tagID",nil];
    }else{
        postParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:1],@"p",self.tag,@"tag",nil];
    }
    NSLog(@"%@",postParam);
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        //NSLog(@"%@",responseObject);
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            
            [self.postTableArray removeAllObjects];
            
            if(self.noDataAlert){
                self.noDataAlert.hidden = YES;
                [self.noDataAlert removeFromSuperview];
            }
            
            for(NSDictionary *responseDict in responseArray){
                [self.postTableArray addObject:responseDict];
            }
            if([self.postTableArray count]>4){
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
    if (self.isTagIDSet == YES) {
        postParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.p],@"p",[NSNumber numberWithInteger:self.tagID],@"tagID",nil];
    }else{
        postParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.p],@"p",self.tag,@"tag",nil];
    }
    
    
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
                [self.postTableArray addObject:responseDict];
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

-(void)collectPost:(NSIndexPath *)indexPath{
    //如果之前没有收藏
    if([[[self.postTableArray objectAtIndex:indexPath.row] valueForKey:@"isCollection"] integerValue] == 0){
        
        [self updateCollectionCount:indexPath type:1];
        
    }else{
        //如果之前已经收藏
        
        [self updateCollectionCount:indexPath type:0];
        
    }
    
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSDictionary *collectParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:[[[self.postTableArray objectAtIndex:indexPath.row] valueForKey:@"ID"] integerValue]],@"postID", nil];
    
    NSString *collectRouter = @"/post/collect";
    NSString *collectRequestUrl = [self.appDelegate.rootURL stringByAppendingString:collectRouter];
    
    //进行收藏判断 userID,PostID
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:collectRequestUrl  parameters:collectParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSInteger status = [[responseObject valueForKey:@"status"]integerValue];
        
        if(status == 1){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionChanged" object:nil];

            
        }else{
            
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}


-(void)updateCollectionCount:(NSIndexPath *)indexPath type:(NSInteger)type{
    
    PostTableViewCell *cell = (PostTableViewCell *)[self.homeTableView cellForRowAtIndexPath:indexPath];
    
    NSInteger collectionNumber;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:
                                 self.postTableArray[indexPath.row]];
    
    //收藏成功，需+1
    if(type == 1){
        collectionNumber = [[self.postTableArray[indexPath.row] objectForKey:@"collection_count"]integerValue] + 1;
        [dict setObject:[NSNumber numberWithInteger:1] forKey:@"isCollection"];
        
    }else{
        collectionNumber = [[self.postTableArray[indexPath.row] objectForKey:@"collection_count"]integerValue] - 1;
        [dict setObject:[NSNumber numberWithInteger:0] forKey:@"isCollection"];
        
    }
    [dict setObject:[NSNumber numberWithInteger:collectionNumber] forKey:@"collection_count"];
    [self.postTableArray replaceObjectAtIndex:indexPath.row withObject:dict];
    
    [cell updateCollectionCount:collectionNumber type:type];
    
}@end
