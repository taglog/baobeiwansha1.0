//
//  TagPageCollectionViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "TagPageCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TagPageCollectionViewCell ()

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSString *tag;
@property (nonatomic,retain) UIImageView *icon;
@property (nonatomic,assign) CGRect aframe;

@end
@implementation TagPageCollectionViewCell

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
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.iconView addSubview:self.icon];
    
    
}

-(void)setDict:(NSDictionary *)dict{
    
    if([dict valueForKey:@"name"]){
        self.tag = [dict valueForKey:@"name"];
    }
    
    if([dict valueForKey:@"tag_imgurl"]!= (id)[NSNull null]&&[dict valueForKey:@"tag_imgurl"]){
        NSString *imgUrlString = [NSString stringWithFormat:@"http://61.174.9.214/www/imgs/tagicon/%@.png",[dict valueForKey:@"tag_imgurl"]];
        NSURL *imgUrl = [NSURL URLWithString:[imgUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.icon setImageWithURL:imgUrl placeholderImage:nil];
        
    }
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
        
    self.iconView.frame = CGRectMake((self.aframe.size.width-60)/2.0f,10,60,60);
    self.iconView.layer.cornerRadius = 30;
    self.iconView.layer.masksToBounds = YES;
    
    self.icon.frame = CGRectMake(12, 12, 36, 36);
    
    self.titleLabel.frame = CGRectMake(0, 78, self.aframe.size.width, 20);
    self.titleLabel.text = self.tag;
    self.titleLabel.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
}



@end
