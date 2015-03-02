//
//  AppDelegate.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "PlayPageViewController.h"
#import "ProfilePageViewController.h"

#import "PostTableViewController.h"

@interface AppDelegate ()
@property (nonatomic,retain) UITabBarController *mainTabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //初始化TabViewController
    //[self initViewControllers];
    PostTableViewController *tagPage = [[PostTableViewController alloc]init];
    UINavigationController *tag = [[UINavigationController alloc]initWithRootViewController:tagPage];
    self.window.rootViewController = tag;
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

-(void)initViewControllers{
    
    if(!self.mainTabBarController){
        self.mainTabBarController = [[UITabBarController alloc]init];
    }
    self.mainTabBarController.tabBar.translucent = NO;
    UITabBarItem *mainTabFirst = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home"] tag:0];
    UITabBarItem *mainTabSecond = [[UITabBarItem alloc]initWithTitle:@"玩啥" image:[UIImage imageNamed:@"home"] tag:1];
    UITabBarItem *mainTabThird = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"home"] tag:2];
    
    HomePageViewController *homePageViewController = [[HomePageViewController alloc]init];
    UINavigationController *homePageNav = [[UINavigationController alloc]initWithRootViewController:homePageViewController];
    homePageViewController.tabBarItem = mainTabFirst;
    homePageViewController.tabBarItem.title = @"首页";

    PlayPageViewController *playPageViewController = [[PlayPageViewController alloc]init];
    UINavigationController *playPageNav = [[UINavigationController alloc]initWithRootViewController:playPageViewController];
    playPageViewController.tabBarItem = mainTabSecond;
    playPageViewController.tabBarItem.title = @"玩啥";
    
    ProfilePageViewController *profilePageViewController = [[ProfilePageViewController alloc]init];
    UINavigationController *profilePageNav = [[UINavigationController alloc]initWithRootViewController:profilePageViewController];
    profilePageViewController.tabBarItem = mainTabThird;
    profilePageViewController.tabBarItem.title = @"我的";
    
    self.mainTabBarController.viewControllers = [NSArray arrayWithObjects:homePageNav,playPageNav,profilePageNav,nil];
    
}
@end
