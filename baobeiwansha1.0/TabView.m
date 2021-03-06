//
//  TabView.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/3.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "TabView.h"

@interface TabView ()

@property (nonatomic,retain) UIImage *normalIcon;
@property (nonatomic,retain) UIImage *highlightIcon;
@property (nonatomic,retain) CALayer *bottomBorder;
@end
@implementation TabView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initViews];
    }
    return self;
}

-(void)initViews{
    
    if(!self.tabIcon){
        self.tabIcon = [[UIImageView alloc]init];
        [self addSubview:self.tabIcon];
    }
    if(!self.tabLabel){
        self.tabLabel= [[UILabel alloc]init];
        [self addSubview:self.tabLabel];
    }
    if(!self.bottomBorder){
        self.bottomBorder = [CALayer layer];
        [self.layer addSublayer:self.bottomBorder];
    }
    
}

-(void)setNormalIcon:(UIImage *)normalIcon highlightIcon:(UIImage *)highlightIcon tabTitle:(NSString *)tabTitle{
    
    self.normalIcon = normalIcon;
    self.highlightIcon = highlightIcon;
    self.tabTitle = tabTitle;
    
    [self setTabToNormal];
    
    [self setNeedsLayout];
    
    
}
-(void)layoutSubviews{
    
    [self sizeToFit];
    
    self.backgroundColor = [UIColor colorWithRed:225.0/255.0f green:225.0/255.0f blue:225.0/255.0f alpha:1.0f];
    
    self.tabIcon.frame = CGRectMake((self.frame.size.width - 23)/2, 8, 23, 23);
    
    self.tabLabel.frame = CGRectMake(0, 10 + self.tabIcon.frame.size.height, self.frame.size.width, 16.0);
    self.tabLabel.text = self.tabTitle;
    self.tabLabel.textAlignment = NSTextAlignmentCenter;
    self.tabLabel.font = [UIFont systemFontOfSize: 12.0f];
    
    self.bottomBorder.frame = CGRectMake(0, self.frame.size.height-0.5f, self.frame.size.width, 0.5f);
    self.bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                          alpha:1.0f].CGColor;
    
    
}

-(void)setTabToNormal{
    
    self.tabIcon.image = self.normalIcon;
    self.tabLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:151.0f/255.0f blue:151.0/255.0f alpha:1.0];
}

-(void)setTabToHighlight{
    
    self.tabIcon.image = self.highlightIcon;
    self.tabLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0f];
    
}
@end
