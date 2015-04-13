//
//  ProfilePageCollectionTableViewCell.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/9.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "ProfilePageCollectionTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfilePageCollectionTableViewCell ()

@property (nonatomic,assign) NSInteger type;

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
    
    NSString *title = [dict valueForKey:@"post_title"];

    if(title != (id)[NSNull null]){

        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:title];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [title length])];
        [self.title setAttributedText:attributedString1];
    }
    
    
    NSString *introduction = [dict valueForKey:@"post_excerpt"];
    if(introduction != (id)[NSNull null]){
        self.introduction.text = introduction;
    }
    if([dict objectForKey:@"post_taxonomy"]){
        self.type = [[dict objectForKey:@"post_taxonomy"]integerValue];
        NSLog(@"%ld",(long)[[dict objectForKey:@"post_taxonomy"]integerValue]);
        if(self.type == 1){
            self.typeLabel.text = @"绘本";
            self.typeLabel.backgroundColor = [UIColor colorWithRed:201.0/255.0f green:56.0/255.0f blue:149.0/255.0f alpha:1.0f];            
        }else if(self.type == 2){
            self.typeLabel.text = @"玩具";
            self.typeLabel.backgroundColor = [UIColor colorWithRed:184.0/255.0f green:220.0/255.0f blue:90.0/255.0f alpha:1.0f];
            
        }else if(self.type == 3){
            self.typeLabel.text = @"游戏";
            self.typeLabel.backgroundColor = [UIColor colorWithRed:124.0/255.0f green:195.0/255.0f blue:231.0/255.0f alpha:1.0f];
            
        }else if(self.type == 190){
            self.typeLabel.text = @"建议";
            self.typeLabel.backgroundColor = [UIColor colorWithRed:124.0/255.0f green:195.0/255.0f blue:231.0/255.0f alpha:1.0f];
            
            
        }
        
    }
    
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
    self.image.contentMode = UIViewContentModeScaleAspectFit;
    
    self.title.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft, paddingTop - 7, self.aframe.size.width - self.image.frame.size.width - 2*paddingLeft - paddingRight - 35, 45);
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
    self.introduction.font = [UIFont systemFontOfSize:14.0f];
    self.introduction.textColor = [UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1.0f];
    
    
}

@end
