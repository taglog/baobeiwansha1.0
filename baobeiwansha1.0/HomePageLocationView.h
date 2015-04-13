//
//  HomePageLocationView.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "HomePageModuleView.h"

@interface HomePageLocationView : HomePageModuleView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

-(void)setArray:(NSArray *)array;

@end
