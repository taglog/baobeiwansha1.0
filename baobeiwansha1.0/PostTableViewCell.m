//
//  PostTableViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/2.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "PostTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PostTableViewCell ()
@property (nonatomic,assign) NSInteger type;
//postID
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,retain) UIImageView *image;

//标题
@property (nonatomic,retain) UILabel *title;

@property (nonatomic,retain) UILabel *typeLabel;

//摘要
@property (nonatomic,retain) UILabel *introduction;

//收藏人数
@property (nonatomic,retain) UILabel *collectionNumber;

@property (nonatomic,retain) UIImageView *collectionIcon;

//传入的frame
@property (nonatomic,assign) CGRect aframe;

@property (nonatomic,retain) NSDictionary *dict;

@property (nonatomic,retain) UILabel *tagLabel1;
@property (nonatomic,retain) UILabel *tagLabel2;
@property (nonatomic,retain) UILabel *tagLabel3;

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
    if(!self.typeLabel){
        self.typeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.typeLabel];
    }
    if(!self.introduction){
        self.introduction = [[UILabel alloc]init];
        [self.contentView addSubview:self.introduction];
    }
    if(!self.tagLabel1){
        self.tagLabel1 = [[UILabel alloc]init];
        [self.contentView addSubview:self.tagLabel1];
    }
    if(!self.tagLabel2){
        self.tagLabel2 = [[UILabel alloc]init];
        [self.contentView addSubview:self.tagLabel2];
    }
    if(!self.tagLabel3){
        self.tagLabel3 = [[UILabel alloc]init];
        [self.contentView addSubview:self.tagLabel3];
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

-(void)setDataWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.dict = dict;
    self.aframe = frame;
    
    if([dict valueForKey:@"ID"] != (id)[NSNull null]){
        self.ID = [[dict valueForKey:@"ID"] integerValue];
    }
    
    
    NSString *imagePathOnServer = @"http://blog.yhb360.com/wp-content/uploads/";
    NSString *imageGetFromServer = [dict valueForKey:@"post_cover"];
    
    //没有设置特色图像的话会报错，所以需要检测是否为空
    if(imageGetFromServer != (id)[NSNull null]){
        NSString *imageString = [imagePathOnServer stringByAppendingString:imageGetFromServer];
        NSURL *imageUrl = [NSURL URLWithString:[imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.image setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"loadingbackground.png"]];
        
    }else{
        //没有特色图像的时候，怎么办
        [self.image setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"loadingbackground.png"]];
        
    }
    if([dict objectForKey:@"post_title"] != (id)[NSNull null]){
        NSString *titletext = [dict objectForKey:@"post_title"];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:titletext];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titletext length])];
        [self.title setAttributedText: attributedString];

    }
    if([dict objectForKey:@"post_excerpt"] != (id)[NSNull null]){
        self.introduction.text = [dict objectForKey:@"post_excerpt"];
        
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.introduction.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:3];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.introduction.text length])];
        [self.introduction setAttributedText:attributedString1];
    }
    if([dict objectForKey:@"collection_count"]){
        self.collectionNumber.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"collection_count"]];
    }
    
    self.collectionIcon.image = [UIImage imageNamed:@"heart"];
    self.type = 1;
    if(self.type == 1){
        self.typeLabel.text = @"绘本";
        self.typeLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:198.0/255.0f blue:236.0/255.0f alpha:1.0f];

    }else if(self.type == 2){
        self.typeLabel.text = @"玩具";
        self.typeLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:198.0/255.0f blue:236.0/255.0f alpha:1.0f];

    }else if(self.type == 3){
        self.typeLabel.text = @"游戏";
        self.typeLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:198.0/255.0f blue:236.0/255.0f alpha:1.0f];


    }
    
    self.tagLabel1.text = @"创造力";
    self.tagLabel2.text = @"发育";
    self.tagLabel3.text = @"创造力";

    [self setNeedsLayout];
    
}

-(void)updateCollectionCount:(NSInteger)collectionNumber{
    
    self.collectionNumber.text = [NSString stringWithFormat:@"%ld", (long)collectionNumber];
    
    [self setNeedsLayout];
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, 139.5f, self.aframe.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [self.contentView.layer addSublayer:bottomBorder];
    
    CGFloat paddingRight = 15.0f;
    CGFloat paddingLeft = 15.0f;
    CGFloat paddingTop = 25.0f;
    CGFloat paddingBottom = 15.0f;
    
    self.image.frame = CGRectMake(paddingLeft, paddingTop, 60, 60);
    self.image.layer.cornerRadius = 3;
    self.image.layer.masksToBounds = YES;
    self.image.layer.borderWidth = 1.0f;
    self.image.layer.borderColor = [UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:222.0/255.0f alpha:1.0f].CGColor;
    
    self.title.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft, paddingTop - 14, self.aframe.size.width - self.image.frame.size.width - 2*paddingLeft - paddingRight - 35, 45);
    self.title.numberOfLines = 2;
    self.title.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    self.title.textColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    
    self.typeLabel.frame = CGRectMake(self.aframe.size.width - 45,paddingTop, 30, 16.0f);
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.layer.cornerRadius = 3;
    self.typeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.typeLabel.layer.masksToBounds = YES;
    
    self.introduction.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft, paddingTop + self.title.frame.size.height, self.aframe.size.width - self.image.frame.size.width - 2*paddingLeft - paddingRight, 15);
    self.introduction.font = [UIFont systemFontOfSize:12.0f];
    self.introduction.textColor = [UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1.0f];

    self.tagLabel1.frame = CGRectMake(paddingLeft, paddingTop + self.image.frame.size.height +paddingBottom + 3, 50, 20);
    self.tagLabel1.backgroundColor = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f];
    self.tagLabel1.textColor = [UIColor whiteColor];
    self.tagLabel1.textAlignment = NSTextAlignmentCenter;
    self.tagLabel1.layer.cornerRadius = 2;
    self.tagLabel1.font = [UIFont systemFontOfSize:12.0f];
    self.tagLabel1.layer.masksToBounds = YES;
    
    self.tagLabel2.frame = CGRectMake(paddingLeft + self.tagLabel1.frame.size.width + 10, paddingTop + self.image.frame.size.height  +paddingBottom + 3, 40, 20);
    self.tagLabel2.backgroundColor = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f];
    self.tagLabel2.textColor = [UIColor whiteColor];
    self.tagLabel2.textAlignment = NSTextAlignmentCenter;
    self.tagLabel2.layer.cornerRadius = 2;
    self.tagLabel2.font = [UIFont systemFontOfSize:12.0f];
    self.tagLabel2.layer.masksToBounds = YES;
    
    self.tagLabel3.frame = CGRectMake(paddingLeft + self.tagLabel1.frame.size.width+ self.tagLabel2.frame.size.width + 20, paddingTop + self.image.frame.size.height +paddingBottom + 3, 50, 20);
    self.tagLabel3.backgroundColor = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f];
    self.tagLabel3.textColor = [UIColor whiteColor];
    self.tagLabel3.textAlignment = NSTextAlignmentCenter;
    self.tagLabel3.layer.cornerRadius = 2;
    self.tagLabel3.font = [UIFont systemFontOfSize:12.0f];
    self.tagLabel3.layer.masksToBounds = YES;
    
    
    self.collectionIcon.frame = CGRectMake(self.aframe.size.width - 40, paddingTop + self.image.frame.size.height + 15, 18, 18);
    
    self.collectionNumber.frame = CGRectMake(self.aframe.size.width - 122, paddingTop + self.image.frame.size.height + paddingBottom, 80, 20);
    self.collectionNumber.font = [UIFont fontWithName:@"Thonburi" size:15.0f];
    self.collectionNumber.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.collectionNumber.textAlignment = NSTextAlignmentRight;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    // Configure the view for the selected state
    
}
@end
