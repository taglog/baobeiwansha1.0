//
//  PostTableViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "PostTableViewCell.h"
@interface PostTableViewCell ()

@property (nonatomic,retain)UIImageView *image;

//标题
@property (nonatomic,retain) UILabel *title;

//摘要
@property (nonatomic,retain) UILabel *introduction;

//适合年龄
@property (nonatomic,retain) UILabel *age;

//收藏人数
@property (nonatomic,retain) UILabel *collectionNumber;
@property (nonatomic,retain) UIImageView *collectionIcon;

//传入的frame
@property (nonatomic,assign)CGRect aframe;

@property (nonatomic,retain)NSDictionary *dict;

@end
@implementation PostTableViewCell

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
    if(!self.introduction){
        self.introduction = [[UILabel alloc]init];
        [self.contentView addSubview:self.introduction];
    }
    if(!self.age){
        self.age = [[UILabel alloc]init];
        [self.contentView addSubview:self.age];
    }
    if(!self.collectionNumber){
        self.collectionNumber = [[UILabel alloc]init];
        [self.contentView addSubview:self.collectionNumber];
    }
    if(!self.collectionIcon){
        self.collectionIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:self.collectionIcon];
    }
    
}

-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.dict = dict;
    self.aframe = frame;
    
    self.title.text = @"自己穿衣戴帽，鼓励宝宝自己动手有益自身发展";
    self.image.image = [UIImage imageNamed:@"boy.jpg"];
    self.introduction.text = @"孩子的潜力和天分由父母来开发，那么";
    self.age.text = @"适合：22个月~3岁2个月";
    self.collectionNumber.text = @"14";
    self.collectionIcon.image = [UIImage imageNamed:@"heart"];
    
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat paddingRight = 15.0f;
    CGFloat paddingLeft = 15.0f;
    CGFloat paddingTop = 15.0f;
    CGFloat paddingBottom = 15.0f;
    
    self.image.frame = CGRectMake(paddingLeft, paddingTop, 60, 60);
    self.image.layer.cornerRadius = 3;
    self.image.layer.masksToBounds = YES;
    
    self.title.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft, 10, self.aframe.size.width - self.image.frame.size.width - 2*paddingLeft - paddingRight, 45);
    self.title.numberOfLines = 2;
    self.title.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f];
    self.title.textColor = [UIColor colorWithRed:23.0f/255.0f green:23.0f/255.0f blue:23.0f/255.0f alpha:1.0f];
    
    self.introduction.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft, paddingTop + self.title.frame.size.height, self.aframe.size.width - self.image.frame.size.width - 2*paddingLeft - paddingRight, 15);
    self.introduction.font = [UIFont systemFontOfSize:13.0f];
    self.introduction.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];

    self.age.frame = CGRectMake(paddingLeft, paddingTop + self.image.frame.size.height +paddingBottom, self.aframe.size.width - 100,20);
    self.age.font = [UIFont systemFontOfSize:13.0f];
    self.age.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];

    self.collectionIcon.frame = CGRectMake(self.aframe.size.width - 35, paddingTop + self.image.frame.size.height + 15, 20, 20);
    
    self.collectionNumber.frame = CGRectMake(self.aframe.size.width - 122, paddingTop + self.image.frame.size.height + paddingBottom, 80, 20);
    self.collectionNumber.font = [UIFont fontWithName:@"Thonburi" size:15.0f];
    self.collectionNumber.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.collectionNumber.textAlignment = NSTextAlignmentRight;
    
    
}
@end
