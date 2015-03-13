//
//  HomePageTableView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageTableView.h"
#import "HomePageTableViewCell.h"

@implementation HomePageTableView
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        [self initContentView];
    }
    return self;
    
}

-(void)initContentView{
    
    UITableView *homePageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45,self.frame.size.width, self.frame.size.height - 45)];
    homePageTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    homePageTableView.scrollEnabled = NO;
    homePageTableView.delegate = self;
    homePageTableView.dataSource = self;
    [self addSubview: homePageTableView];
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
    }
    [cell setDict:nil frame:self.frame];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate pushViewControllerWithSender:[NSNumber numberWithInt:1] moduleView:self];
}

@end
