//
//  HomePageTableView.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "HomePageTableView.h"
#import "HomePageTableViewCell.h"
@interface HomePageTableView ()

@property (nonatomic,retain) UITableView *homePageTableView;
@property (nonatomic,retain) NSMutableArray *tableArray;

@end
@implementation HomePageTableView
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        [self initContentView];
    }
    return self;
    
}
-(void)setArray:(NSArray *)array{
    

    if([array  count]!= 0){

        self.tableArray = [[NSMutableArray alloc]initWithArray:array];
        
        [self.homePageTableView reloadData];

    }
    
}
-(void)initContentView{
    
    self.homePageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45,self.frame.size.width, self.frame.size.height - 45)];
    self.homePageTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.homePageTableView.scrollEnabled = NO;
    self.homePageTableView.delegate = self;
    self.homePageTableView.dataSource = self;
    [self addSubview: self.homePageTableView];
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
    if([self.tableArray objectAtIndex:indexPath.row] != (id)[NSNull null]){
        
        [cell setDict:[self.tableArray objectAtIndex:indexPath.row] frame:self.frame];

    }
    
    NSLog(@"%@",self.tableArray);

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate pushViewControllerWithSender:[[self.tableArray objectAtIndex:indexPath.row] valueForKey:@"ID"] sender2:nil moduleView:self];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
