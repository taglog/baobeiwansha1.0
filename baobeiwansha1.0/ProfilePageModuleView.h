//
//  ProfilePageModuleView.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/9.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfilePageModuleViewDelegate

-(void)titleViewSelect:(id)sender;

@end

@interface ProfilePageModuleView : UIView

@property (nonatomic,retain) UIButton *titleView;
@property (nonatomic,retain) UITableView *contentTableView;

@property (nonatomic,retain) UILabel *moduleTitleLabel;
@property (nonatomic,retain) UILabel *moduleDetailLabel;

@property (nonatomic,weak) id<ProfilePageModuleViewDelegate> delegate;

@end
