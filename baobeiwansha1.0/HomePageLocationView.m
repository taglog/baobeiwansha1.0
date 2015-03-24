//
//  HomePageLocationView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageLocationView.h"
#import "HomePageLocationViewCell.h"

@interface HomePageLocationView ()

@property (nonatomic,retain) UICollectionView *locationCollectionView;
@property (nonatomic,retain) NSMutableArray *location;

@end
@implementation HomePageLocationView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initContentView];
    }
    return self;
}
-(void)setArray:(NSArray *)array{
    
    self.location = [[NSMutableArray alloc]initWithArray:array];
    
    [self.locationCollectionView reloadData];
    
}

-(void)initContentView{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.locationCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, self.frame.size.width, self.frame.size.height - 45) collectionViewLayout:flowLayout];
    
    [self.locationCollectionView registerClass:[HomePageLocationViewCell class] forCellWithReuseIdentifier:@"locationcell"];
    
    self.locationCollectionView.backgroundColor = [UIColor whiteColor];
    self.locationCollectionView.scrollEnabled = NO;
    self.locationCollectionView.delegate = self;
    self.locationCollectionView.dataSource = self;
    
    [self addSubview:self.locationCollectionView];
    
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
    return 4;
}


//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"locationcell";
    
    HomePageLocationViewCell *locationCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

    [locationCell setDict:[self.location objectAtIndex:indexPath.row] frame:self.frame];
    
    switch (indexPath.row) {
        case 0:
            locationCell.iconView.backgroundColor = [UIColor colorWithRed:76/255.0f green:175/255.0f blue:80/255.0f alpha:1.0f];
            break;
        case 1:
            locationCell.iconView.backgroundColor = [UIColor colorWithRed:205/255.0f green:220/255.0f blue:57/255.0f alpha:1.0f];
            break;
        case 2:
            locationCell.iconView.backgroundColor = [UIColor colorWithRed:255/255.0f green:193/255.0f blue:7/255.0f alpha:1.0f];
            break;
        case 3:
            locationCell.iconView.backgroundColor = [UIColor colorWithRed:156/255.0f green:39/255.0f blue:176/255.0f alpha:1.0f];
            break;
        default:
            break;
    }
    
    return locationCell;
    
}



#pragma mark - UICollectionLayout Setting
//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 5, 15, 5);
}


//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((self.frame.size.width - 30)/4, 60);
    return size;
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: add a selected mark
    NSString *tag = [[self.location objectAtIndex:indexPath.row] valueForKey:@"name"];
    [self.delegate pushViewControllerWithSender:tag sender2:nil moduleView:self];
    
}

- (void)collectionView:(UICollectionView *)colView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
