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
@property (nonatomic,retain) UILabel *descriptionLabel;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *descriptionString;
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
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:76.0/255.0f blue:162.0/255.0f alpha:1.0f];
    
    self.titleLabel = [[UILabel alloc]init];
    self.descriptionView = [[UIView alloc]init];
    self.descriptionLabel = [[UILabel alloc]init];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview: self.descriptionView];
    [self.descriptionView addSubview:self.descriptionLabel];
    
}

-(void)setDict:(NSDictionary *)dict{
    
    self.title = [dict valueForKey:@"tag_name"];
    self.descriptionString = [dict valueForKey:@"tag_description"];
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = 5;
    
    self.titleLabel.frame = CGRectMake(0, 5,self.aframe.size.width, 20);
    self.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f];
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.descriptionView.frame = CGRectMake(5, 30,self.aframe.size.width - 10, 50);
    self.descriptionView.backgroundColor = [UIColor whiteColor];
    self.descriptionView.layer.cornerRadius = 3;
    
    self.descriptionLabel.frame = CGRectMake(12, 0, 70, 50);
    self.descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
    self.descriptionLabel.numberOfLines = 2;
    self.descriptionLabel.text = self.descriptionString;
    self.descriptionLabel.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    
}
@end


