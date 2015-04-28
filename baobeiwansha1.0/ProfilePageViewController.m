//
//  ProfilePageViewController.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/2/25.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "ProfilePageViewController.h"
#import "UserInfoSettingViewController.h"
#import "ProfilePageNoticeTableViewCell.h"
#import "ProfilePageCommentTableViewCell.h"
#import "ProfilePageCollectionTableViewCell.h"
#import "ProfilePageSystemSettingViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "PostViewController.h"
#import "ProfilePageTableViewController.h"
#import "ProfilePageNoticeTableViewController.h"

@interface ProfilePageViewController ()
@property (nonatomic,assign) BOOL initialized;

@property (nonatomic,assign) BOOL reloading;
@property (nonatomic,retain) EGORefreshView *refreshHeaderView;

@property (nonatomic,retain) UIScrollView *profilePageScrollView;

@property (nonatomic,retain) ProfilePageModuleView *profilePageNoticeView;
@property (nonatomic,retain) ProfilePageModuleView *profilePageCollectionView;
@property (nonatomic,retain) ProfilePageModuleView *profilePageCommentView;

@property (nonatomic,retain) AppDelegate *appDelegate;

@property (nonatomic,retain) NSMutableDictionary *responseDict;
@property (nonatomic,retain) NSMutableArray *responseCollection;
@property (nonatomic,retain) NSMutableArray *responseComment;
@property (nonatomic,retain) NSMutableArray *responseMessage;

@property (nonatomic,assign) NSInteger collectionCount;
@property (nonatomic,assign) NSInteger commentCount;
@property (nonatomic,assign) NSInteger messageCount;

@property (nonatomic,assign) BOOL isUserInfoChanged;

@end

@implementation ProfilePageViewController
-(id)init{
    self = [super init];
    if(self){
        
        self.initialized = YES;
        self.isUserInfoChanged = NO;

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ProfilePage"];
    if(self.isUserInfoChanged == YES){
        [self simulatePullDownRefresh];
        self.isUserInfoChanged = NO;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ProfilePage"];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.responseCollection = [[NSMutableArray alloc]init];
    self.responseComment = [[NSMutableArray alloc]init];
    self.collectionCount = 0;
    self.commentCount = 0;
    
    [self defaultSettings];
    [self initNotification];
    [self initProfilePageScrollView];
    [self initRefreshHeaderView];
    [self simulatePullDownRefresh];
    
}

-(void)defaultSettings{
    
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0f green:250.0/255.0f blue:250.0/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithRed:255.0/255.0f green:119/255.0f blue:119/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSettingController)];
    rightBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119/255.0f blue:119/255.0f alpha:1.0f];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.navigationItem.title = @"我的";

    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(void)initNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateAndRefreshWhenAppear:) name:@"messageChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToRefreshWhenAppear) name:@"collectionChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToRefreshWhenAppear) name:@"commentChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToRefreshWhenAppear) name:@"commentDelete" object:nil];

    
}


-(void)updateRemoteMessageStatus:(NSInteger)operation postID:(NSInteger)postID {
    //同时远程或者本地更新badge number，暂时使用本地更新的办法
    [self.appDelegate decNotificationNumber];
    
    //0:已读, 1:删除, 2:设置未读标记
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:operation], @"op", [NSNumber numberWithInteger:postID], @"postID", nil];
    
    NSString *postRouter = @"post/mymessageupdate";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        if(responseObject != nil){
            NSLog(@"返回值: %@",responseObject);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"更新message失败:%@",error);
    }];
    
    
}


-(void)needUpdateAndRefreshWhenAppear:(NSNotification*) notification{
    id obj = [notification object];
    NSNumber *postID = [obj valueForKey:@"postID"];
    NSNumber *operation = [obj valueForKey:@"operation"];
    // 是否需要异步操作？
    [self updateRemoteMessageStatus:[operation integerValue] postID:[postID integerValue]];
    [self needToRefreshWhenAppear];

}


-(void)needToRefreshWhenAppear{
    
    self.isUserInfoChanged = YES;
}

-(void)pushSettingController{
    
    ProfilePageSystemSettingViewController *profile = [[ProfilePageSystemSettingViewController alloc]init];
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    
}


-(void)initProfilePageScrollView{
    
    self.profilePageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 50-64)];
    self.profilePageScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 900);

    self.profilePageScrollView.delegate = self;
    [self.view addSubview:self.profilePageScrollView];
    
}
-(void)initViews{
    
    [self initProfilePageNoticeView];
    [self initProfilePageCollectionView];
    [self initProfilePageCommentView];
    
}
-(void)initProfilePageNoticeView{
    
    self.profilePageNoticeView = [[ProfilePageModuleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 105)];

    self.profilePageNoticeView.moduleTitleLabel.text = @"我的消息";
    //self.profilePageNoticeView.moduleDetailLabel.text = @"共有0条未读消息";
    self.profilePageNoticeView.contentTableView.delegate = self;
    self.profilePageNoticeView.contentTableView.dataSource = self;
    self.profilePageNoticeView.delegate = self;
    self.profilePageNoticeView.tag = 0;
    
    [self.profilePageScrollView addSubview:self.profilePageNoticeView];

}

-(void)initProfilePageCollectionView{
    
    self.profilePageCollectionView = [[ProfilePageModuleView alloc]initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, 105)];
    self.profilePageCollectionView.moduleTitleLabel.text = @"我的收藏";
    self.profilePageCollectionView.contentTableView.delegate = self;
    self.profilePageCollectionView.contentTableView.dataSource = self;
    self.profilePageCollectionView.delegate = self;
    self.profilePageCollectionView.tag = 1;
    
    [self.profilePageScrollView addSubview:self.profilePageCollectionView];

}

-(void)initProfilePageCommentView{
    
    self.profilePageCommentView = [[ProfilePageModuleView alloc]initWithFrame:CGRectMake(0, 540, self.view.frame.size.width, 105)];
    self.profilePageCommentView.moduleTitleLabel.text = @"我的评论";
    self.profilePageCommentView.contentTableView.delegate = self;
    self.profilePageCommentView.contentTableView.dataSource = self;
    self.profilePageCommentView.delegate = self;
    self.profilePageCommentView.tag = 2;
    
    [self.profilePageScrollView addSubview:self.profilePageCommentView];

}

-(void)titleViewSelect:(id)sender{
    
    [self pushProfileTableViewController:[[sender superview] tag]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number;
    switch ([[tableView superview] tag]) {
        case 0:
            number = [self.responseMessage count] + 1;
            break;
        case  1:
            number = [self.responseCollection count] + 1;
            break;
        case  2:
            number = [self.responseComment count] + 1;
            break;
            
        default:
            break;
    }
    return number;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
        static NSString *ID = @"moduleCell";
        switch ([[tableView superview]tag]) {
            case 0:{
                if ([self.responseMessage count] == 0) {
                    cell = [self blankCell:@"暂无未读消息"];
                } else {
                    if(indexPath.row < [self.responseMessage count]){
                        ProfilePageNoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if(!noticeCell){
                            noticeCell = [[ProfilePageNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                        }
                        if([self.responseMessage objectAtIndex:indexPath.row]){
                            [noticeCell setDict:[self.responseMessage objectAtIndex:indexPath.row]frame:self.view.frame];
                        }
                        
                        cell = noticeCell;
                    } else {
                        cell = [self getMoreCell:@"查看全部消息"];
                    }
                
                }
            }
            break;
            case 1:
            {   //如果收藏数为0
                if([self.responseCollection count] == 0){
                    cell = [self blankCell:@"暂无收藏"];

                }else{
                    
                    if(indexPath.row < [self.responseCollection count]){
                        ProfilePageCollectionTableViewCell *collectionCell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if(!collectionCell){
                            collectionCell = [[ProfilePageCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                        }
                        if([self.responseCollection objectAtIndex:indexPath.row]){
                            [collectionCell setDict:[self.responseCollection objectAtIndex:indexPath.row]frame:self.view.frame];
                        }
                    
                        cell = collectionCell;
                    }else{
                        cell = [self getMoreCell:@"查看全部收藏"];
                    }
                    
                }
                
            }
            break;
            case 2:
            {
                if([self.responseComment count] == 0){
                    cell = [self blankCell:@"暂无评论"];
                
                }else{
                    
                    if(indexPath.row < [self.responseComment count]){
                    
                        ProfilePageCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if(!commentCell){
                            commentCell = [[ProfilePageCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                        }
                        if([self.responseComment objectAtIndex:indexPath.row]){
                            [commentCell setDict:[self.responseComment objectAtIndex:indexPath.row] frame:self.view.frame];
                        }
                        cell = commentCell;
                    }else{
                        cell = [self getMoreCell:@"查看全部评论"];
                    
                    }
                    
                    
                }
            break;
        }
            default:
                break;
        }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.0;
    
    switch ([[tableView superview] tag]) {
        case 0:
            height = 45.0;
            
            break;
        case 1:
            if([self.responseCollection count] == 0){
                height = 45.0;
            }else{
                if(indexPath.row != [self.responseCollection count]){
                    height = 110.0;

                }else{
                    height = 45.0;
 
                }
            }
            break;
        case 2:
            if([self.responseComment count] == 0){
                height = 45.0;
            }else{
                if(indexPath.row != [self.responseComment count]){
                    height = 150.0;
                    
                }else{
                    height = 45.0;
                    
                }
            }            break;
        default:
            break;
    }
    
    return height;
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (0 == [[tableView superview] tag]) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:
                                     self.responseMessage[indexPath.row]];
        [self updateRemoteMessageStatus:1 postID:[[dict valueForKey:@"ID"] integerValue]];
        [self needToRefreshWhenAppear];
        // 从table list 中删除
        [self.responseMessage removeObjectAtIndex:indexPath.row];
        NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:
                                     [NSIndexPath indexPathForRow:indexPath.row inSection:0],
                                     nil];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];

        [self resetFrames];
        //TODO, update some information
        self.messageCount--;
        
        self.profilePageNoticeView.moduleDetailLabel.text = [NSString stringWithFormat:@"共有%ld条消息",(long)self.messageCount];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch ([[tableView superview] tag]) {
        case 0:
            if([self.responseMessage count] != 0){
                if(indexPath.row != [self.responseMessage count]){
                    // 更新数据model 同时更新badge number
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:
                                                 self.responseMessage[indexPath.row]];
                    [dict setObject:[NSNumber numberWithInteger:1] forKey:@"did_read"];
                    @try {
                        // mutable copy
                        [self.responseMessage replaceObjectAtIndex:indexPath.row withObject:dict];
                    } @catch (NSException *exception){
                        NSLog(@"exception:%@", exception);
                        NSLog(@"Stack Trace: %@", [exception callStackSymbols]);

                    } @finally {
                        //NSLog(@"new message data :%@", self.responseMessage);
                    }
                    [self.profilePageNoticeView.contentTableView reloadData];
                    [self updateRemoteMessageStatus:0 postID:[[dict valueForKey:@"ID"] integerValue]];
                    
                    [self pushPostViewController:[[[self.responseMessage objectAtIndex:indexPath.row] valueForKey:@"ID"]integerValue]];
                }else{
                    [self pushProfileTableViewController:[[tableView superview] tag]];
                }
                
            }
            break;
        case  1:
            if([self.responseCollection count] != 0){
                if(indexPath.row != [self.responseCollection count]){
                [self pushPostViewController:[[[self.responseCollection objectAtIndex:indexPath.row] valueForKey:@"ID"]integerValue]];
                }else{
                    [self pushProfileTableViewController:[[tableView superview] tag]];
                }
                
            }

            break;
        case  2:
            
            if([self.responseComment count] != 0){
                if(indexPath.row != [self.responseComment count]){
                    [self pushPostViewController:[[[self.responseComment objectAtIndex:indexPath.row] valueForKey:@"post_id"]integerValue]];

                }else{
                    [self pushProfileTableViewController:[[tableView superview] tag]];

                }
            }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)getMoreCell:(NSString *)textstring{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width, 45)];
    label.text = textstring;
    label.textColor = [UIColor colorWithRed:160.0/255.0f green:160.0/255.0f  blue:160.0/255.0f  alpha:1.0f];
    label.font = [UIFont systemFontOfSize:14.5f];
    [cell.contentView addSubview:label];
    cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.size.width, 0, 0);
    
    return cell;
}

-(UITableViewCell *)blankCell:(NSString *)text{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width, 45)];
    label.text = text;
    label.textColor = [UIColor colorWithRed:160.0/255.0f green:160.0/255.0f  blue:160.0/255.0f  alpha:1.0f];
    label.font = [UIFont systemFontOfSize:14.5f];
    [cell.contentView addSubview:label];
    cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.size.width, 0, 0);
    
    return cell;
}

-(void)pushProfileTableViewController:(NSInteger)index{

    switch (index) {
        case 0: {
            ProfilePageNoticeTableViewController *noticevc = [[ProfilePageNoticeTableViewController alloc] initWithURL:@{@"requestRouter":@"post/mymessage"}];
            noticevc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:noticevc animated:YES];
            break;
        }
        case 1: {
            ProfilePageTableViewController *profilePageTableView;
            profilePageTableView = [[ProfilePageTableViewController alloc]initWithUrl:@{@"requestRouter":@"post/mycollection"} title:@"我的收藏"];
            profilePageTableView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profilePageTableView animated:YES];

            break;
        }
        case 2: {
            ProfilePageTableViewController *profilePageTableView;
            profilePageTableView = [[ProfilePageTableViewController alloc]initWithUrl:@{@"requestRouter":@"post/mycomment"} title:@"我的评论"];
            profilePageTableView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profilePageTableView animated:YES];

            break;
        }
        default:
            break;
    }
    
}


-(void)initRefreshHeaderView{
    
    //初始化headerView
    if(_refreshHeaderView == nil){
        _refreshHeaderView = [[EGORefreshView alloc] initWithScrollView:self.profilePageScrollView position:EGORefreshHeader ];
        _refreshHeaderView.delegate = self;
        
        [self.profilePageScrollView addSubview:_refreshHeaderView];
        
    }
    
}
#pragma mark EGORefreshReloadData
- (void)reloadTableViewDataSource{
    
    //下拉刷新的数据处理
    if(_refreshHeaderView.pullDown){
        [self performPullDownRefresh];
    }
    
}

-(void)simulatePullDownRefresh{
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    self.profilePageScrollView.contentOffset = CGPointMake(0, -60);
    
    [self performPullDownRefresh];
}

-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    [self.appDelegate syncNotificationNumber];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    self.responseDict = nil;

    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"post/my";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {

        if(responseObject != nil){
            NSLog(@"我的页面返回值: %@",responseObject);
            if([responseObject valueForKey:@"data"] != nil){
                
                if(self.initialized == YES){
                    [self initViews];
                    self.initialized = NO;
                }
                
                //NSLog(@"%@",self.responseComment);

                self.responseDict = [[NSMutableDictionary alloc]initWithDictionary:[responseObject valueForKey:@"data"]];
                
                self.responseCollection = [self.responseDict valueForKey:@"my_collection"];
                
                self.responseComment = [self.responseDict valueForKey:@"my_comment"];
                
                [self.responseMessage removeAllObjects];
                self.responseMessage = [[self.responseDict valueForKey:@"my_message"] mutableCopy];
                
                self.messageCount = [[self.responseDict valueForKey:@"my_message_count"] integerValue];
                
                self.collectionCount = [[self.responseDict valueForKey:@"my_collection_count"] integerValue];
                self.commentCount = [[self.responseDict valueForKey:@"my_comment_count"] integerValue];
                
                self.profilePageNoticeView.moduleDetailLabel.text = [NSString stringWithFormat:@"共有%ld条消息",(long)self.messageCount];
                
                self.profilePageCollectionView.moduleDetailLabel.text =[NSString stringWithFormat:@"已为孩子收藏%ld种玩耍内容",(long)self.collectionCount];
                self.profilePageCommentView.moduleDetailLabel.text = [NSString stringWithFormat:@"一共发表%ld篇评论",(long)self.commentCount];
                
                [self.profilePageNoticeView.contentTableView reloadData];
                
                [self.profilePageCollectionView.contentTableView reloadData];
                
                [self.profilePageCommentView.contentTableView reloadData];
                
                [self resetFrames];
                
                
            }
        }
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"%@",error);
              [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];

              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }];
    
}
-(void)resetFrames{
    
    self.profilePageNoticeView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60 + [self.responseMessage count]*45 + 45);
    self.profilePageCollectionView.frame = CGRectMake(0, self.profilePageNoticeView.frame.size.height, self.view.frame.size.width, 60 + [self.responseCollection count]*110 + 45);
    
    self.profilePageCommentView.frame = CGRectMake(0, self.profilePageNoticeView.frame.size.height + self.profilePageCollectionView.frame.size.height, self.view.frame.size.width, 60 + [self.responseComment count]*150 + 45);
    CGFloat height = self.profilePageNoticeView.frame.size.height + self.profilePageCollectionView.frame.size.height + self.profilePageCommentView.frame.size.height + 50;
    if(height < self.view.frame.size.height + 50){
        height = self.view.frame.size.height + 50;
    }
    self.profilePageScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    
}
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.profilePageScrollView];
    
}


#pragma mark - EGOPullRefreshDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
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
@end
