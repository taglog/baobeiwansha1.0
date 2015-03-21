//
//  IntroductionViewController.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/21.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroViewController.h"
@protocol IntroductionViewDelegate <NSObject>

-(void)introViewFinished;

@end
@interface IntroductionViewController : UIViewController<IntroViewControllerDataSource,IntroViewControllerDelegate>

@property (nonatomic,weak) id<IntroductionViewDelegate>delegate;

@end
