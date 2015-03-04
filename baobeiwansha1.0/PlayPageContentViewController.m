//
//  PlayPageContentViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/4.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "PlayPageContentViewController.h"
@interface PlayPageContentViewController ()

@property (nonatomic,retain) PostTableView *postTableView;

@end
@implementation PlayPageContentViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];
}

-(void)initViews{
    
    self.postTableView = [[PostTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 165)];
    
    RefreshScrollView *refreshScrollView = [[RefreshScrollView alloc]initWithScrollView:self.postTableView];
    self.postTableView.delegate = refreshScrollView;
    [self.view addSubview:refreshScrollView];
    
}
@end
