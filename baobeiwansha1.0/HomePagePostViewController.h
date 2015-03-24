//
//  HomePagePostViewController.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/23.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTextView.h"
#import "AFNetworking.h"

@interface HomePagePostViewController : UIViewController<PostTextViewDelegate>

-(void)initViewWithDict:(NSDictionary *)dict;
-(void)noDataAlert;
-(void)showHUD;
-(void)dismissHUD;

@property (nonatomic) long currentPostID;
@property (nonatomic) long originalDaysIndex;
@property (nonatomic) long currentDaysIndex;


@end
