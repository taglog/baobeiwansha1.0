//
//  HomePageLocationView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageModuleView.h"

@interface HomePageLocationView : HomePageModuleView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

-(void)setArray:(NSArray *)array;

@end
