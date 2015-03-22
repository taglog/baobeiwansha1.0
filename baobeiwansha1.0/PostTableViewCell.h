//
//  PostTableViewCell.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PostTableViewCellDelegate <NSObject>

-(void)collectPost:(NSIndexPath *)indexPath;

@end
@interface PostTableViewCell : UITableViewCell

-(void)setDataWithDict:(NSDictionary *)dict frame:(CGRect)frame indexPath:(NSIndexPath *)indexPath;

-(void)updateCollectionCount:(NSInteger)collectionNumber type:(NSInteger)type;

@property (nonatomic,weak) id<PostTableViewCellDelegate> delegate;

@end
