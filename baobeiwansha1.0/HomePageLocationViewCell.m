//
//  HomePageLocationViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageLocationViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface HomePageLocationViewCell ()

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSString *tag;
@property (nonatomic,retain) UIImageView *icon;
@property (nonatomic,assign) CGRect aframe;
@property (nonatomic,retain) NSDictionary *dict;


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

-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.aframe = frame;
    self.dict = dict;
    if([dict valueForKey:@"name"] != (id)[NSNull null]){
        self.tag = [dict valueForKey:@"name"];
    }
    
    if([dict valueForKey:@"tag_imgurl"]!= (id)[NSNull null]&&[self.dict valueForKey:@"tag_imgurl"]){
        NSString *imgUrlString = [NSString stringWithFormat:@"http://61.174.9.214/www/imgs/tagicon/%@.png",[self.dict valueForKey:@"tag_imgurl"]];
        NSURL *imgUrl = [NSURL URLWithString:[imgUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.icon setImageWithURL:imgUrl placeholderImage:nil];
        
    }
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat itemWidth = (self.aframe.size.width - 30)/4;

    self.iconView.frame = CGRectMake((itemWidth - 60)/2,0,60,60);

    self.iconView.layer.cornerRadius = 30;
    self.iconView.layer.masksToBounds = YES;

    self.icon.frame = CGRectMake(12, 12, 36, 36);
    
    self.titleLabel.frame = CGRectMake(0, 75, itemWidth, 20);
    self.titleLabel.text = self.tag;
    self.titleLabel.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    
}


@end
