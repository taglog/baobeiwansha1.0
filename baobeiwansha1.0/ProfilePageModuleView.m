//
//  ProfilePageModuleView.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/9.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "ProfilePageModuleView.h"

@interface ProfilePageModuleView ()


@property (nonatomic,assign) CGRect aframe;
@property (nonatomic,retain) CALayer *topBorder;
@property (nonatomic,retain) CALayer *bottomBorder;
@property (nonatomic,retain) CALayer *tableViewTopBorder;

@end

@implementation ProfilePageModuleView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.aframe = frame;
        [self initViews];
    }
    return self;
}

-(void)initViews{
    
    if(!self.titleView){
        self.titleView = [[UIButton alloc]init];
        [self.titleView addTarget:self action:@selector(titleViewSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.titleView];
    }
    if(!self.moduleTitleLabel){
        self.moduleTitleLabel = [[UILabel alloc]init];
        [self.titleView addSubview:self.moduleTitleLabel];
    }
    if(!self.moduleDetailLabel){
        self.moduleDetailLabel = [[UILabel alloc]init];
        [self.titleView addSubview:self.moduleDetailLabel];
    }
    if(!self.contentTableView){
        self.contentTableView = [[UITableView alloc]init];
        self.contentTableView.scrollEnabled = NO;
        [self addSubview:self.contentTableView];
    }
    if(!self.topBorder){
        self.topBorder = [CALayer layer];
        [self.layer addSublayer:self.topBorder];

    }
    if(!self.bottomBorder){
        self.bottomBorder = [CALayer layer];
        [self.layer addSublayer:self.bottomBorder];

    }
    if(!self.tableViewTopBorder){
        self.tableViewTopBorder = [CALayer layer];
        [self.contentTableView.layer addSublayer:self.tableViewTopBorder];

    }


    [self setNeedsLayout];

}

-(void)titleViewSelected:(id)sender{
    [self.delegate titleViewSelect:sender];

}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.aframe = frame;
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //module的上下边界
    self.topBorder.frame = CGRectMake(0.0f, 0.0f, self.aframe.size.width, 0.5f);
    self.topBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                           alpha:1.0f].CGColor;
    
    self.bottomBorder.frame = CGRectMake(0.0f, self.aframe.size.height, self.aframe.size.width, 0.5f);
    self.bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                              alpha:1.0f].CGColor;
    
    self.backgroundColor = [UIColor whiteColor];
    UIColor *titleColor = [UIColor colorWithRed:152.0/255.0f green:152.0/255.0f blue:152.0/255.0f alpha:1.0f];
    self.titleView.frame = CGRectMake(0, 0, self.aframe.size.width, 60.0f);
    self.titleView.backgroundColor = [UIColor colorWithRed:250.0/255.0f green:250.0/255.0f blue:250.0/255.0f alpha:1.0f];
    
    
    self.moduleTitleLabel.frame = CGRectMake(15, 25, 140, 30);
    self.moduleTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.moduleTitleLabel.textColor = titleColor;
    
    self.moduleDetailLabel.frame = CGRectMake(150, 27, self.aframe.size.width - 165,30);
    self.moduleDetailLabel.font = [UIFont systemFontOfSize:13.0f];
    self.moduleDetailLabel.textColor = titleColor;
    self.moduleDetailLabel.textAlignment = NSTextAlignmentRight;
    
    self.contentTableView.frame = CGRectMake(0, 60, self.aframe.size.width, self.aframe.size.height - 60);
    
    self.tableViewTopBorder.frame = CGRectMake(0.0f, 0.0f, self.aframe.size.width, 0.5f);
    self.tableViewTopBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                  alpha:1.0f].CGColor;
}

@end
