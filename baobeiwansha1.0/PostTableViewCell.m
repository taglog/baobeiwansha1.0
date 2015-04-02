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

//@property (nonatomic,retain) UIImageView *collectionIcon;
@property (nonatomic,retain) UIButton *collectionButton;
@property (nonatomic,retain) UIImageView *collectionButtonImage;

@property (nonatomic,retain) CALayer *bottomBorder;
//传入的frame
@property (nonatomic,assign) CGRect aframe;

@property (nonatomic,retain) NSMutableDictionary *dict;
@property (nonatomic,retain) NSIndexPath *indexPath;
@property (nonatomic,retain) UILabel *tagLabel1;
@property (nonatomic,retain) UILabel *tagLabel2;
@property (nonatomic,retain) UILabel *tagLabel3;

@property (nonatomic,retain) NSString *tag1;
@property (nonatomic,retain) NSString *tag2;
@property (nonatomic,retain) NSString *tag3;


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

    if(!self.collectionButton){
        //self.collectionButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        self.collectionButton = [[UIButton alloc] init];
        [self.contentView addSubview:self.collectionButton];
                                 
    }
    if(!self.collectionButtonImage){
        self.collectionButtonImage = [[UIImageView alloc]init];
        [self.collectionButton addSubview:self.collectionButtonImage];
    }
    if(!self.bottomBorder){
        self.bottomBorder = [CALayer layer];
        [self.contentView.layer addSublayer:self.bottomBorder];
    }
}

-(void)setDataWithDict:(NSDictionary *)dict frame:(CGRect)frame indexPath:(NSIndexPath *)indexPath{
    
    self.dict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    self.aframe = frame;
    self.indexPath = indexPath;
    
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
    
    if([dict objectForKey:@"isCollection"] != (id)[NSNull null]){
        
        if([[self.dict objectForKey:@"isCollection"] integerValue] == 0){
            self.collectionButtonImage.image = [UIImage imageNamed:@"unstar"];
        }else{
            self.collectionButtonImage.image = [UIImage imageNamed:@"star"];

        }
    }
    
    
    
    NSArray *tagArray = [dict objectForKey:@"tags"];

    if(tagArray != (id)[NSNull null]){
        NSInteger count = [tagArray count];

        if(count > 0){
            self.tagLabel1.text = [tagArray objectAtIndex:0];
        }
        if(count > 1){
            self.tagLabel2.text = [tagArray objectAtIndex:1];
        }
        if(count>2){
            self.tagLabel3.text = [tagArray objectAtIndex:2];

        }
        
    }
    
    
    [self setNeedsLayout];
    
}

-(void)updateCollectionCount:(NSInteger)collectionNumber type:(NSInteger)type{
    
    self.collectionNumber.text = [NSString stringWithFormat:@"%ld", (long)collectionNumber];
    NSLog(@"%ld",(long)type);
    if(type == 0){
    //取消收藏
        [self.dict setObject:[NSNumber numberWithInteger:0] forKey:@"isCollection"];
        
        self.collectionButtonImage.image = [UIImage imageNamed:@"unstar"];
 
    }else{
        
        [self.dict setObject:[NSNumber numberWithInteger:1] forKey:@"isCollection"];

        self.collectionButtonImage.image = [UIImage imageNamed:@"star"];

    }
    [self setNeedsLayout];
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    

    self.bottomBorder.frame = CGRectMake(0.0f, 119.5f, self.aframe.size.width, 0.5f);
    self.bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    
    CGFloat paddingRight = 15.0f;
    CGFloat paddingLeft = 15.0f;
    CGFloat paddingTop = (NARROW_SCREEN)? 15.0f : 20.0f;
    
    //CGFloat paddingBottom = 20.0f;
    
    CGFloat imageSize = (NARROW_SCREEN)? 60.0f : 80.0f;
    //CGFloat maxCellHeight = imageSize + paddingTop + paddingBottom;
    
    self.image.frame = CGRectMake(paddingLeft, paddingTop, imageSize, imageSize);
    self.image.layer.cornerRadius = 3;
    self.image.layer.masksToBounds = YES;
    self.image.layer.borderWidth = 1.0f;
    self.image.layer.borderColor = [UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:222.0/255.0f alpha:1.0f].CGColor;
    self.image.contentMode = UIViewContentModeScaleAspectFit;

    
    self.title.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft, paddingTop, self.aframe.size.width - self.image.frame.size.width - 2*paddingLeft - paddingRight - 35, 999);
    
    self.title.numberOfLines = 0;
    self.title.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];

    if([self.dict objectForKey:@"isCellTapped"]&&[[self.dict objectForKey:@"isCellTapped"]integerValue]==1){
        self.title.textColor = [UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1.0f];
        
    }else{
        self.title.textColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];

    }
    [self.title sizeToFit];
    
    
    self.typeLabel.frame = CGRectMake(self.aframe.size.width - 45,paddingTop, 30, 16.0f);
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.layer.cornerRadius = 3;
    self.typeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.typeLabel.layer.masksToBounds = YES;
    
    int numberOfLinesOfIntro = 2;
    float introHeight = numberOfLinesOfIntro * 16;
    if (self.title.frame.size.height > 15) {
        numberOfLinesOfIntro = 1;
        introHeight = 12;
    }
    //NSLog(@"numeber of line of introduction is %d", numberOfLinesOfIntro);
    self.introduction.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft, paddingTop + self.title.frame.size.height + 10, self.aframe.size.width - self.image.frame.size.width - 2*paddingLeft - paddingRight, introHeight);
    
    self.introduction.numberOfLines = numberOfLinesOfIntro;
    self.introduction.font = [UIFont systemFontOfSize:12.0f];
    self.introduction.textColor = [UIColor colorWithRed:143.0f/255.0f green:143.0f/255.0f blue:143.0f/255.0f alpha:1.0f];
    //[self.introduction sizeToFit];
    
    
    //此处区分宽屏和窄屏进行展示，对于宽屏 tag直接展示在图片右侧，对于窄屏，需要另起一行进行展示
    
    if (NARROW_SCREEN) {
//        
//        self.tagLabel1.frame = CGRectMake(
//                                          paddingLeft,
//                                          paddingTop + self.image.frame.size.height + 10 ,
//                                          50, 20);
        
        if([self.tagLabel1.text length]>0){
            self.tagLabel1.frame = CGRectMake(
                                              paddingLeft,
                                              paddingTop + self.image.frame.size.height + 10 ,
                                              [self.tagLabel1.text length] * 14.0f,
                                              20);
            
        }
//        
//        self.tagLabel2.frame = CGRectMake(
//                                          paddingLeft + self.tagLabel1.frame.size.width + 5,
//                                          paddingTop + self.image.frame.size.height + 10 ,
//                                          50, 20);
        
        if([self.tagLabel2.text length]>0){
            self.tagLabel2.frame = CGRectMake(
                                              paddingLeft + self.tagLabel1.frame.size.width + 5,
                                              paddingTop + self.image.frame.size.height + 10 ,                                              [self.tagLabel2.text length] * 14.0f,
                                              20);
        }
        
        
//        self.tagLabel3.frame = CGRectMake(
//                                          paddingLeft + self.tagLabel1.frame.size.width + self.tagLabel2.frame.size.width + 10,
//                                          paddingTop + self.image.frame.size.height + 10 ,
//                                          50, 20);
        
        if([self.tagLabel3.text length] > 0){
            self.tagLabel3.frame = CGRectMake(
                                              paddingLeft + self.tagLabel1.frame.size.width+ self.tagLabel2.frame.size.width + 10,
                                              paddingTop + self.image.frame.size.height + 10 ,
                                              [self.tagLabel3.text length] * 14.0f,
                                              20
                                              );
        }

    } else {
    
//        self.tagLabel1.frame = CGRectMake(self.image.frame.size.width + 2*paddingLeft,
//                                          paddingTop + self.title.frame.size.height +self.introduction.frame.size.height + 20,
//                                          0,
//                                          0);

        if([self.tagLabel1.text length]>0){
            self.tagLabel1.frame = CGRectMake(
                                              self.image.frame.size.width + 2*paddingLeft,
                                              paddingTop + self.title.frame.size.height +self.introduction.frame.size.height + 20,
                                              [self.tagLabel1.text length] * 14.0f,
                                              20);
            
        }
//        
//        self.tagLabel2.frame = CGRectMake(
//                                          self.image.frame.size.width + 2*paddingLeft + self.tagLabel1.frame.size.width + 5,
//                                          paddingTop + self.title.frame.size.height +self.introduction.frame.size.height + 20,
//                                          0,
//                                          0);
        
        if([self.tagLabel2.text length]>0){
            self.tagLabel2.frame = CGRectMake(
                                              self.image.frame.size.width + 2*paddingLeft + self.tagLabel1.frame.size.width + 5,
                                              paddingTop + self.title.frame.size.height +self.introduction.frame.size.height + 20,
                                              [self.tagLabel2.text length] * 14.0f,
                                              20);
        }
        
//        
//        self.tagLabel3.frame = CGRectMake(
//                                          self.image.frame.size.width + 2*paddingLeft + self.tagLabel1.frame.size.width+ self.tagLabel2.frame.size.width + 10,
//                                          paddingTop + self.title.frame.size.height + self.introduction.frame.size.height + 20,
//                                          0,
//                                          0);
        
        if([self.tagLabel3.text length] > 0){
            self.tagLabel3.frame = CGRectMake(
                                              self.image.frame.size.width + 2*paddingLeft + self.tagLabel1.frame.size.width+ self.tagLabel2.frame.size.width + 10,
                                              paddingTop + self.title.frame.size.height + self.introduction.frame.size.height + 20,
                                              [self.tagLabel3.text length] * 14.0f,
                                              20
                                              );
        }
        
        
    
    }
    
    self.tagLabel1.layer.borderWidth  = 0.5f;
    self.tagLabel1.layer.borderColor  = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f].CGColor;
    
    self.tagLabel1.textColor = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f];
    self.tagLabel1.textAlignment = NSTextAlignmentCenter;
    self.tagLabel1.layer.cornerRadius = 2;
    self.tagLabel1.font = [UIFont systemFontOfSize:12.0f];
    self.tagLabel1.layer.masksToBounds = YES;

    self.tagLabel2.layer.borderWidth  = 0.5f;
    self.tagLabel2.layer.borderColor  = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f].CGColor;
    //self.tagLabel2.backgroundColor = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f];
    self.tagLabel2.textColor = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f];
    self.tagLabel2.textAlignment = NSTextAlignmentCenter;
    self.tagLabel2.layer.cornerRadius = 2;
    self.tagLabel2.font = [UIFont systemFontOfSize:12.0f];
    self.tagLabel2.layer.masksToBounds = YES;
    
    self.tagLabel3.layer.borderWidth  = 0.5f;
    self.tagLabel3.layer.borderColor  = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f].CGColor;
    //self.tagLabel3.backgroundColor = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f];
    self.tagLabel3.textColor = [UIColor colorWithRed:212.0/255.0f green:202.0/255.0f blue:189.0/255.0f alpha:1.0f];
    self.tagLabel3.textAlignment = NSTextAlignmentCenter;
    self.tagLabel3.layer.cornerRadius = 2;
    self.tagLabel3.font = [UIFont systemFontOfSize:12.0f];
    self.tagLabel3.layer.masksToBounds = YES;
    
    

    
    self.collectionNumber.frame = CGRectMake(self.aframe.size.width - 122, paddingTop + self.image.frame.size.height, 80, 20);

    
    self.collectionButton.frame = CGRectMake(self.aframe.size.width - 40,
                                    paddingTop + self.title.frame.size.height + self.introduction.frame.size.height ,
                                    50, 50);
    self.collectionButtonImage.frame = CGRectMake(5, 22, 18, 18);
    [self.collectionButton addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //self.collectionIcon.frame = CGRectMake(self.aframe.size.w idth - 40,
    //                                       paddingTop + self.title.frame.size.height + self.introduction.frame.size.height + 20,
    //                                       18, 18);
    
    self.collectionNumber.frame = CGRectMake(self.aframe.size.width - 122,
                                             paddingTop + self.title.frame.size.height + self.introduction.frame.size.height + 20,
                                             80, 20);
    self.collectionNumber.font = [UIFont fontWithName:@"Thonburi" size:15.0f];
    self.collectionNumber.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    self.collectionNumber.textAlignment = NSTextAlignmentRight;
    
    
}


- (void)collectionBtnClick:(UIButton *)collectionBtn {
    NSLog(@"collection Btn is clicked");
    [self.delegate collectPost:self.indexPath];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    // Configure the view for the selected state
    
}
@end
