//
//  HomePageProfileView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomePageProfileViewDelegate <NSObject>
-(void)pushProfilePageSettingViewController;
-(void)pushBabyConditionViewController;
@end
@interface HomePageProfileView : UIView
@property (nonatomic,weak) id<HomePageProfileViewDelegate> delegate;
-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame;
@end
