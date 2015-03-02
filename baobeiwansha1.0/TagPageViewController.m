//
//  TagPageViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "TagPageViewController.h"
#import "TagPageCollectionView.h"

@interface TagPageViewController ()

@property (nonatomic,retain) UICollectionView *tagCollectionView;

@end
@implementation TagPageViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
    self.title = @"tag页";
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self initViews];
}

-(void)initViews{
    
        TagPageCollectionView *tagPageCollectionView = [[TagPageCollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.height - 64)/2)];
    tagPageCollectionView.headerLabel.text = @"潜能";
    
    [self.view addSubview:tagPageCollectionView];
    
    TagPageCollectionView *tagPageCollectionView2 = [[TagPageCollectionView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height- 64)/2 + 64, self.view.frame.size.width, (self.view.frame.size.height - 64)/2)];
    tagPageCollectionView2.headerLabel.text = @"场景";
    [self.view addSubview:tagPageCollectionView2];


}

@end
