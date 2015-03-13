//
//  HomePageViewController.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageProfileView.h"
#import "HomePageAbilityView.h"
#import "HomePageLocationView.h"
#import "HomePageTableView.h"

@interface HomePageViewController : UIViewController <UIScrollViewDelegate,HomePageModuleViewDelegate,HomePageProfileViewDelegate>

@end
