//
//  ProfilePageViewController.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/2/25.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilePageModuleView.h"
#import "EGORefreshView.h"

@interface ProfilePageViewController : UIViewController <ProfilePageModuleViewDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshViewDelegate>

@end
