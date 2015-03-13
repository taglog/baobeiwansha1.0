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

@interface TagPageViewController ()

@property (nonatomic,retain) NSArray *responseData;

@property (nonatomic,retain) UICollectionView *tagCollectionView;

@end
@implementation TagPageViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self defaultSettings];
    [self initViews];
    
}

-(void)defaultSettings{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = @"tag页";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)popViewController{
    
    [self.navigationController  popViewControllerAnimated:YES];
    
}


-(void)initViews{
    self.responseData = @[@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"寒假",@"":@""},@{@"tag_name":@"爱吃饭",@"":@""},@{@"tag_name":@"和父母玩",@"":@"",},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""}];
   
    [self initSearchBar];
    [self initSegmentControl];
    [self initCollectionView];


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
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:tagCategory];
    segmentedControl.frame = CGRectMake(15, 79, self.view.frame.size.width - 30, 30);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.tintColor = [UIColor colorWithRed:255.0/255.0f green:101.0/255.0f  blue:108.0/255.0f alpha:1.0f];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
}
-(void)segmentedControlChangedValue:(UISegmentedControl *)sender{
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.responseData = self.responseData = @[@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"寒假",@"":@""},@{@"tag_name":@"爱吃饭",@"":@""},@{@"tag_name":@"和父母玩",@"":@"",},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""}];
            [self.tagCollectionView reloadData];
            break;
        case 1:
            self.responseData = @[@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"寒假",@"":@""},@{@"tag_name":@"吃饭",@"":@""},@{@"tag_name":@"父母玩",@"":@"",},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""}];
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
    
    self.tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 124, self.view.frame.size.width, self.view.frame.size.height - 124) collectionViewLayout:flowLayout];
    
    self.tagCollectionView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    
    [self.tagCollectionView registerClass:[TagPageCollectionViewCell class] forCellWithReuseIdentifier:@"tagcell"];
    self.tagCollectionView.backgroundColor = [UIColor whiteColor];
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    
    [self.view addSubview:self.tagCollectionView];

}

-(void)pushViewControllerWithTag:(NSString *)tag{
    
    TagPostTableViewController *tagPostViewController = [[TagPostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/tag"} tag:tag];
    
    [self.navigationController pushViewController: tagPostViewController animated:YES];
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
    return 20;
}


//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"tagcell";
    
    TagPageCollectionViewCell *tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [tagCell setDict:[self.responseData objectAtIndex:indexPath.row]];
    return tagCell;
    
}


#pragma mark - UICollectionLayout Setting
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


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: add a selected mark
    // TODO: add a selected mark
    
    NSString *tag =  [self.responseData[indexPath.row] valueForKey:@"tag_name"];
    
    [self  pushViewControllerWithTag:tag];
}

- (void)collectionView:(UICollectionView *)colView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
