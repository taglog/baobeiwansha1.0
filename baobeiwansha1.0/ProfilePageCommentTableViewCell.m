//
//  ProfilePageCommentTableViewCell.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/9.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "ProfilePageCommentTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfilePageCommentTableViewCell ()
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,retain) UIImageView *image;
@property (nonatomic,retain) UILabel *title;
@property (nonatomic,retain) UILabel *commentLabel;
@property (nonatomic,retain) UILabel *commentContentLabel;
@property (nonatomic,retain) NSDictionary *dict;
@property (nonatomic,assign) CGRect aframe;
@property (nonatomic,retain) UILabel *typeLabel;

@end
@implementation ProfilePageCommentTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initViews];
    }
    return self;
}
-(void)initViews{
    
    if(!self.image) {
        self.image = [[UIImageView alloc]init];
        [self.contentView addSubview:self.image];
    }
    if(!self.title){
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
    }
    if(!self.commentLabel){
        self.commentLabel = [[UILabel alloc]init];
        self.commentLabel.text = @"我的评论";
        [self.contentView addSubview:self.commentLabel];
    }
    if(!self.commentContentLabel){
        self.commentContentLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.commentContentLabel];
    }
    if(!self.typeLabel){
        self.typeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.typeLabel];
    }
    
}
-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.aframe = frame;
    self.dict = dict;
    
    
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
        [paragraphStyle1 setLineSpacing:8];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [title length])];
        [self.title setAttributedText:attributedString1];
        
    }
    
    NSString *comment = [dict valueForKey:@"comment_content"];
    if(comment != (id)[NSNull null]){
        
        NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:comment];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:5];
        [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [comment length])];
        [self.commentContentLabel setAttributedText:attributedString2];
    }
    if([dict objectForKey:@"post_taxonomy"]){
        self.type = [[dict objectForKey:@"post_taxonomy"]integerValue];
        if(self.type == 1){
            self.typeLabel.text = @"绘本";
            self.typeLabel.backgroundColor = [UIColor colorWithRed:201.0/255.0f green:56.0/255.0f blue:149.0/255.0f alpha:1.0f];
            
        }else if(self.type == 2){
            self.typeLabel.text = @"玩具";
            self.typeLabel.backgroundColor = [UIColor colorWithRed:184.0/255.0f green:220.0/255.0f blue:90.0/255.0f alpha:1.0f];
            
        }else if(self.type == 3){
            self.typeLabel.text = @"游戏";
            self.typeLabel.backgroundColor = [UIColor colorWithRed:124.0/255.0f green:195.0/255.0f blue:231.0/255.0f alpha:1.0f];
            
            
        }
        
    }

    [self setNeedsLayout];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.image.frame = CGRectMake(15, 15, 40, 40);
    self.image.layer.cornerRadius = 4;
    self.image.layer.masksToBounds = YES;
    
    self.title.frame = CGRectMake(65, 15, self.aframe.size.width - 80, 40);
    self.title.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    self.title.numberOfLines = 2;
    self.title.textColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    
    self.typeLabel.frame = CGRectMake(self.aframe.size.width - 45,15, 30, 16.0f);
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.layer.cornerRadius = 3;
    self.typeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.typeLabel.layer.masksToBounds = YES;
    
    self.commentLabel.frame = CGRectMake(15, 70, 50,17);
    self.commentLabel.layer.cornerRadius = 4;
    self.commentLabel.backgroundColor = [UIColor colorWithRed:247.0/255.0f green:247.0/255.0f blue:247.0/255.0f alpha:1.0f];
    self.commentLabel.font = [UIFont systemFontOfSize:10.0f];
    self.commentLabel.textColor = [UIColor colorWithRed:140.0/255.0f green:140.0/255.0f blue:140.0/255.0f alpha:1.0f];
    self.commentLabel.textAlignment = NSTextAlignmentCenter;

    self.commentContentLabel.frame = CGRectMake(15, 95, self.aframe.size.width - 30, 40);
    
    self.commentContentLabel.numberOfLines = 2;
    self.commentContentLabel.font = [UIFont systemFontOfSize:12.0f];
    self.commentContentLabel.textColor = [UIColor colorWithRed:140.0/255.0f green:140.0/255.0f blue:140.0/255.0f alpha:1.0f];
    
}

@end
