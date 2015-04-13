//
//  TagPageViewController.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshView.h"


@interface TagPageViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EGORefreshViewDelegate>

@property (nonatomic,strong) NSDictionary *requestURL;
@property (nonatomic,assign) NSInteger p;

-(id)initWithType:(NSInteger)type;

@end
