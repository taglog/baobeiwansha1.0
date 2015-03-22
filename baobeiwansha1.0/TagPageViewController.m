//
//  TagPageViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "TagPageViewController.h"
#import "TagPostTableViewController.h"
#import "TagSearchViewController.h"
#import "TagPageCollectionViewCell.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"

@interface TagPageViewController ()

@property (nonatomic,assign) BOOL reloading;

@property (nonatomic,retain) UISegmentedControl *segmentedControl;
@property (nonatomic,retain) NSMutableArray *responseData;

@property (nonatomic,retain) NSMutableArray *abilityData;
@property (nonatomic,retain) NSMutableArray *locationData;

@property (nonatomic,retain) UICollectionView *tagCollectionView;

@property (nonatomic,retain) EGORefreshView *refreshHeaderView;

@property (nonatomic,retain) EGORefreshView *refreshFooterView;

@property (nonatomic,retain) AppDelegate *appDelegate;

@property (nonatomic,assign) BOOL isRefreshed;

//指示层
@property (nonatomic,strong)JGProgressHUD *HUD;
@property (nonatomic,assign)BOOL isHudShow;

@end
@implementation TagPageViewController
-(id)init{
    self = [super init];
    self.isRefreshed = NO;
    self.p = 2;
    
    return self;
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.requestURL = @{@"requestRouter":@"tag/get"};
    
    self.abilityData = [[NSMutableArray alloc]init];
    self.locationData = [[NSMutableArray alloc]init];

    [self defaultSettings];
    [self initViews];
    
}

-(void)defaultSettings{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"标签";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)popViewController{
    
    [self.navigationController  popViewControllerAnimated:YES];
    
}


-(void)initViews{
    
    [self initSearchBar];
    [self initSegmentControl];
    
    [self initCollectionView];
    [self initRefreshHeaderView];
    [self simulatePullDownRefresh];


}
-(void)initSearchBar{
    
    UIButton *searchBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 240, 30)];
    [searchBarButton setBackgroundImage:[UIImage imageNamed:@"searchbar"] forState:UIControlStateNormal];
    [searchBarButton addTarget:self action:@selector(pushSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    searchBarButton.adjustsImageWhenHighlighted = NO;
    self.navigationItem.titleView = searchBarButton;
    
    
}
-(void)pushSearchViewController{
    
    TagSearchViewController  *tagSearchViewController = [[TagSearchViewController alloc]init];
    [self.navigationController  pushViewController:tagSearchViewController animated:YES];
    
}

-(void)initSegmentControl{
    
    NSArray *tagCategory = [NSArray arrayWithObjects:@"潜能",@"场景", nil];
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:tagCategory];
    self.segmentedControl.frame = CGRectMake(15, 79, self.view.frame.size.width - 30, 30);
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.tintColor = [UIColor colorWithRed:255.0/255.0f green:101.0/255.0f  blue:108.0/255.0f alpha:1.0f];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
}
-(void)segmentedControlChangedValue:(UISegmentedControl *)sender{
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self.tagCollectionView reloadData];
            break;
        case 1:
            if(self.isRefreshed == NO){
                [self simulatePullDownRefresh];
                self.isRefreshed = YES;
            }
            [self.tagCollectionView reloadData];
            break;
        default:
            break;
    }
}
-(void)initCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 20;
    
    self.tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 124, self.view.frame.size.width, self.view.frame.size.height - 114) collectionViewLayout:flowLayout];
    
    [self.tagCollectionView registerClass:[TagPageCollectionViewCell class] forCellWithReuseIdentifier:@"tagcell"];
    [self.tagCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    self.tagCollectionView.backgroundColor = [UIColor whiteColor];
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    
    [self.view addSubview:self.tagCollectionView];

}

-(void)pushViewControllerWithTag:(NSString *)tag{
    
    TagPostTableViewController *tagPostViewController = [[TagPostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/tag"} tag:tag];
    
    [self.navigationController pushViewController: tagPostViewController animated:YES];
}

//初始化下拉刷新header
-(void)initRefreshHeaderView{
    
    //初始化headerView
    if(_refreshHeaderView == nil){
        _refreshHeaderView = [[EGORefreshView alloc] initWithScrollView:self.tagCollectionView position:EGORefreshHeader];
        _refreshHeaderView.delegate = self;
        
        [self.tagCollectionView addSubview:_refreshHeaderView];
        
    }
    
}

-(void)initRefreshFooterView{
    
    if(_refreshFooterView == nil){
        
        _refreshFooterView = [[EGORefreshView alloc] initWithScrollView:self.tagCollectionView position:EGORefreshFooter];
        _refreshFooterView.delegate = self;
        
    }
    
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
    
    if([self.segmentedControl selectedSegmentIndex] == 0){
        
        count = [self.abilityData count];
        
    }else if([self.segmentedControl selectedSegmentIndex] == 1){
        
        count = [self.locationData count];
    }
    
    return count;
}


//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"tagcell";
    
    TagPageCollectionViewCell *tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if([self.segmentedControl selectedSegmentIndex] == 0){
        [tagCell setDict:[self.abilityData objectAtIndex:indexPath.row]];

    }else if([self.segmentedControl selectedSegmentIndex] == 1){
        [tagCell setDict:[self.locationData objectAtIndex:indexPath.row]];

    }
    switch (indexPath.row % 4) {
        case 0:
            tagCell.iconView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:186.0/255.0f blue:180.0f/255.0f alpha:1.0f];
            break;
        case 1:
            tagCell.iconView.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:0.0/255.0f blue:130.0f/255.0f alpha:1.0f];
            break;
        case 2:
            tagCell.iconView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:149.0/255.0f blue:0.0f/255.0f alpha:1.0f];

            break;
        case 3:
            tagCell.iconView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:157.0/255.0f blue:237.0f/255.0f alpha:1.0f];

            break;
        default:
            break;
    }
    return tagCell;
    
}


#pragma mark - UICollectionLayout Setting

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        [self initRefreshFooterView];
        [footerView addSubview:_refreshFooterView];
        reusableview = footerView;
    }
    
    return reusableview;
}
//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((self.view.frame.size.width-10)/4, (self.view.frame.size.width-10)/4);
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    CGSize size= {self.view.frame.size.width,40};
    return size;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: add a selected mark
    // TODO: add a selected mark
    NSString *tag;

    if([self.segmentedControl selectedSegmentIndex] == 0){
        tag =  [self.abilityData[indexPath.row] valueForKey:@"name"];
    }else if([self.segmentedControl selectedSegmentIndex] == 1){
        tag =  [self.locationData[indexPath.row] valueForKey:@"name"];
    }
    
    [self  pushViewControllerWithTag:tag];
}

- (void)collectionView:(UICollectionView *)colView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    self.tagCollectionView.contentOffset = CGPointMake(0, -60);
    
    [self performPullDownRefresh];
}

-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //请求的地址
    NSString *postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *postParam =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[self.segmentedControl selectedSegmentIndex]],@"type",[NSNumber numberWithInt:1],@"p",nil];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            
            if([self.segmentedControl selectedSegmentIndex] == 0){
                [self.abilityData removeAllObjects];
                for(NSDictionary *responseDict in responseArray){
                    [self.abilityData addObject:responseDict];
                    
                }
                
            }else if([self.segmentedControl selectedSegmentIndex] == 1){
                [self.locationData removeAllObjects];
                for(NSDictionary *responseDict in responseArray){
                    [self.locationData addObject:responseDict];
                    
                }
                
            }
            
            [self.tagCollectionView reloadData];
            self.p = 2;
        }
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.4f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_refreshHeaderView removeFromSuperview];
        });
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self showHUD:@"网络请求失败~"];
        [self dismissHUD];
      
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    
}

-(void)performPullUpRefresh{
    
    _reloading = YES;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    //请求的地址
    NSString *postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *postParam =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[self.segmentedControl selectedSegmentIndex]],@"type",[NSNumber numberWithInteger:self.p],@"p",nil];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            
            if([self.segmentedControl selectedSegmentIndex] == 0){
                for(NSDictionary *responseDict in responseArray){
                    [self.abilityData addObject:responseDict];
                    
                }
                
            }else if([self.segmentedControl selectedSegmentIndex] == 1){
                for(NSDictionary *responseDict in responseArray){
                    [self.locationData addObject:responseDict];
                    
                }
                
            }

            
            [self.tagCollectionView reloadData];
            
            ++self.p;
            
        }else{
            
            [self showHUD:@"已经是最后一页了~"];
            [self dismissHUD];
        }
        
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3f];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self showHUD:@"网络请求失败~"];
        [self dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    
    
}
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tagCollectionView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tagCollectionView];
    
    
}


#pragma mark - EGOPullRefreshDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
