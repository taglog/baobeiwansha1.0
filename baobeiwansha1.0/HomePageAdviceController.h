//
//  HomePageAdviceController.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/19.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshView.h"
#import "PostViewController.h"

@interface HomePageAdviceController : UIViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshViewDelegate>

@property (nonatomic,strong)NSDictionary *requestURL;
@property (nonatomic,retain) NSString *tag;

-(id)initWithURL:(NSDictionary *)dict;
-(void)simulatePullDownRefresh;

@end
