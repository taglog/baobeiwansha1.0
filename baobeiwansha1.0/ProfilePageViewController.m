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

@interface ProfilePageViewController ()
@property (nonatomic,retain) UIScrollView *profilePageScrollView;
@property (nonatomic,retain) ProfilePageModuleView *profilePageNoticeView;
@property (nonatomic,retain) ProfilePageModuleView *profilePageCollectionView;
@property (nonatomic,retain) ProfilePageModuleView *profilePageCommentView;

@end
@implementation ProfilePageViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self defaultSettings];
    [self initViews];
}

-(void)defaultSettings{
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0f];
    
    self.navigationItem.title = @"我的";
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSettingController)];
    rightBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
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
    self.profilePageScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1300);
    
    [self.view addSubview:self.profilePageScrollView];
    
}

-(void)initProfilePageNoticeView{
    
    self.profilePageNoticeView = [[ProfilePageModuleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    self.profilePageNoticeView.moduleTitle = @"我的消息";
    self.profilePageNoticeView.moduleDetail = @"共有25条未读消息";
    self.profilePageNoticeView.contentTableView.delegate = self;
    self.profilePageNoticeView.contentTableView.dataSource = self;
    self.profilePageNoticeView.delegate = self;
    self.profilePageNoticeView.tag = 0;
    
    [self.profilePageScrollView addSubview:self.profilePageNoticeView];

}

-(void)initProfilePageCollectionView{
    
    self.profilePageCollectionView = [[ProfilePageModuleView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 435)];
    self.profilePageCollectionView.moduleTitle = @"我的收藏";
    self.profilePageCollectionView.moduleDetail = @"已为孩子收藏25种玩耍内容";
    self.profilePageCollectionView.contentTableView.delegate = self;
    self.profilePageCollectionView.contentTableView.dataSource = self;
    self.profilePageCollectionView.delegate = self;
    self.profilePageCollectionView.tag = 1;
    
    [self.profilePageScrollView addSubview:self.profilePageCollectionView];

}

-(void)initProfilePageCommentView{
    
    self.profilePageCommentView = [[ProfilePageModuleView alloc]initWithFrame:CGRectMake(0, 735, self.view.frame.size.width, 555)];
    self.profilePageCommentView.moduleTitle = @"我的评论";
    self.profilePageCommentView.moduleDetail = @"一共发表15篇评论";
    self.profilePageCommentView.contentTableView.delegate = self;
    self.profilePageCommentView.contentTableView.dataSource = self;
    self.profilePageCommentView.delegate = self;
    self.profilePageCommentView.tag = 2;
    
    [self.profilePageScrollView addSubview:self.profilePageCommentView];

}

-(void)titleViewSelect:(id)sender{
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(indexPath.row < 3){
        
        static NSString *ID = @"moduleCell";
        switch ([[tableView superview]tag]) {
            case 0:{
                ProfilePageNoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:ID];
                if(!noticeCell){
                    noticeCell = [[ProfilePageNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                }
                [noticeCell setDict:@{} frame:self.view.frame];
                cell = noticeCell;
            }
            break;
            case 1:{
                ProfilePageCollectionTableViewCell *collectionCell = [tableView dequeueReusableCellWithIdentifier:ID];
                if(!collectionCell){
                    collectionCell = [[ProfilePageCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                }
                [collectionCell setDict:nil frame:self.view.frame];
                cell = collectionCell;
            }
            break;
            case 2:{
                ProfilePageCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:ID];
                if(!commentCell){
                    commentCell = [[ProfilePageCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                }
                [commentCell setDict:nil frame:self.view.frame];
                cell = commentCell;
            }
                break;
                
            default:
                break;
        }
    }else if(indexPath.row == 3){
        cell = [self getMoreCell];
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
            height = 110.0;
            break;
        case 2:
            height = 150.0;
            break;
        default:
            break;
    }
    if (indexPath.row == 3) {
        height = 45.0;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

@end
