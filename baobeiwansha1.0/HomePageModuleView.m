//
//  HomePageModuleView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageModuleView.h"

@interface HomePageModuleView()

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView *titleIcon;
@property (nonatomic,assign) CGRect aframe;

@end
@implementation HomePageModuleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.aframe = frame;
        [self initTitleView];
    }
    return self;
}


-(void)initTitleView{
    
    if(!self.titleView){
        self.titleView = [[UIButton alloc]init];
        
        [self.titleView addTarget:self action:@selector(titleViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.titleView];
    }
    
    if(!self.titleLabel){
        self.titleLabel = [[UILabel alloc]init];
        [self.titleView addSubview:self.titleLabel];
    }
    
    if(!self.titleIcon){
        self.titleIcon = [[UIImageView alloc]init];
        [self.titleView addSubview:self.titleIcon];
    }
    
    
    [self setNeedsLayout];

}

-(void)titleViewClicked:(id)sender{
    
    [self.delegate titleViewSelect:sender];

}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //module的上下边界
    CALayer *titleViewTopBorder = [CALayer layer];
    titleViewTopBorder.frame = CGRectMake(0.0f, 0.0f, self.aframe.size.width, 0.5f);
    titleViewTopBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                           alpha:1.0f].CGColor;
    [self.layer addSublayer:titleViewTopBorder];
    
    CALayer *titleViewBottomBorder = [CALayer layer];
    titleViewBottomBorder.frame = CGRectMake(0.0f, self.aframe.size.height, self.aframe.size.width, 0.5f);
    titleViewBottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                              alpha:1.0f].CGColor;
    [self.layer addSublayer:titleViewBottomBorder];
    
    //module的titleview
    self.titleView.frame = CGRectMake(0, 0 ,self.aframe.size.width, 45);
    
    self.titleLabel.frame = CGRectMake(15, 0, self.aframe.size.width, 45);
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14.0f];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 44.5f, self.titleView.frame.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [self.titleView.layer addSublayer:bottomBorder];
    
    self.titleIcon.frame = CGRectMake(self.aframe.size.width - 25, 12.5, 20, 20);
    self.titleIcon.image = [UIImage imageNamed:@"rightarrow"];

    
}
@end
