//
//  CommentTableViewCell.h
//  baobaowansha2
//
//  Created by 上海震渊信息技术有限公司 on 14/11/19.
//  Copyright (c) 2014年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

-(void)setDataWithDict:(NSDictionary *)dict frame:(CGRect)frame;

+(CGFloat)heightForCellWithDict:dict frame:(CGRect)frame;

@end
