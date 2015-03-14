//
//  ProfileTableViewController.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/14.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SlidePagerViewController.h"
#import "PostTableViewController.h"

@interface ProfilePageTableViewController : UIViewController<SlidePagerViewControllerDataSource,SlidePagerViewControllerDelegate,PostTableViewDelegate>

-(id)initWithUrl:(NSDictionary *)url title:(NSString *)title;

@property (nonatomic,retain) NSDictionary *requestUrl;
@property (nonatomic,retain) NSString *navigationTitle;
@end
