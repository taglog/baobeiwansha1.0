//
//  HomePageModuleView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageModuleView.h"
@interface HomePageModuleView()

@property (nonatomic,retain) UIButton *titleView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView *titleIcon;
@property (nonatomic,retain) UIScrollView *contentView;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,assign) CGRect aframe;
@end
@implementation HomePageModuleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.aframe = frame;
        [self initViews];
    }
    return self;
}


-(void)initViews{
    
    self.titleView = [[UIButton alloc]init];
    self.titleLabel = [[UILabel alloc]init];
    self.contentView = [[UIScrollView alloc]init];
    self.titleIcon = [[UIImageView alloc]init];
    
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.titleIcon];
    
}


-(void)setContentView:(UIScrollView *)contentView title:(NSString *)title{
    
    self.title = title;
    self.contentView = contentView;
    
    [self addSubview:self.contentView];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.titleView.frame = CGRectMake(0, 0 ,self.aframe.size.width, 45);
    
    self.titleLabel.frame = CGRectMake(15, 0, self.aframe.size.width, 45);
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 44.5f, self.titleView.frame.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [self.titleView.layer addSublayer:bottomBorder];
    
    self.titleIcon.frame = CGRectMake(self.aframe.size.width - 25, 12.5, 20, 20);
    self.titleIcon.image = [UIImage imageNamed:@"rightarrow"];

    
}
@end
