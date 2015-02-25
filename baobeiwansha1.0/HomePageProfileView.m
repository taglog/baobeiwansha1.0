//
//  HomePageProfileView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/2/24.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePageProfileView.h"

@interface HomePageProfileView ()
@property (nonatomic,retain) UIImageView *backgroundView;
@property (nonatomic,retain) UIButton *headImageButton;
@property (nonatomic,retain) UIImageView *genderIcon;
@property (nonatomic,retain) UILabel *babyName;
@property (nonatomic,retain) UILabel *babyAge;
@property (nonatomic,retain) UIView *babyCondition;
@property (nonatomic,retain) UITextView *babyConditionTextView;

@property (nonatomic,assign) CGRect aframe;

@end
@implementation HomePageProfileView

-(instancetype)init{
    self = [super init];
    
    if(self){
        [self initViews];
    }
    
    return self;
    
}
-(void)initViews{
    self.backgroundView = [[UIImageView alloc]init];
    self.headImageButton = [[UIButton alloc]init];
    self.genderIcon = [[UIImageView alloc]init];
    self.babyName = [[UILabel alloc]init];
    self.babyAge = [[UILabel alloc]init];
    self.babyCondition = [[UIView alloc]init];
    self.babyConditionTextView = [[UITextView alloc]init];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.headImageButton];
    [self addSubview:self.genderIcon];
    [self addSubview:self.babyName];
    [self addSubview:self.babyAge];
    [self addSubview:self.babyCondition];
    [self.babyCondition addSubview:self.babyConditionTextView];

    

}


-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.aframe = frame;
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.frame = CGRectMake(0, 0, self.aframe.size.width, 250);
    
    self.backgroundView.frame = CGRectMake(0, 0, self.aframe.size.width, 250);
    self.backgroundView.image = [UIImage imageNamed:@"topbackground"];
    
    self.headImageButton.frame = CGRectMake(40, 64, 60, 60);
    [self.headImageButton setBackgroundImage:[UIImage imageNamed:@"boy.jpg"] forState:UIControlStateNormal];
    self.headImageButton.layer.masksToBounds = YES;
    self.headImageButton.layer.cornerRadius = 30;
    self.headImageButton.layer.borderWidth = 3;
    self.headImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    self.babyName.frame = CGRectMake(115, 90, 100, 16);
    self.babyName.text = @"俞静仪  |";
    self.babyName.textColor = [UIColor whiteColor];
    self.babyName.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f];
    
    self.genderIcon.frame = CGRectMake(188, 94, 10, 10);
    self.genderIcon.backgroundColor = [UIColor redColor];

    self.babyAge.frame = CGRectMake(198, 91, 100, 15);
    self.babyAge.text = @"  2岁6个月";
    self.babyAge.textColor = [UIColor whiteColor];
    self.babyAge.font = [UIFont systemFontOfSize:15.0f];
    
    self.babyCondition.frame = CGRectMake(15, 140, self.aframe.size.width - 40, 90)
    ;
    self.babyCondition.backgroundColor = [UIColor whiteColor];
    self.babyCondition.layer.cornerRadius = 8;
    
    UIImageView *upArrow = [[UIImageView alloc]initWithFrame:CGRectMake(40, -10, 20, 10)];
    upArrow.image = [UIImage imageNamed:@"upArrow"];
    [self.babyCondition addSubview:upArrow];
    
    self.babyConditionTextView.frame = CGRectMake(8, 5, self.babyCondition.frame.size.width - 10,self.babyCondition.frame.size.height - 10);
    self.babyConditionTextView.font = [UIFont systemFontOfSize:14.0f];
    self.babyConditionTextView.scrollEnabled = NO;
    self.babyConditionTextView.text = @"好奇又好动，孩子太调皮，新买来的漂亮花瓶，他拿榜头敲出声音，西去哦汽车开不动了，他把汽车拆的七零八落，听见外面声音嘈杂，他马上跑出去看热闹。他把汽车拆的啊"
    ;
    self.babyConditionTextView.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    
    
}

@end
