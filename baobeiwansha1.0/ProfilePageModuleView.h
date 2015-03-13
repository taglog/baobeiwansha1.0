//
//  ProfilePageModuleView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/9.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfilePageModuleViewDelegate

-(void)titleViewSelect:(id)sender;

@end

@interface ProfilePageModuleView : UIView

@property (nonatomic,retain) UIButton *titleView;
@property (nonatomic,retain) NSString *moduleTitle;
@property (nonatomic,retain) NSString *moduleDetail;
@property (nonatomic,retain) UITableView *contentTableView;

@property (nonatomic,weak) id<ProfilePageModuleViewDelegate> delegate;

@end
