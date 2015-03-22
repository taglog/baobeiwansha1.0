//
//  ProfilePageViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
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

@interface ProfilePageViewController ()

@property (nonatomic,retain) UIScrollView *profilePageScrollView;
@property (nonatomic,retain) ProfilePageModuleView *profilePageNoticeView;
@property (nonatomic,retain) ProfilePageModuleView *profilePageCollectionView;
@property (nonatomic,retain) ProfilePageModuleView *profilePageCommentView;
@property (nonatomic,retain) AppDelegate *appDelegate;
@property (nonatomic,retain) NSMutableDictionary *responseDict;
@property (nonatomic,retain) NSMutableArray *responseCollection;
@property (nonatomic,retain) NSMutableArray *responseComment;
@property (nonatomic,assign) NSInteger collectionCount;
@property (nonatomic,assign) NSInteger commentCount;

@end
@implementation ProfilePageViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.responseCollection = [[NSMutableArray alloc]init];
    self.responseComment = [[NSMutableArray alloc]init];
    self.collectionCount = 0;
    self.commentCount = 0;
    
    [self defaultSettings];
    [self initViews];
    [self getInfoFromServer];
}

-(void)defaultSettings{
    
    self.view.backgroundColor = [UIColor colorWithRed:250.0/255.0f green:250.0/255.0f blue:250.0/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSettingController)];
    rightBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.navigationItem.title = @"我的";

}


-(void)getInfoFromServer{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"post/my";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSLog(@"%@",responseObject);
        if(responseObject != nil){
            
            if([responseObject valueForKey:@"data"] != nil){
                
            self.responseDict = [NSMutableDictionary dictionaryWithDictionary:[responseObject valueForKey:@"data"]];
                if([self.responseDict valueForKey:@"my_collection"]){
                    self.responseCollection = [self.responseDict valueForKey:@"my_collection"];
                }
                if([self.responseDict valueForKey:@"my_comment"]){
                    self.responseComment = [self.responseDict valueForKey:@"my_comment"];
                }
 
                
                self.collectionCount = [[self.responseDict valueForKey:@"my_collection_count"] integerValue];
                self.commentCount = [[self.responseDict valueForKey:@"my_comment_count"] integerValue];
                
            self.profilePageCollectionView.moduleDetailLabel.text =[NSString stringWithFormat:@"已为孩子收藏%ld种玩耍内容",(long)self.collectionCount];
            self.profilePageCommentView.moduleDetailLabel.text = [NSString stringWithFormat:@"一共发表%ld篇评论",(long)self.commentCount];

            
            [self.profilePageCollectionView.contentTableView reloadData];

            [self.profilePageCommentView.contentTableView reloadData];
            
            [self resetFrames];
            }
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"%@",error);
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }];
    
    
    
    
}
-(void)resetFrames{
    
    self.profilePageNoticeView.frame = CGRectMake(0, 0, self.view.frame.size.width, 105);
    self.profilePageCollectionView.frame = CGRectMake(0, self.profilePageNoticeView.frame.size.height, self.view.frame.size.width, 60 + [self.responseCollection count]*110 + 45);
    
    self.profilePageCommentView.frame = CGRectMake(0, 105 + self.profilePageCollectionView.frame.size.height, self.view.frame.size.width, 60 + [self.responseComment count]*150 + 45);
    
    self.profilePageScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.profilePageNoticeView.frame.size.height + self.profilePageCollectionView.frame.size.height + self.profilePageCommentView.frame.size.height);

}
-(void)pushSettingController{
    
    ProfilePageSystemSettingViewController *profile = [[ProfilePageSystemSettingViewController alloc]init];
    profile.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profile animated:YES];
    
}

-(void)initViews{
    
    [self initProfilePageScrollView];
    [self initProfilePageNoticeView];
    [self initProfilePageCollectionView];
    [self initProfilePageCommentView];
    
}

-(void)initProfilePageScrollView{
    
    self.profilePageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)];
    self.profilePageScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    [self.view addSubview:self.profilePageScrollView];
    
}

-(void)initProfilePageNoticeView{
    
    self.profilePageNoticeView = [[ProfilePageModuleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 105)];
    self.profilePageNoticeView.moduleTitleLabel.text = @"我的消息";
    self.profilePageNoticeView.moduleDetailLabel.text = @"共有0条未读消息";
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
            number = 1;
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
    NSLog(@"%ld",(long)number);
    return number;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
        static NSString *ID = @"moduleCell";
        switch ([[tableView superview]tag]) {
            case 0:{
//                ProfilePageNoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:ID];
//                if(!noticeCell){
//                    noticeCell = [[ProfilePageNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//                }
//                [noticeCell setDict:@{} frame:self.view.frame];
//                cell = noticeCell;
                cell = [self blankCell:@"暂无消息"];
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
                        cell = [self getMoreCell];
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
                        cell = [self getMoreCell];
                    
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
            height = 65.0;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch ([[tableView superview] tag]) {
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

-(UITableViewCell *)getMoreCell{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width, 45)];
    label.text = @"查看全部";
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
    
    ProfilePageTableViewController *profilePageTableView;
    switch (index) {
        case 1:
            profilePageTableView = [[ProfilePageTableViewController alloc]initWithUrl:@{@"requestRouter":@"post/mycollection"} title:@"我的收藏"];
            break;
        case 2:
            profilePageTableView = [[ProfilePageTableViewController alloc]initWithUrl:@{@"requestRouter":@"post/mycomment"} title:@"我的评论"];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:profilePageTableView animated:YES];

}
-(void)pushPostViewController:(NSInteger)postID{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    PostViewController *post = [[PostViewController alloc] init];
    post.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:postID],@"postID",self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"post/post";
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
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
