//
//  ProfilePageNoticeTableViewController.m
//  baobeiwansha1.0
//
//  Created by PanYongfeng on 15/4/22.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "ProfilePageNoticeTableViewController.h"
#import "ProfilePageNoticeTableViewCell.h"

@interface ProfilePageNoticeTableViewController ()

@end

@implementation ProfilePageNoticeTableViewController

#define TABLECELLHEIGHT 45

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"我的消息";
}

- (void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ProfilePageNotice"];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    //[super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ProfilePageNotice"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"MessageCell";
    
    //创建cell
    ProfilePageNoticeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[ProfilePageNoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if(self.adviceArray[indexPath.row]){
        [cell setDict:self.adviceArray[indexPath.row] frame:self.view.frame];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return TABLECELLHEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    // 设置为已读
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:
                                 self.adviceArray[indexPath.row]];
    [dict setObject:[NSNumber numberWithInteger:1] forKey:@"did_read"];
    
    [self.adviceArray replaceObjectAtIndex:indexPath.row withObject:dict];
    [tableView reloadData];
    
    // 设置返回后页面需要重新加载标记
    ProfilePageNoticeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    @try{
        NSDictionary *messageDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], @"operation", [NSNumber numberWithInteger:[cell getPostID]], @"postID", nil];
        NSLog(@"update message : %@", messageDict);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageChanged" object:messageDict];
    } @catch(NSException *e){
        NSLog(@"Exception: %@", e);
        NSLog(@"Stack Trace: %@", [e callStackSymbols]);
    }
    
}

    
// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
    
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        ProfilePageNoticeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSDictionary *messageDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1], @"operation", [NSNumber numberWithInteger:[cell getPostID]], @"postID", nil];
        NSLog(@"update message : %@", messageDict);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageChanged" object:messageDict];
        
        
        [self.adviceArray removeObjectAtIndex:indexPath.row];
        NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:
                                     [NSIndexPath indexPathForRow:indexPath.row inSection:0],
                                     nil];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        //[tableView reloadData];


    }
}
    
  







@end
