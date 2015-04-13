//
//  HomePageLocationViewCell.h
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/2/25.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageLocationViewCell : UICollectionViewCell
@property (nonatomic,retain) UIImageView *iconView;

-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame;
@end
