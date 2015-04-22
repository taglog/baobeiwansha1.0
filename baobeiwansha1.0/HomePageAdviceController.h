//
//  HomePageAdviceController.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/19.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshView.h"
#import "PostViewController.h"

@interface HomePageAdviceController : UIViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshViewDelegate>

//@property (nonatomic,strong)NSDictionary *requestURL;
//@property (nonatomic,retain) NSString *tag;

-(id)initWithURL:(NSDictionary *)dict;
-(void)simulatePullDownRefresh;

@property (nonatomic,retain) NSMutableArray *adviceArray;

@end
