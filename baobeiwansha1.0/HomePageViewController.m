//
//  HomePageViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageProfileView.h"
#import "HomePageModuleView.h"
#import "HomePageAbilityViewCell.h"
#import "HomePageLocationViewCell.h"
#import "HomePageTableViewCell.h"

@interface HomePageViewController ()
@property (nonatomic,retain) UIScrollView *homeScrollView;
@property (nonatomic,retain) NSArray *ability;
@property (nonatomic,retain) NSArray *location;
@end

@implementation HomePageViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"宝贝玩啥";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initViews];

}

-(void)initViews{
    
    self.ability = @[@{@"tag_name":@"守规则",@"tag_description":@"孩子正处于秩序敏感期"},@{@"tag_name":@"性别意识",@"tag_description":@"认知男人和女人不一样"},@{@"tag_name":@"运动能力",@"tag_description":@"应该开始学习跳跃"}];
    self.location = @[@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"寒假",@"":@""},@{@"tag_name":@"爱吃饭",@"":@""},@{@"tag_name":@"和父母玩",@"":@"",}];

    [self initScrollView];
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
    }
}

-(void)initViewSection1{
    
    HomePageProfileView *homePageProfileView = [[HomePageProfileView alloc]init];
    [homePageProfileView setDict:nil frame:self.view.frame];
    [self.homeScrollView addSubview:homePageProfileView];
    
    HomePageModuleView *homePageModuleView1 = [[HomePageModuleView alloc]initWithFrame:CGRectMake(0, 260, self.view.frame.size.width, 160)];
    
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout1.minimumInteritemSpacing = 10;
    
    UICollectionView *homePageCollectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 120) collectionViewLayout:flowLayout1];
    [homePageCollectionView1 registerClass:[HomePageAbilityViewCell class] forCellWithReuseIdentifier:@"cell1"];
    homePageCollectionView1.backgroundColor = [UIColor whiteColor];
    homePageCollectionView1.scrollEnabled = NO;
    homePageCollectionView1.tag = 1;
    homePageCollectionView1.delegate = self;
    homePageCollectionView1.dataSource = self;

    [homePageModuleView1 setContentView:homePageCollectionView1 title:@"这些潜能要大发展啦，快抓住时机跟我玩吧~"];
    [self.homeScrollView addSubview:homePageModuleView1];

}

-(void)initViewSection2{
    
    HomePageModuleView *homePageModuleView2 = [[HomePageModuleView alloc]initWithFrame:CGRectMake(0, 435, self.view.frame.size.width, 130)];
    
    [self.homeScrollView addSubview:homePageModuleView2];
    
    UICollectionViewFlowLayout *flowLayout2=[[UICollectionViewFlowLayout alloc] init];
    flowLayout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout2.minimumInteritemSpacing = (self.view.frame.size.width - 280)/3;

    UICollectionView *homePageCollectionView2 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 130) collectionViewLayout:flowLayout2];
    [homePageCollectionView2 registerClass:[HomePageLocationViewCell class] forCellWithReuseIdentifier:@"cell2"];
    homePageCollectionView2.backgroundColor = [UIColor whiteColor];
    homePageCollectionView2.scrollEnabled = NO;
    homePageCollectionView2.tag = 2;
    homePageCollectionView2.delegate = self;
    homePageCollectionView2.dataSource = self;
    
    [homePageModuleView2 setContentView:homePageCollectionView2 title:@"不同的场合，我要有不一样的玩法~"];
    
    
}

-(void)initViewSection3{
    
    HomePageModuleView *homePageModuleView3 = [[HomePageModuleView alloc]initWithFrame:CGRectMake(0, 620, self.view.frame.size.width, 200)];
    [self.homeScrollView addSubview:homePageModuleView3];
    
    UITableView *homePageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45,self.view.frame.size.width, 180)];
    homePageTableView.scrollEnabled = NO;
    homePageTableView.separatorInset = UIEdgeInsetsZero;
    homePageTableView.delegate = self;
    homePageTableView.dataSource = self;
    [homePageModuleView3 setContentView:homePageTableView title:@"寓教于乐可没那么简单，父母也来学习吧~"];
}


#pragma mark - collectionView delegate

//设置分区

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//每个分区上的元素个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count;
    if(collectionView.tag == 1){
        count = 3;
    }else if(collectionView.tag == 2){
        count = 4;
    
    }
    return count;
}


//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if(collectionView.tag == 1){
        static NSString *identify = @"cell1";
       HomePageAbilityViewCell *abilityCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [abilityCell setDict:[self.ability objectAtIndex:indexPath.row]];
        
        cell = abilityCell;
        
    }else if(collectionView.tag == 2){
        static NSString *identify = @"cell2";

        HomePageLocationViewCell *locationCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [locationCell setDict:[self.location objectAtIndex:indexPath.row]];
        cell = locationCell;
    }
    
    return cell;
    
}



#pragma mark - UICollectionLayout Setting
//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}


//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(collectionView.tag == 1){
        size = CGSizeMake((self.view.frame.size.width - 50)/3,90);
    }else if(collectionView.tag == 2){
        size = CGSizeMake(60, 60);
    }
    return size;
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: add a selected mark
    
}

- (void)collectionView:(UICollectionView *)colView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    //创建cell
    HomePageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.separatorInset = UIEdgeInsetsZero;
    }
    [cell setDict:nil frame:self.view.frame];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  60;
}

@end
