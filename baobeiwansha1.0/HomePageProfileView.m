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
    
    if(!self.backgroundView){
        self.backgroundView = [[UIImageView alloc]init];
        self.backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushProfilePageSetting:)];
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self.backgroundView addGestureRecognizer:tapGestureRecognizer];
        [self addSubview:self.backgroundView];

    }
    if(!self.headImageButton){
        self.headImageButton = [[UIButton alloc]init];
        [self.headImageButton addTarget:self action:@selector(pushProfilePageSetting) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.headImageButton];

    }
    if(!self.genderIcon){
        self.genderIcon = [[UIImageView alloc]init];
        [self addSubview:self.genderIcon];

    }
    if(!self.babyName){
        self.babyName = [[UILabel alloc]init];
        [self addSubview:self.babyName];

    }
    if(!self.babyAge){
        self.babyAge = [[UILabel alloc]init];
        [self addSubview:self.babyAge];

    }
    if(!self.babyCondition){
        self.babyCondition = [[UIView alloc]init];
        [self addSubview:self.babyCondition];

    }
    if(!self.babyConditionTextView){
        self.babyConditionTextView = [[UITextView alloc]init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushBabyCondition:)];
        tapGesture.numberOfTouchesRequired = 1;
        [self.babyConditionTextView addGestureRecognizer:tapGesture];
        [self.babyCondition addSubview:self.babyConditionTextView];
    }
    
    

}


-(void)setDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self.aframe = frame;
    
    if([dict objectForKey:@"nickName"]){
        self.babyName.text = [NSString stringWithFormat:@"%@ | ",[dict objectForKey:@"nickName"]];
    }
    if([dict objectForKey:@"babyMonthString"]){
        self.babyAge.text = [dict objectForKey:@"babyMonthString"];

    }
    if([dict objectForKey:@"days_message"]!= (id)[NSNull null]){
        self.babyConditionTextView.text = [dict objectForKey:@"days_message"];

    }

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
    
    
    self.babyName.frame = CGRectMake(115, 90, 16 *[self.babyName.text length], 16);
    self.babyName.textColor = [UIColor whiteColor];
    self.babyName.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16.0f];
    
    self.genderIcon.frame = CGRectMake(self.babyName.frame.size.width + 55, 94, 10, 10);
    self.genderIcon.backgroundColor = [UIColor redColor];

    self.babyAge.frame = CGRectMake(self.babyName.frame.size.width + 70, 91, 100, 15);
    self.babyAge.textColor = [UIColor whiteColor];
    self.babyAge.font = [UIFont systemFontOfSize:15.0f];
    self.babyAge.textAlignment = NSTextAlignmentLeft;
    
    self.babyCondition.frame = CGRectMake(15, 140, self.aframe.size.width - 30, 90)
    ;
    self.babyCondition.backgroundColor = [UIColor whiteColor];
    self.babyCondition.layer.cornerRadius = 8;
    
    UIImageView *upArrow = [[UIImageView alloc]initWithFrame:CGRectMake(40, -10, 20, 10)];
    upArrow.image = [UIImage imageNamed:@"upArrow"];
    [self.babyCondition addSubview:upArrow];
    
    self.babyConditionTextView.frame = CGRectMake(8, 5, self.babyCondition.frame.size.width - 10,self.babyCondition.frame.size.height - 10);
    self.babyConditionTextView.font = [UIFont systemFontOfSize:14.0f];
    self.babyConditionTextView.scrollEnabled = NO;
    self.babyConditionTextView.editable = NO;
    
    self.babyConditionTextView.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    
    
}
-(void)pushProfilePageSetting{
    [self.delegate pushProfilePageSettingViewController];
}
-(void)pushBabyCondition:(UITapGestureRecognizer *)sender{
    [self.delegate pushBabyConditionViewController];
}
-(void)pushProfilePageSetting:(UITapGestureRecognizer *)sender{
    [self.delegate pushProfilePageSettingViewController];
}
@end
