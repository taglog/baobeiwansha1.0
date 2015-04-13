//
//  AppDelegate.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/2/24.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoSettingViewController.h"
#import "IntroductionViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UserInfoSettingViewDelegate,IntroductionViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) NSString *rootURL;

@property (nonatomic, retain) NSString *generatedUserID;

+(NSString *)dataFilePath;
+(NSString *)birthdayMonthToString:(NSInteger)months;
+(NSString *)birthdayToString:(NSInteger)days;

@end

