//
//  HomePageModuleView.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/2/24.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomePageModuleViewDelegate <NSObject>

-(void)titleViewSelect:(id)sender;

-(void)pushViewControllerWithSender:(id)sender1 sender2:(id)sender2 moduleView:(UIView *)view;

@end
@interface HomePageModuleView : UIView

@property (nonatomic,retain) UIButton *titleView;
@property (nonatomic,retain) NSString *title;

@property (nonatomic,weak) id<HomePageModuleViewDelegate> delegate;
@end
