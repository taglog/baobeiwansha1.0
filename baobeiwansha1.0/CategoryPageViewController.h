//
//  PlayPageViewController.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidePagerViewController.h"
#import "PostTableViewController.h"
#import "PostViewController.h"

@interface CategoryPageViewController : UIViewController<SlidePagerViewControllerDataSource,SlidePagerViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,PostTableViewDelegate>

@end
