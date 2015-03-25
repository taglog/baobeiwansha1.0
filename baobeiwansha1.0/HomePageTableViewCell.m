//
//  HomePageTableViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/25.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface HomePageTableViewCell ()

@property (nonatomic,retain) UIImageView *iconView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,assign) CGRect aframe;
@property (nonatomic,retain) NSDictionary *dict;
@property (nonatomic,assign) NSInteger ID;

@end

@implementation HomePageTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initViews];
        
    }
    return self;
    
}

-(void)initViews{
    
    self.titleLabel = [[UILabel alloc]init];
    self.iconView = [[UIImageView alloc]init];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconView];
    
}

-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.aframe = frame;
    self.dict = dict;
    
    if([dict valueForKey:@"ID"] != (id)[NSNull null]){
        self.ID = [[dict valueForKey:@"ID"] integerValue];
    }
    
    
    NSString *imagePathOnServer = @"http://blog.yhb360.com/wp-content/uploads/";
    NSString *imageGetFromServer = [dict valueForKey:@"post_cover"];
    
    //没有设置特色图像的话会报错，所以需要检测是否为空
    if(imageGetFromServer != (id)[NSNull null] && imageGetFromServer != nil){
        NSString *imageString = [imagePathOnServer stringByAppendingString:imageGetFromServer];
        NSURL *imageUrl = [NSURL URLWithString:[imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.iconView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"loadingbackground.png"]];
        
    }else{
        //没有特色图像的时候，怎么办
        [self.iconView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"loadingbackground.png"]];
        
    }
    
    if([dict valueForKey:@"post_title"] != (id)[NSNull null]){
        self.titleLabel.text = [dict valueForKey:@"post_title"];
    }
    
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.iconView.frame = CGRectMake(15, 10, 40, 40);
    self.iconView.layer.borderWidth = 1.0f;
    self.iconView.layer.borderColor = [UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:222.0/255.0f alpha:1.0f].CGColor;
    self.iconView.layer.cornerRadius = 3;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;

    self.titleLabel.frame = CGRectMake(65, 0, self.aframe.size.width - 80, 60);
    self.titleLabel.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
}

@end
