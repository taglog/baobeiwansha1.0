//
//  PostTableViewController.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshView.h"
#import "PostViewController.h"
#import "PostTableViewCell.h"


@protocol PostTableViewDelegate

-(void)showHUD:(NSString *)text;
-(void)dismissHUD;


@end

@interface PostTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshViewDelegate,PostViewControllerDelegate,PostTableViewCellDelegate>
@property (nonatomic,assign) NSInteger p;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSDictionary *requestURL;
@property (nonatomic,assign) NSInteger ageChoosen;
@property (nonatomic,assign) BOOL isAgeSet;

@property(nonatomic,retain)id<PostTableViewDelegate> delegate;

-(id)initWithURL:(NSDictionary *)dict type:(NSInteger)index;
-(void)simulatePullDownRefresh;

@end
