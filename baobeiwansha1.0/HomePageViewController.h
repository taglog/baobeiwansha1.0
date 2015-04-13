//
//  HomePageViewController.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/2/24.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageProfileView.h"
#import "HomePageAbilityView.h"
#import "HomePageLocationView.h"
#import "HomePageTableView.h"
#import "EGORefreshView.h"

@interface HomePageViewController : UIViewController <UIScrollViewDelegate,HomePageModuleViewDelegate,HomePageProfileViewDelegate,EGORefreshViewDelegate>

@end
