//
//  HomePageTableViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageTableViewCell.h"
@interface HomePageTableViewCell ()

@property (nonatomic,retain) UIImageView *iconView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,assign) CGRect aframe;
@property (nonatomic,retain) NSDictionary *dict;
@end

@implementation HomePageTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initViews];
        
    }
    return self;
    
}

-(void)initViews{
    
    self.titleLabel = [[UILabel alloc]init];
    self.iconView = [[UIImageView alloc]init];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconView];
    
}

-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.aframe = frame;
    self.dict = dict;
    
    self.titleLabel.text = @"游戏是幼儿最爱的活动~";

    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake(15, 10, 40, 40);
    self.iconView.image = [UIImage imageNamed:@"boy.jpg"];
    self.iconView.layer.cornerRadius = 3;
    self.iconView.layer.masksToBounds = YES;
    
    self.titleLabel.frame = CGRectMake(65, 0, self.aframe.size.width - 80, 60);
    self.titleLabel.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
}

@end
