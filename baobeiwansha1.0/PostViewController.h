//
//  PostViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/14.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostView.h"
#import "EGORefreshView.h"
#import "CommentCreateViewController.h"

@protocol PostViewControllerDelegate
//type = 1 收藏成功 type = 0 取消成功
-(void)updateCollectionCount:(NSIndexPath *)indexPath type:(NSInteger)type;

@end
@interface PostViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshViewDelegate,CommentCreateDelegate,UIActionSheetDelegate,PostViewDelegate>

@property (nonatomic,retain) NSIndexPath *indexPath;
@property (nonatomic,retain) id<PostViewControllerDelegate>delegate;
-(void)initViewWithDict:(NSDictionary *)dict;
-(void)noDataAlert;
-(void)showHUD;
-(void)dismissHUD;

@end
