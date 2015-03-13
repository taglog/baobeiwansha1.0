//
//  ProfilePageCollectionTableViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/9.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "ProfilePageCollectionTableViewCell.h"
@interface ProfilePageCollectionTableViewCell ()

//postID
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,retain)UIImageView *image;

//标题
@property (nonatomic,retain) UILabel *title;

@property (nonatomic,retain) UILabel *typeLabel;

//摘要
@property (nonatomic,retain) UILabel *introduction;

//传入的frame
@property (nonatomic,assign) CGRect aframe;

@property (nonatomic,retain) NSDictionary *dict;


@end
@implementation ProfilePageCollectionTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initViews];
    }
    return self;
}

-(void)initViews{
    if(!self.image){
        self.image = [[UIImageView alloc]init];
        [self.contentView addSubview:self.image];
    }
    if(!self.title){
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
    }
    if(!self.typeLabel){
        self.typeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.typeLabel];
    }
    if(!self.introduction){
        self.introduction = [[UILabel alloc]init];
        [self.contentView addSubview:self.introduction];
    }
 
    
}

-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.dict = dict;
    self.aframe = frame;
    
    self.image.image = [UIImage imageNamed:@"boy.jpg"];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"自己穿衣带帽，鼓励宝宝自己动手有益自身发展"];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [@"自己穿衣带帽，鼓励宝宝自己动手有益自身发展" length])];
    [self.title setAttributedText:attributedString1];
    self.introduction.text = @"孩子的潜力和天分要由父母来开发，那么";
    [self setNeedsLayout];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.aframe.size.height - 0.5f, self.aframe.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [self.contentView.layer addSublayer:bottomBorder];
    
    CGFloat paddingRight = 15.0f;
    CGFloat paddingLeft = 15.0f;
    CGFloat paddingTop = 25.0f;
    
    self.image.frame = CGRectMake(paddingLeft, paddingTop, 60, 60);
    self.image.layer.cornerRadius = 4;
    self.image.layer.masksToBounds = YES;
    self.image.layer.borderWidth = 1.0f;
    self.image.layer.borderColor = [UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:222.0/255.0f alpha:1.0f].CGColor;
    
    self.title.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft, paddingTop - 7, self.aframe.size.width - self.image.frame.size.width - 2*paddingLeft - paddingRight - 35, 45);
    self.title.numberOfLines = 2;
    self.title.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    self.title.textColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    
    self.typeLabel.text = @"玩具";
    self.typeLabel.frame = CGRectMake(self.aframe.size.width - 45,paddingTop, 30, 16.0f);
    self.typeLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:198.0/255.0f blue:236.0/255.0f alpha:1.0f];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.layer.cornerRadius = 3;
    self.typeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.typeLabel.layer.masksToBounds = YES;
    
    self.introduction.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft, paddingTop + self.title.frame.size.height, self.aframe.size.width - self.image.frame.size.width - 2*paddingLeft - paddingRight, 15);
    self.introduction.font = [UIFont systemFontOfSize:14.0f];
    self.introduction.textColor = [UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1.0f];
    
    
}

@end