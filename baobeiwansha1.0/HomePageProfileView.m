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
        self.babyName.text = [NSString stringWithFormat:@"%@|",[dict objectForKey:@"nickName"]];
    }
    if([dict objectForKey:@"babyMonthString"]){
        self.babyAge.text = [dict objectForKey:@"babyMonthString"];

    }
    if([dict objectForKey:@"days_message"]!= (id)[NSNull null]){
        self.babyConditionTextView.text = [dict objectForKey:@"days_message"];

    }
    
    if([dict objectForKey:@"days_message"] != (id)[NSNull null]){
        
        self.babyConditionTextView.text = [dict objectForKey:@"days_message"];
    
        
        
    }
    
    if([[dict objectForKey:@"isHeadImageSet"] boolValue] == YES) {
        UIImage *image = [UIImage imageWithData:[dict valueForKey:@"headImage"]];
        [self.headImageButton setBackgroundImage:image forState:UIControlStateNormal];
    } else {
        if ([[dict objectForKey:@"babyGender"] integerValue] == 0) {
            [self.headImageButton setBackgroundImage:[UIImage imageNamed:@"girlhead.png"] forState:UIControlStateNormal];
        } else if ([[dict objectForKey:@"babyGender"] integerValue] == 1) {
            [self.headImageButton setBackgroundImage:[UIImage imageNamed:@"boyhead.png"] forState:UIControlStateNormal];
        } else {
            [self.headImageButton setBackgroundImage:[UIImage imageNamed:@"defaultSettingHeadImage.png"] forState:UIControlStateNormal];
        }
    }
    
    if ([[dict objectForKey:@"babyGender"] integerValue] == 0 ) {
        self.genderIcon.image = [UIImage imageNamed:@"gender_girl.png"];
    } else {
        self.genderIcon.image = [UIImage imageNamed:@"gender_boy.png"];
    }
    
    [self setNeedsLayout];
}


-(void)layoutSubviews{
    [super layoutSubviews];

    float profileViewInitialHeight = 150;
    
    
    float headImageSize = 60;
    float headImageOffsetX = 40;
    float headImageOffsetY = 64;
    
    float babyNameOffsetX = 115;
    float babyNameOffsetY = 90;
    float babyNameSizeWidth = 9999;
    float babyNameSizeHeight = 16;
    float babyNameFontSize = 16;
    
    float genderIconOffsetX = 120; // to babyName Rect
    float genderIconOffsetY = 94;
    
    float babyAgeOffsetX = 135;
    float babyAgeOffsetY = 90;
    float babyAgeSizeWidth = 9999;
    float babyAgeSizeHeight = 15;
    float babyAgeFontSize = 15;
    
    
    float babyConditionOffsetX = 10;
    float babyConditionOffsetY = 140;
    
    float upArrowOffsetX = 50;
    float upArrowOffsetY = -10;
    float upArrowSizeW = 20;
    float upArrowSizeH = 10;
    
    float babyConditionTextFontSize = 14;
    
    
    
    if (NARROW_SCREEN) {
        profileViewInitialHeight = 120;
        
        headImageSize = 56;
        headImageOffsetX = 32;
        headImageOffsetY = 48;
        
        babyNameOffsetX = 100;
        babyNameOffsetY = 80;
        babyNameSizeHeight = 15;
        babyNameFontSize = 15;
        
        genderIconOffsetX = 105; // to babyName Rect
        genderIconOffsetY = 84;
        
        babyAgeOffsetX = 120;
        babyAgeOffsetY = 80;
        babyAgeSizeHeight = 14;
        babyAgeFontSize = 14;
        
        
        babyConditionOffsetX = 10;
        babyConditionOffsetY = 110;
        
        upArrowOffsetX = 40;
        upArrowOffsetY = -8;
        upArrowSizeW = 16;
        upArrowSizeH = 8;
        
        babyConditionTextFontSize = 13;
    }
    
    
    
    self.headImageButton.frame = CGRectMake(headImageOffsetX, headImageOffsetY, headImageSize, headImageSize);
    //[self.headImageButton setBackgroundImage:[UIImage imageNamed:@"defaultSettingHeadImage.png"] forState:UIControlStateNormal];
    self.headImageButton.layer.masksToBounds = YES;
    self.headImageButton.layer.cornerRadius = headImageSize/2;
    self.headImageButton.layer.borderWidth = 3;
    self.headImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    self.babyName.frame = CGRectMake(babyNameOffsetX, babyNameOffsetY, babyNameSizeWidth, babyNameSizeHeight);
    self.babyName.numberOfLines = 1;
    self.babyName.textColor = [UIColor whiteColor];
    self.babyName.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:babyNameFontSize];
    [self.babyName sizeToFit];
    //NSLog(@"baby name lenght is %f", self.babyName.frame.size.width);
    
    self.genderIcon.frame = CGRectMake(self.babyName.frame.size.width + genderIconOffsetX, genderIconOffsetY, 10, 10);
    //self.genderIcon.backgroundColor = [UIColor redColor];

    self.babyAge.frame = CGRectMake(self.babyName.frame.size.width + babyAgeOffsetX, babyAgeOffsetY, babyAgeSizeWidth, babyAgeSizeHeight);
    self.babyAge.numberOfLines = 1;
    self.babyAge.textColor = [UIColor whiteColor];
    self.babyAge.font = [UIFont systemFontOfSize:babyAgeFontSize];
    [self.babyAge sizeToFit];
    
    
    

    
    
    self.babyConditionTextView.frame = CGRectMake(8, 2, self.aframe.size.width-30, 9999);
    self.babyConditionTextView.textColor = [UIColor colorWithRed:103.0/255.0f green:103.0/255.0f blue:103.0/255.0f alpha:1.0f];
    //self.babyConditionTextView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.babyConditionTextView.layer.cornerRadius = 8;
    self.babyConditionTextView.font = [UIFont systemFontOfSize:babyConditionTextFontSize];
    self.babyConditionTextView.scrollEnabled = NO;
    self.babyConditionTextView.editable = NO;
    [self.babyConditionTextView sizeToFit];
    NSLog(@"conditionTextView height is %f", self.babyConditionTextView.frame.size.height);
    
    
    self.babyCondition.frame = CGRectMake(babyConditionOffsetX, babyConditionOffsetY, self.aframe.size.width - 20, self.babyConditionTextView.frame.size.height + 2);
    self.babyCondition.backgroundColor = [UIColor whiteColor];
    self.babyCondition.layer.cornerRadius = 8;
    
    UIImageView *upArrow = [[UIImageView alloc]initWithFrame:CGRectMake(upArrowOffsetX, upArrowOffsetY, upArrowSizeW, upArrowSizeH)];
    upArrow.image = [UIImage imageNamed:@"upArrow"];
    [self.babyCondition addSubview:upArrow];


    
    // 最终得到整个section的高度
    self.frame = CGRectMake(0, 0, self.aframe.size.width, profileViewInitialHeight+self.babyConditionTextView.frame.size.height);
    
    self.backgroundView.frame = CGRectMake(0, 0, self.aframe.size.width, profileViewInitialHeight+self.babyConditionTextView.frame.size.height);
    self.backgroundView.image = [UIImage imageNamed:@"topbackground"];
    
    
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
