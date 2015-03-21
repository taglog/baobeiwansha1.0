//
//  AppDelegate.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PanPopNavigationController.h"
#import "HomePageViewController.h"
#import "CategoryPageViewController.h"
#import "ProfilePageViewController.h"

@interface AppDelegate ()
@property (nonatomic,retain) UINavigationController *userInfoNav;
@property (nonatomic,retain) UITabBarController *mainTabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self globalSettings];
    [self generateUserID];
    [self pushNotificationSettings:launchOptions];
    
    

    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //第一次启动
    [self initViewControllers];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        
        [self showIntroView];
        
        
    }else{
    
        self.window.rootViewController = self.mainTabBarController;
        
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    } else {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                | UIUserNotificationTypeBadge
                                                | UIUserNotificationTypeSound
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)globalSettings{
    
    self.rootURL = @"http://blog.yhb360.com/baobaowansha/";

}
-(void)generateUserID{
    
    // generate UserID using VenderID
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"generatedUserID"] == nil) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
            self.generatedUserID = [UIDevice currentDevice].identifierForVendor.UUIDString;
        else
            self.generatedUserID = ((__bridge NSString *)(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))));
        NSLog(@"generate UserID from UIDevice, %@", self.generatedUserID);
        [[NSUserDefaults standardUserDefaults] setObject:self.generatedUserID forKey:@"generatedUserID"];
    } else {
        self.generatedUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"generatedUserID"];
        NSLog(@"get UserID from NSUserDefaults, %@", self.generatedUserID);
    }
    
    // send information(id, and start time) to serverside
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //TODO, update db
        AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
        afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString * settingURL = [self.rootURL stringByAppendingString:@"/serverside/app_statistic.php?action=app_start"];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.generatedUserID forKey:@"userIdStr"];
        NSLog(@"sending statistic info: %@", dict);
        [afnmanager POST:settingURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"App statistic update Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"App statistic update Error: %@", error);
        }];
    });

    
}

-(void)pushNotificationSettings:(NSDictionary *)launchOptions{

    //push notification setting
    [AVOSCloud setApplicationId:@"zul2tbfbwbfhtzka27mea6ozakqg3m86v2dpk349e7hh9syv"
                      clientKey:@"0mikvyvihrejfctvqarlhwvuet67pahni8fjvrse8sai4okj"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
}


-(void)initViewControllers{
    
    if(!self.mainTabBarController){
        self.mainTabBarController = [[UITabBarController alloc]init];
    }
    self.mainTabBarController.tabBar.translucent = NO;
    self.mainTabBarController.tabBar.tintColor = [UIColor colorWithRed:255.0/255.0f green:78.0/255.0f blue:162.0/255.0f alpha:1.0f];
    
    UITabBarItem *mainTabFirst = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home_gray"] tag:0];
    UITabBarItem *mainTabSecond = [[UITabBarItem alloc]initWithTitle:@"分类" image:[UIImage imageNamed:@"tabbar_category_gray"] tag:1];
    UITabBarItem *mainTabThird = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"tabbar_aboutme_gray"] tag:2];
    
    HomePageViewController *homePageViewController = [[HomePageViewController alloc]init];
    PanPopNavigationController *homePageNav = [[PanPopNavigationController alloc]initWithRootViewController:homePageViewController];
    homePageViewController.tabBarItem = mainTabFirst;
    homePageViewController.tabBarItem.title = @"首页";

    CategoryPageViewController *categoryPageViewController = [[CategoryPageViewController alloc]init];
    PanPopNavigationController *playPageNav = [[PanPopNavigationController alloc]initWithRootViewController:categoryPageViewController];
    categoryPageViewController.tabBarItem = mainTabSecond;
    categoryPageViewController.tabBarItem.title = @"分类";
    
    ProfilePageViewController *profilePageViewController = [[ProfilePageViewController alloc]init];
    PanPopNavigationController *profilePageNav = [[PanPopNavigationController alloc]initWithRootViewController:profilePageViewController];
    profilePageViewController.tabBarItem = mainTabThird;
    profilePageViewController.tabBarItem.title = @"我的";
    
    self.mainTabBarController.viewControllers = [NSArray arrayWithObjects:homePageNav,playPageNav,profilePageNav,nil];
    
}
-(void)showIntroView{
    
    IntroductionViewController *introViewController = [[IntroductionViewController alloc]init];
    introViewController.delegate = self;
    self.window.rootViewController = introViewController;
    
    
}

-(void)introViewFinished{
    
    UserInfoSettingViewController  *userInfoSettingViewController = [[UserInfoSettingViewController alloc]init];
    userInfoSettingViewController.showLeftBarButtonItem = NO;
    userInfoSettingViewController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:
                                   userInfoSettingViewController];
    self.window.rootViewController = nav;
    
}
-(void)popUserInfoSettingViewController{
    
    [UIView animateWithDuration:2.0 animations:^{
        self.userInfoNav.view.alpha = 0;
    } completion:^(BOOL finished) {
        self.window.rootViewController = self.mainTabBarController;
    }];
    
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 去掉了avos的代码
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    NSLog(@"applicate device token is called with tocken:%@", deviceToken);
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    // send token to our own user db
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //TODO, update db
        //NSString *tokenStr = [[NSString alloc] initWithData:deviceToken  encoding:NSUTF8StringEncoding];
        NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        NSString *deviceTokenStr = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
        afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString * settingURL = [self.rootURL stringByAppendingString:@"/serverside/app_token.php?action=token"];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.generatedUserID forKey:@"userIdStr"];
        [dict setObject:deviceTokenStr forKey:@"userIOSToken"];
        NSLog(@"sending token: %@", dict);
        [afnmanager POST:settingURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Token update Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Token update Error: %@", error);
        }];
    });
    
    
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"register notification failed with code: %@", error);
}

#pragma mark - 公有函数

+(NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"userinfo.plist"];
}

//数字月份转换字符串
+(NSString *)birthdayMonthToString:(NSInteger)month{
    NSString *string;
    if(month < 24){
        string = [NSString stringWithFormat:@"%ld个月",(long)month];
        
    }else{
        string = [NSString stringWithFormat:@"%ld岁%ld个月",month / 12,month % 12];
        if(month %12 == 0){
            string = [NSString stringWithFormat:@"%ld岁",month / 12];
        }
        
    }
    return string;
}

@end
