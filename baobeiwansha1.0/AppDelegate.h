//
//  AppDelegate.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoSettingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UserInfoSettingViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) NSString *rootURL;

@property (nonatomic, retain) NSString *generatedUserID;

+(NSString *)dataFilePath;
+(NSString *)birthdayMonthToString:(NSInteger)month;

@end

