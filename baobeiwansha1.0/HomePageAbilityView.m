//
//  HomePageAbilityView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageAbilityView.h"
#import "HomePageAbilityViewCell.h"

@interface HomePageAbilityView ()

@property (nonatomic,retain) UICollectionView *abilityCollectionView;
@property (nonatomic,retain) NSMutableArray *ability;

@end
@implementation HomePageAbilityView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initContentView];
    }
    return self;
}

-(void)setDict:(NSDictionary *)dict{
    
    self.ability = [[NSMutableArray alloc]init];
    
    if([dict valueForKey:@"capability_title_1"]!= (id)[NSNull null] && [dict valueForKey:@"capability_content_1"]!= (id)[NSNull null]){
        [self.ability addObject:@{@"tag_name":[dict valueForKey:@"capability_title_1"],@"tag_description":[dict valueForKey:@"capability_content_1"]}];

    }
    if([dict valueForKey:@"capability_title_2"]!= (id)[NSNull null] && [dict valueForKey:@"capability_content_2"]!= (id)[NSNull null]){
        [self.ability addObject:@{@"tag_name":[dict valueForKey:@"capability_title_2"],@"tag_description":[dict valueForKey:@"capability_content_2"]}];
        
    }
    if([dict valueForKey:@"capability_title_3"]!= (id)[NSNull null] && [dict valueForKey:@"capability_content_3"]!= (id)[NSNull null]){
        [self.ability addObject:@{@"tag_name":[dict valueForKey:@"capability_title_3"],@"tag_description":[dict valueForKey:@"capability_content_3"]}];
        
    }

    [self.abilityCollectionView reloadData];

}

-(void)initContentView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 10;
    
    self.abilityCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, self.frame.size.width, self.frame.size.height - 45) collectionViewLayout:flowLayout];
    
    [self.abilityCollectionView registerClass:[HomePageAbilityViewCell class] forCellWithReuseIdentifier:@"abilitycell"];
    
    self.abilityCollectionView.backgroundColor = [UIColor whiteColor];
    self.abilityCollectionView.scrollEnabled = NO;
    self.abilityCollectionView.delegate = self;
    self.abilityCollectionView.dataSource = self;
    
    [self addSubview:self.abilityCollectionView];
    
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
    return 3;
}


//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"abilitycell";
    
    HomePageAbilityViewCell *abilityCell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [abilityCell setDict:[self.ability objectAtIndex:indexPath.row]];
    
    switch (indexPath.row) {
        case 0:
            abilityCell.backgroundColor = [UIColor colorWithRed:107.0/255.0f green:226.0/255.0f blue:50.0/255.0f alpha:1.0f];
            break;
        case 1:
            abilityCell.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
            break;
        case 2:
            abilityCell.backgroundColor = [UIColor colorWithRed:39.0/255.0f green:212.0/255.0f blue:247.0/255.0f alpha:1.0f];
            break;
        default:
            break;
    }
    return abilityCell;
    
}



#pragma mark - UICollectionLayout Setting
//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(17, 15, 17, 15);
}


//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((self.frame.size.width - 50)/3,80);
    return size;
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)collectionView:(UICollectionView *)colView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: add a selected mark
    NSString *tag = [[self.ability objectAtIndex:indexPath.row] valueForKey:@"tag_name"];
    [self.delegate pushViewControllerWithSender:tag moduleView:self];
}

- (void)collectionView:(UICollectionView *)colView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}




@end
