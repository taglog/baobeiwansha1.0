//
//  AppDelegate.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/2/24.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "PanPopNavigationController.h"
#import "HomePageViewController.h"
#import "CategoryPageViewController.h"
#import "ProfilePageViewController.h"
#import "Reachability.h"

#import <AVOSCloud/AVOSCloud.h>



// umeng 渠道分析所需头文件
//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//for idfa
#import <AdSupport/AdSupport.h>
#include <UMengAnalytics/MobClick.h>


@interface AppDelegate ()

@property (nonatomic,retain) UINavigationController *userInfoNav;
//主tabBarController
@property (nonatomic,retain) UITabBarController *mainTabBarController;

//判断是否有网络
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (nonatomic,assign) NSInteger reachability;
@property (nonatomic,retain) UILabel *reachabilitySign;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //初始化网络监测
    [self initReachability];
    //全局变量设置
    [self globalSettings];
    //uuid
    [self generateUserID];
    //第三方代码
    [self thirdPartiesCode:launchOptions];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    
    //初始化主viewControllers
    [self initViewControllers];
    
    //第一次启动
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
    
    self.rootURL = @"http://blogtest.yhb360.com/baobaowansha1.1/";

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

-(void)thirdPartiesCode:(NSDictionary *)launchOptions{
    
    
    // leancloud 统计
    //push notification setting
    [AVOSCloud setApplicationId:@"zul2tbfbwbfhtzka27mea6ozakqg3m86v2dpk349e7hh9syv"
                      clientKey:@"0mikvyvihrejfctvqarlhwvuet67pahni8fjvrse8sai4okj"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];


    // umeng 统计
    [MobClick startWithAppkey:@"5487dc8ffd98c53799000ea9" reportPolicy:BATCH   channelId:@"App Store"];
    
    
    
    
    // umeng 渠道分析
    NSString * appKey = @"5487dc8ffd98c53799000ea9";
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [self macString];
    NSString * idfa = [self idfaString];
    NSString * idfv = [self idfvString];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
    
    

    
}


-(void)initViewControllers{
    
    if(!self.mainTabBarController){
        self.mainTabBarController = [[UITabBarController alloc]init];
    }
    self.mainTabBarController.tabBar.translucent = NO;
    self.mainTabBarController.tabBar.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
    
    UITabBarItem *mainTabFirst = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home_gray"] tag:0];
    UITabBarItem *mainTabSecond = [[UITabBarItem alloc]initWithTitle:@"分类" image:[UIImage imageNamed:@"tabbar_category_gray"] tag:1];
    UITabBarItem *mainTabThird = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"tabbar_aboutme_gray"] tag:2];
    
    HomePageViewController *homePageViewController = [[HomePageViewController alloc]init];
    UINavigationController *homePageNav = [[UINavigationController alloc]initWithRootViewController:homePageViewController];
    homePageViewController.tabBarItem = mainTabFirst;
    homePageViewController.tabBarItem.title = @"首页";

    CategoryPageViewController *categoryPageViewController = [[CategoryPageViewController alloc]init];
    UINavigationController *playPageNav = [[UINavigationController alloc]initWithRootViewController:categoryPageViewController];
    categoryPageViewController.tabBarItem = mainTabSecond;
    categoryPageViewController.tabBarItem.title = @"分类";
    
    ProfilePageViewController *profilePageViewController = [[ProfilePageViewController alloc]init];
    UINavigationController *profilePageNav = [[UINavigationController alloc]initWithRootViewController:profilePageViewController];
    profilePageViewController.tabBarItem = mainTabThird;
    profilePageViewController.tabBarItem.title = @"我的";
    
    self.mainTabBarController.viewControllers = [NSArray arrayWithObjects:homePageNav,playPageNav,profilePageNav,nil];
    
}

-(void)showIntroView{
    
    IntroductionViewController *introViewController = [[IntroductionViewController alloc]init];
    introViewController.delegate = self;
    self.window.rootViewController = introViewController;
    
    
}
//introview结束delegate方法
-(void)introViewFinished{
    
    UserInfoSettingViewController  *userInfoSettingViewController = [[UserInfoSettingViewController alloc]init];
    userInfoSettingViewController.showLeftBarButtonItem = NO;
    userInfoSettingViewController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:
                                   userInfoSettingViewController];
    self.window.rootViewController = nav;
    
}

//设置完用户信息之后
-(void)popUserInfoSettingViewController{
    
    //NSLog(@"to pop");
    [UIView animateWithDuration:2.0 animations:^{
        self.userInfoNav.view.alpha = 0;
    } completion:^(BOOL finished) {
        self.window.rootViewController = self.mainTabBarController;
    }];
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // avos的代码
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

#pragma mark - 判断网络情况
-(void)initReachability{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    __weak __block typeof(self) weakself = self;
    
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    
    self.internetReachability.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"reachable");
        });
    };
    
    self.internetReachability.unreachableBlock = ^(Reachability * reachability)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself showReachabilitySign];
            NSLog(@"not reachable");
            
        });
    };
    
    [self.internetReachability startNotifier];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    // we ONLY want to be reachable on WIFI - cellular is NOT an acceptable connectivity
    self.wifiReachability.reachableOnWWAN = NO;
    
    self.wifiReachability.reachableBlock = ^(Reachability * reachability)
    {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    
    //无wifi连接的时候，是不是要通知用户
    self.wifiReachability.unreachableBlock = ^(Reachability * reachability)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"reachable");
            
        });
    };
    
    [self.wifiReachability startNotifier];
    
    
}

//连接状态发生改变
-(void)reachabilityChanged:(NSNotification *)note{
    
    Reachability * reach = [note object];
    
    if (reach == self.internetReachability)
    {
        if([reach isReachable])
        {
            if(self.reachability == YES){
                [self hideReachabilitySign];
            }
            
        }
        else
        {
            [self showReachabilitySign];
            
        }
    }
    
    
    
}

-(void)showReachabilitySign{
    
    if(!self.reachabilitySign){
        self.reachabilitySign = [[UILabel alloc]initWithFrame:CGRectMake(0, -40, self.window.frame.size.width, 40.0f)];
        self.reachabilitySign.backgroundColor = [UIColor redColor];
        self.reachabilitySign.text = @"没有网络连接哦~";
        self.reachabilitySign.textColor = [UIColor whiteColor];
        self.reachabilitySign.font = [UIFont systemFontOfSize:12.0f];
        self.reachabilitySign.textAlignment = NSTextAlignmentCenter;
        [self.window addSubview:self.reachabilitySign];
        [self.window bringSubviewToFront:self.reachabilitySign];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.reachabilitySign.frame = CGRectMake(0, 0, self.window.frame.size.width, 40.0f);
    } completion:^(BOOL finished) {
        self.reachability = YES;
    }];
}

-(void)hideReachabilitySign{
    [UIView animateWithDuration:0.2 animations:^{
        self.reachabilitySign.frame = CGRectMake(0, -40, self.window.frame.size.width, 40.0f);
    } completion:^(BOOL finished) {
        self.reachability = NO;
    }];
}

//获取用户信息的plist
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
    if(month < 0) {
        string = [NSString stringWithFormat:@"%d个月后出生",month*(-1)];
    } else if(month < 24){
        string = [NSString stringWithFormat:@"%d个月",month];
        
    }else{
        string = [NSString stringWithFormat:@"%d岁%d个月",month / 12,month % 12];
        if(month %12 == 0){
            string = [NSString stringWithFormat:@"%d岁",month / 12];
        }
        
    }
    return string;
}

//数字月份转换字符串
+(NSString *)birthdayToString:(NSInteger)days{
    NSString *string;
    int month = floor(days/30);
    if(month < 0) {
        string = [NSString stringWithFormat:@"%d个月后出生",month*(-1)];
    } else if(month == 0){
        if(days < 0) string = [NSString stringWithFormat:@"%d天后出生",days*(-1)];
        else string = [NSString stringWithFormat:@"%d天",days];
        
    }else if(month<24){ // >0 and < 24
        string = [NSString stringWithFormat:@"%d个月",month];
    }else{
        string = [NSString stringWithFormat:@"%d岁%d个月",month / 12,month % 12];
        if(month %12 == 0){
            string = [NSString stringWithFormat:@"%d岁",month / 12];
        }
        
    }
    return string;
}



// umeng 渠道分析代码 begin

- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

- (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}


// umeng 渠道分析代码 end




@end
