//
//  HomePageLocationViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageLocationViewCell.h"

@interface HomePageLocationViewCell ()

@property (nonatomic,retain) UIImageView *iconView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSString *tag;

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
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    
    
}

-(void)setDict:(NSDictionary *)dict{
    
    self.tag = [dict valueForKey:@"tag_name"];
    
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.iconView.frame = CGRectMake(0,10,60,60);
    self.iconView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:76.0/255.0f blue:162.0/255.0f alpha:1.0f];
    self.iconView.layer.cornerRadius = 30;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.image = [UIImage imageNamed:@""];
    self.titleLabel.frame = CGRectMake(0, 75, 60, 20);
    self.titleLabel.text = self.tag;
    self.titleLabel.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
}


@end
