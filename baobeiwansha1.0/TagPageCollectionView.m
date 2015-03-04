//
//  TagPageCollectionView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "TagPageCollectionView.h"
#import "TagPageCollectionViewCell.h"

@interface TagPageCollectionView ()

@property (nonatomic,retain) UICollectionView *tagCollectionView;

@end

@implementation TagPageCollectionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initViews];
    }
    return self;
}

-(void)initViews{
    
    [self initHeaderView];
    [self initCollectionView];
    
}

-(void)initHeaderView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:250.0/255.0f green:250.0/255.0f blue:250.0/255.0f alpha:1.0f];
    
    self.headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 40)];
    self.headerLabel.text = @"";
    self.headerLabel.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.0f];
    self.headerLabel.font = [UIFont systemFontOfSize:14.0f];
    self.headerLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:headerView];
    [headerView addSubview:self.headerLabel];
    
}

-(void)initCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40) collectionViewLayout:flowLayout];
    
    self.tagCollectionView.contentSize = CGSizeMake(800, self.frame.size.height - 40);
    
    [self.tagCollectionView registerClass:[TagPageCollectionViewCell class] forCellWithReuseIdentifier:@"tagcell"];
    self.tagCollectionView.showsHorizontalScrollIndicator = NO;
    self.tagCollectionView.backgroundColor = [UIColor whiteColor];
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    
    [self addSubview:self.tagCollectionView];
    
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
    return 12;
}


//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identify = @"tagcell";

    TagPageCollectionViewCell *tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

    NSArray *tag = @[@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"寒假",@"":@""},@{@"tag_name":@"爱吃饭",@"":@""},@{@"tag_name":@"和父母玩",@"":@"",},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""},@{@"tag_name":@"爱周末",@"":@""}];
    
    [tagCell setDict:[tag objectAtIndex:indexPath.row]];
    return tagCell;

}


#pragma mark - UICollectionLayout Setting
//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 20, 10, 0);
}

//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.frame.size.width /4, self.frame.size.width/4);
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

@end
