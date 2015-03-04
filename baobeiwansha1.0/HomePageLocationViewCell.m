//
//  HomePageLocationViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageLocationViewCell.h"

@interface HomePageLocationViewCell ()

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSString *tag;
@property (nonatomic,retain) UIImageView *icon;
@property (nonatomic,assign) CGRect aframe;

@end
@implementation HomePageLocationViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        self.aframe = frame;
        [self initViews];
    }
    return self;
}

-(void)initViews{
    self.iconView = [[UIImageView alloc]init];
    self.icon = [[UIImageView alloc]init];
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    [self.iconView addSubview:self.icon];
    
    
}

-(void)setDict:(NSDictionary *)dict{
    
    if([dict valueForKey:@"tag_name"]){
        self.tag = [dict valueForKey:@"tag_name"];
    }
    
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake(0,10,60,60);

    self.iconView.layer.cornerRadius = 30;
    self.iconView.layer.masksToBounds = YES;

    self.icon.frame = CGRectMake(12, 12, 36, 36);
    self.icon.image = [UIImage imageNamed:@"book2"];
    
    self.titleLabel.frame = CGRectMake(0, 75, 60, 20);
    self.titleLabel.text = self.tag;
    self.titleLabel.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    
}


@end
