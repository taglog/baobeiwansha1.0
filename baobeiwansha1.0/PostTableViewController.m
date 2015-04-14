//
//  PostTableViewController.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "PostTableViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface PostTableViewController ()

@property (nonatomic,assign)BOOL reloading;

@property (nonatomic,retain)EGORefreshView *refreshHeaderView;

@property (nonatomic,retain)EGORefreshView *refreshFooterView;

@property (nonatomic,retain) UITableView *postTableView;

@property (nonatomic,strong) NSMutableArray *postTableArray;

@property (nonatomic,retain)AppDelegate *appDelegate;

@property (nonatomic,strong)UILabel *noDataAlert;

@property (nonatomic,strong)UIView *tableViewMask;

@property(nonatomic,assign)BOOL collectButtonEnabled;

@end
@implementation PostTableViewController
-(id)initWithURL:(NSDictionary *)dict type:(NSInteger)index{
    
    self = [super init];
    if(self){
        self.p = 2;
        self.requestURL = dict;
        self.type = index;
        
        //变量设置
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self defaultSettings];
    [self initViews];
    
}






-(void)defaultSettings{
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0f];
    //    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
    //    self.title = @"PostList";
    //    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    //    self.navigationController.navigationBar.titleTextAttributes = dict;
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
-(void)initViews{
    
    //初始化homeTableViewCell
    self.postTableArray = [[NSMutableArray alloc]init];
    
    [self initTableView];
    [self initRefreshHeaderView];
    [self simulatePullDownRefresh];
    
}

//初始化tableView
-(void)initTableView{
    
    
    if(!self.postTableView){
        self.postTableView = [[UITableView alloc] init];
        self.postTableView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - 64 - 50);
        self.postTableView.delegate = self;
        self.postTableView.dataSource = self;
        
        self.tableViewMask = [UIView new];
        self.tableViewMask.backgroundColor =[UIColor clearColor];
        self.postTableView.tableFooterView = self.tableViewMask;
        self.postTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    [self.view addSubview:self.postTableView];
    
    
}
//初始化下拉刷新header
-(void)initRefreshHeaderView{
    
    //初始化headerView
    if(!self.refreshHeaderView){
        self.refreshHeaderView = [[EGORefreshView alloc] initWithScrollView:self.postTableView position:EGORefreshHeader ];
        self.refreshHeaderView.delegate = self;
        
        [self.postTableView addSubview:self.refreshHeaderView];
        
    }
    
}

-(void)initRefreshFooterView{
    
    if(!self.refreshFooterView){
        
        self.refreshFooterView = [[EGORefreshView alloc] initWithScrollView:self.postTableView position:EGORefreshFooter];
        self.refreshFooterView.delegate = self;
        
        self.postTableView.tableFooterView = self.refreshFooterView;
    }
    
}

//如果没有数据，那么要告诉用户表是空的
-(void)showNoDataAlert{
    
    
    
    self.tableViewMask = [UIView new];
    self.tableViewMask.backgroundColor =[UIColor clearColor];
    self.postTableView.tableFooterView = self.tableViewMask;
    
    if(self.noDataAlert == nil){
        self.noDataAlert = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, self.view.frame.size.width, 40.0f)];
        self.noDataAlert.text = @"暂时没有内容哦~";
        self.noDataAlert.textAlignment = NSTextAlignmentCenter;
        self.noDataAlert.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        self.noDataAlert.textAlignment = NSTextAlignmentCenter;
        self.noDataAlert.font = [UIFont systemFontOfSize:14.0f];
        [self.postTableView addSubview:self.noDataAlert];
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
    
    [cell setDataWithDict:self.postTableArray[indexPath.row] frame:self.view.frame indexPath:indexPath];
    
    cell.delegate = self;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击后更改cell的点击状态
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:
                                 self.postTableArray[indexPath.row]];
    [dict setObject:[NSNumber numberWithInteger:1] forKey:@"isCellTapped"];
    [self.postTableArray replaceObjectAtIndex:indexPath.row withObject:dict];
    [self.postTableView reloadData];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    PostViewController *post = [[PostViewController alloc] init];
    post.hidesBottomBarWhenPushed = YES;
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[self.postTableArray[indexPath.row] valueForKey:@"ID"],@"postID",self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"/post/post";
    
    
    [post initWithRequestURL:postRouter requestParam:requestParam];
    
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
    
    [self.refreshHeaderView setState:EGOOPullRefreshLoading];
    self.postTableView.contentOffset = CGPointMake(0, -60);
    
    [self performPullDownRefresh];
}

-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
    
    //请求的地址
    postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //是否选择了年龄，如果没有选择，就默认读取用户在数据库的年龄
    if(self.isAgeSet){
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInt:1],@"p",[NSNumber numberWithInteger:self.ageChoosen],@"age",nil];
        
    }else{
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInt:1],@"p",nil];
    }
    NSLog(@"%@",postParam);
    NSLog(@"%@",urlString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"%@",responseObject);
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
                self.postTableView.tableFooterView = self.tableViewMask;
                
            }
            
            [self.postTableView reloadData];
            self.p = 2;
            
        }else{
            
            [self showNoDataAlert];
        }
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self.delegate showHUD:@"网络请求失败~"];
        [self.delegate dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    
}
-(void)performPullUpRefresh{
    
    _reloading = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
    
    
    postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if(self.isAgeSet){
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInteger:self.p],@"p",[NSNumber numberWithInteger:self.ageChoosen],@"age",nil];
    }else{
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInteger:self.p],@"p",nil];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        if(responseArray != (id)[NSNull null]){
            
            for(NSDictionary *responseDict in responseArray){
                
                [self.postTableArray addObject:responseDict];
                
            }
            
            [self.postTableView reloadData];
            self.p++;
            
        }else{
            //如果是最后一页
            [self.delegate showHUD:@"已经是最后一页了"];
            [self.delegate dismissHUD];
            
            
            
        }
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self.delegate showHUD:@"网络请求失败~"];
        [self.delegate dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    
}
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.postTableView];
    [self.refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.postTableView];
    
    
}


#pragma mark - EGOPullRefreshDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [self.refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [self.refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
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
    NSLog(@"%@",collectParam);
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
    
    PostTableViewCell *cell = (PostTableViewCell *)[self.postTableView cellForRowAtIndexPath:indexPath];
    
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
    
}

@end
