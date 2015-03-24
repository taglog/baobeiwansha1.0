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
-(UIColor *)getColor{
    
    static int index = 0;
    
    UIColor *lightBlueColor = [UIColor colorWithRed:33.0/255.0 green:196.0/255.0 blue:229.0/255.0 alpha:1.0];
    UIColor *purpleColor = [UIColor colorWithRed:191.0/255.0 green:104.0/255.0 blue:174.0/255.0 alpha:1.0];
    UIColor *roseColor = [UIColor colorWithRed:248.0/255.0 green:55.0/255.0 blue:122.0/255.0 alpha:1.0];
    UIColor *yellowColor = [UIColor colorWithRed:249.0/255.0 green:197.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor *blueColor = [UIColor colorWithRed:38.0/255.0 green:171.0/255.0 blue:227.0/255.0 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:132.0/255.0 green:209.0/255.0 blue:53.0/255.0 alpha:1.0];
    UIColor *darkBlueColor = [UIColor colorWithRed:138.0/255.0 green:151.0/255.0 blue:210.0/255.0 alpha:1.0];
    UIColor *lightBlueColor2 = [UIColor colorWithRed:33.0/255.0 green:196.0/255.0 blue:229.0/255.0 alpha:1.0];
    UIColor *deepOrangeColor = [UIColor colorWithRed:255.0/255.0 green:87.0/255.0 blue:34.0/255.0 alpha:1.0];
    UIColor *orangeColor = [UIColor colorWithRed:255.0/255.0 green:130.0/255.0 blue:90.0/255.0 alpha:1.0];
    UIColor *greenColor2 = [UIColor colorWithRed:133.0/255.0 green:209.0/255.0 blue:49.0/255.0 alpha:1.0];
    UIColor *purpleColor2 = [UIColor colorWithRed:193.0/255.0 green:107.0/255.0 blue:174.0/255.0 alpha:1.0];
    
    NSArray *colorBox = [NSArray arrayWithObjects:lightBlueColor,purpleColor,roseColor,yellowColor,blueColor,greenColor,darkBlueColor,lightBlueColor2,deepOrangeColor,orangeColor,greenColor2,purpleColor2,nil];
    
    UIColor *color = colorBox[index%12];
    
    index++;
    
    return color;
}

-(void)layoutSubviews{
    [super layoutSubviews];
        
    self.iconView.frame = CGRectMake((self.aframe.size.width-60)/2.0f,10,60,60);
    self.iconView.backgroundColor = [self getColor];
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
