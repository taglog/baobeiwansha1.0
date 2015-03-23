//
//  HomePageAbilityViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageAbilityViewCell.h"
@interface HomePageAbilityViewCell ()

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIView *descriptionView;
@property (nonatomic,retain) UILabel *descriptionLabelTop;
@property (nonatomic,retain) UILabel *descriptionLabelBottom;

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *descriptionStringTop;
@property (nonatomic,retain) NSString *descriptionStringBottom;
@property (nonatomic,assign) CGRect aframe;
@end

@implementation HomePageAbilityViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if(self){
        self.aframe = frame;
        [self initViews];
    }
    return self;
}

-(void)initViews{
    
    if(!self.titleLabel){
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];

    }
    if(!self.descriptionView){
        self.descriptionView = [[UIView alloc]init];
        [self.contentView addSubview: self.descriptionView];

    }
    
    if(!self.descriptionLabelTop){
        self.descriptionLabelTop = [[UILabel alloc]init];
        [self.descriptionView addSubview:self.descriptionLabelTop];

    }
    
    if(!self.descriptionLabelBottom){
        self.descriptionLabelBottom = [[UILabel alloc]init];
        [self.descriptionView addSubview:self.descriptionLabelBottom];

    }

    
}

-(void)setDict:(NSDictionary *)dict{

    if([dict valueForKey:@"tag_name"]!= (id)[NSNull null]){
        self.title = [dict valueForKey:@"tag_name"];
    }
    NSString *description = [dict valueForKey:@"tag_description"];
    if(description != (id)[NSNull null]){
        
        NSRange range;
        range = [description rangeOfString:@"|"];
        if(range.location == NSNotFound){
            range = [description rangeOfString:@"$$$$"];
        }
        self.descriptionStringTop = [description substringToIndex:range.location];
        self.descriptionStringBottom = [description substringFromIndex:range.location+1];
    }
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = 5;
    
    self.titleLabel.frame = CGRectMake(0, 3,self.aframe.size.width, 20);
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:17.0f];
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.descriptionView.frame = CGRectMake(3, 25,self.aframe.size.width - 6, 52);
    self.descriptionView.backgroundColor = [UIColor whiteColor];
    self.descriptionView.layer.cornerRadius = 3;
    
    self.descriptionLabelTop.frame = CGRectMake(0, 4, self.aframe.size.width - 10, 22);
    self.descriptionLabelTop.font = [UIFont systemFontOfSize:14.0f];
    self.descriptionLabelTop.numberOfLines = 2;
    self.descriptionLabelTop.text = self.descriptionStringTop;
    self.descriptionLabelTop.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.descriptionLabelTop.textAlignment = NSTextAlignmentCenter;
    
    
    self.descriptionLabelBottom.frame = CGRectMake(0, 25, self.aframe.size.width - 10, 27);
    self.descriptionLabelBottom.font = [UIFont systemFontOfSize:14.0f];
    self.descriptionLabelBottom.numberOfLines = 2;
    self.descriptionLabelBottom.text = self.descriptionStringBottom;
    self.descriptionLabelBottom.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.descriptionLabelBottom.textAlignment = NSTextAlignmentCenter;

    
}
@end


