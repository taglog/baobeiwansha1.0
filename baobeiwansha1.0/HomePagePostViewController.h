//
//  HomePagePostViewController.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/23.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostView.h"
#import "AFNetworking.h"

@interface HomePagePostViewController : UIViewController<PostViewDelegate>
-(void)initViewWithDict:(NSDictionary *)dict;
-(void)noDataAlert;
-(void)showHUD;
-(void)dismissHUD;

@property (nonatomic) long currentPostID;
@property (nonatomic) long originalDaysIndex;
@property (nonatomic) long currentDaysIndex;


@end
