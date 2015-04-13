//
//  IntroductionViewController.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/21.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroViewController.h"
@protocol IntroductionViewDelegate <NSObject>

-(void)introViewFinished;

@end
@interface IntroductionViewController : UIViewController<IntroViewControllerDataSource,IntroViewControllerDelegate>

@property (nonatomic,weak) id<IntroductionViewDelegate>delegate;

@end
