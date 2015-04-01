//
//  ProfilePageNoticeTableViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/9.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "ProfilePageNoticeTableViewCell.h"
@interface ProfilePageNoticeTableViewCell ()

@property (nonatomic,retain) UIView *unreadSign;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *timeLabel;
@property (nonatomic,assign) CGRect aframe;
@end

@implementation ProfilePageNoticeTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initViews];
    }
    return self;
}

-(void)initViews{
    if(!self.unreadSign){
        self.unreadSign = [[UIView alloc]initWithFrame:CGRectMake(15, 17, 8, 8)];
        self.unreadSign.backgroundColor = [UIColor colorWithRed:33.0/255.0f green:147.0/255.0f blue:255.0/255.0f alpha:1.0f];
        self.unreadSign.layer.cornerRadius = 4;
        [self.contentView addSubview:self.unreadSign];
    }
    if(!self.titleLabel){
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
    }
    if(!self.timeLabel){
        self.timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLabel];
    }
    
}

-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame;
{
    self.titleLabel.text = @"心理学家经过长期认为，儿童时期是培养健康心";
    self.timeLabel.text = @"2015-10-10";
    self.aframe = frame;
    
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(30, 10, self.aframe.size.width - 40, 20);
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14.5f];
    self.titleLabel.textColor = [UIColor colorWithRed:100.0/255.0f green:100.0/255.0f blue:100.0/255.0f alpha:1.0f];
    
    self.timeLabel.frame = CGRectMake(15, 35, 200, 20);
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    self.timeLabel.textColor = [UIColor colorWithRed:200.0/255.0f green:200.0/255.0f blue:200.0/255.0f alpha:1.0f];
    
}

@end
