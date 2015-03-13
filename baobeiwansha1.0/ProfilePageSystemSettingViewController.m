//
//  ProfilePageSystemSettingViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/10.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "ProfilePageSystemSettingViewController.h"
#import "UserInfoSettingViewController.h"
#import "AboutUsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "FeedBackViewController.h"


@interface ProfilePageSystemSettingViewController ()

@property (nonatomic,retain) UITableView *tableView;

@end
@implementation ProfilePageSystemSettingViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self defaultSettings];
    [self initViews];
}

-(void)defaultSettings{
    
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255.0f green:246.0/255.0f blue:246.0/255.0f alpha:1.0f];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.navigationItem.title = @"设置";
    
}

-(void)popViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)initViews{
    
    if(!self.tableView){
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,365)];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.scrollEnabled = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview: self.tableView];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number;
    if (section == 0) {
        number = 1;
    }else if(section == 1){
        number = 5;
    }
    return number;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell){
        if (indexPath.section == 0) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"宝贝信息";
            
        }else{
            
            switch (indexPath.row) {
                case 0:
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = @"接受推送消息";
                    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [switchview addTarget:self action:@selector(pushNotificationON:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = switchview;
                    break;
                }
                case 1:
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
                    cell.textLabel.text = @"意见反馈";
                    break;
                }
                case 2:
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
                    cell.textLabel.text = @"去APPstore评价";
                    break;
                }
                case 3:
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
                    cell.textLabel.text = @"检测新版本";
                    break;
                }
                case 4:
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
                    cell.textLabel.text = @"关于我们";
                    break;
                }
                default:
                    break;
            }
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        UserInfoSettingViewController *profilePageSetting = [[UserInfoSettingViewController alloc]init];
        [self.navigationController pushViewController:profilePageSetting animated:YES];
        
    }else{
        switch (indexPath.row) {
            case 0:
                break;
                
            case 1:
            {
                FeedbackViewController *feedback = [[FeedbackViewController alloc]initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:feedback animated:YES];
                break;
            }
            
            case 2:
            {
                NSURL * urlStr = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id961562218"];//后面为参数
                if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
                    NSLog(@"going to url");
                    [[UIApplication sharedApplication] openURL:urlStr];
                }else{
                    NSLog(@"can not go to url");
                }

                break;
            }
                
            case 3:
            {
                NSURL * urlStr = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id961562218"];//后面为参数
                if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
                    NSLog(@"going to url");
                    [[UIApplication sharedApplication] openURL:urlStr];
                }else{
                    NSLog(@"can not go to url");
                }
                
                break;
            }
                
            case 4:
            {   AboutUsViewController *aboutus = [[AboutUsViewController alloc]init];
                [self.navigationController pushViewController:aboutus animated:YES];
                break;
            }
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
    
}
-(void)pushNotificationON:(UISwitch *)sender{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //TODO, update db
        AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
        afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString * settingURL = [appdel.rootURL stringByAppendingString:@"/serverside/setting_push_message.php"];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:sender.on?@"YES":@"NO" forKey:@"enablePush"];
        [dict setObject:appdel.generatedUserID forKey:@"userIdStr"];
        NSLog(@"sending setting info: %@", dict);
        [afnmanager POST:settingURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"App Push Setting Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"App Push Setting Error: %@", error);
        }];
    });
    
}
@end
