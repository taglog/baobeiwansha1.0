//
//  TagPageViewController.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshView.h"


@interface TagPageViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EGORefreshViewDelegate>

@property (nonatomic,strong) NSDictionary *requestURL;
@property (nonatomic,assign) NSInteger p;

-(id)initWithType:(NSInteger)type;

@end
