//
//  ContentViewController.h
//  baobaowansha2
//
//  Created by 上海震渊信息技术有限公司 on 14/11/18.
//  Copyright (c) 2014年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshView.h"
#import "PostViewController.h"
#import "PostTableViewCell.h"


@interface TagPostTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshViewDelegate,PostViewControllerDelegate,PostTableViewCellDelegate>

@property (nonatomic,strong)NSDictionary *requestURL;
@property (nonatomic,retain) NSString *tag;
-(id)initWithURL:(NSDictionary *)dict tag:(NSString *)tag;
-(id)initWithURL:(NSDictionary *)dict tagID:(NSInteger)tagID tag:(NSString *)tag;
-(void)simulatePullDownRefresh;

@end
