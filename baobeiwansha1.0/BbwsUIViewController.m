//
//  BbwsUIViewController.m
//  baobeiwansha1.0
//
//  Created by PanYongfeng on 15/4/20.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "BbwsUIViewController.h"
#import "AppDelegate.h"
#import "PostViewController.h"

@interface BbwsUIViewController ()
@property (nonatomic,retain) AppDelegate *appDelegate;
@end

@implementation BbwsUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"view will appear");
//    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    // 检查是否需要显示push message
//    if (self.appDelegate.pushMessageID) {
//        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.appDelegate.pushMessageID stringValue] message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        //        // optional - add more buttons:
//        //        [alert addButtonWithTitle:@"Yes"];
//        //        [alert show];
//        
//        [self pushPostViewController:[self.appDelegate.pushMessageID integerValue]];
//        self.appDelegate.pushMessageID = nil;
    
//    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //NSLog(@"view did appear");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)pushPostViewController:(NSInteger)postID{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    PostViewController *post = [[PostViewController alloc] init];
    post.hidesBottomBarWhenPushed = YES;
    
    
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:postID],@"postID",self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"post/post";
    
    
    [post initWithRequestURL:postRouter requestParam:requestParam];
    
    [self.navigationController pushViewController:post animated:YES];
    
}



@end
