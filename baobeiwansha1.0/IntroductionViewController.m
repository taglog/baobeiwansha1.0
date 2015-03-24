//
//  IntroductionViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/21.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "IntroductionViewController.h"
#import "IntroPageViewController.h"

@interface IntroductionViewController ()
@property (nonatomic,retain) IntroViewController *introViewController;
@property (nonatomic,retain) IntroPageViewController *introPageViewController1;
@property (nonatomic,retain) IntroPageViewController *introPageViewController2;
@property (nonatomic,retain) UIViewController *introPageViewController3;

@property (nonatomic,assign) CGFloat paddingX;
@property (nonatomic,assign) CGFloat paddingY;
@end
@implementation IntroductionViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];
    
}
-(void)initViews{
    
    self.paddingX = (self.view.frame.size.width - 220.0)/2.0;
    self.paddingY = (self.view.frame.size.height - 220.0)/2.0;
    
    [self initIntroPageViewController1];
    [self initIntroPageViewController2];
    [self initIntroPageViewController3];
    
    [self initIntroView];
    
}

-(void)initIntroPageViewController1{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, self.view.frame.size.width, 60.0f)];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:40.0f];
    titleLabel.text = @"玩 啥?";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX, self.paddingY , 220, 220)];
    imageView1.image = [UIImage imageNamed:@"1_bg_bool"];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX - 10,  self.paddingY - 30, 75, 55)];
    imageView2.image = [UIImage imageNamed:@"1_book_label"];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX - 30,  self.paddingY - 5 , 130, 100)];
    imageView3.image = [UIImage imageNamed:@"1_book_abc"];
    
    
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 165,  self.paddingY + 170, 80, 80)];
    imageView4.image = [UIImage imageNamed:@"1_game_label"];
    
    UIImageView *imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 100,  self.paddingY + 105, 110, 110)];
    imageView5.image = [UIImage imageNamed:@"1_game_jigsaw"];
    
    UIImageView *imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX - 20,  self.paddingY + 183, 80, 65)];
    imageView6.image = [UIImage imageNamed:@"1_lab_label"];
    
    
    UIImageView *imageView7 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 15,  self.paddingY + 95, 65, 100)];
    imageView7.image = [UIImage imageNamed:@"1_lab_cup"];
    
    UIImageView *imageView8 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 120,  self.paddingY - 40, 65, 90)];
    imageView8.image = [UIImage imageNamed:@"1_toy_label"];
    
    UIImageView *imageView9 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 150,  self.paddingY , 85, 105)];
    imageView9.image = [UIImage imageNamed:@"1_toy_bear"];
    
    NSArray *views = [[NSArray alloc]initWithObjects:@{@"view":titleLabel,@"delay":@0},@{@"view":imageView1,@"delay":@0.2},@{@"view":imageView2,@"delay":@0.6},@{@"view":imageView3,@"delay":@0.6},@{@"view":imageView4,@"delay":@1.0},@{@"view":imageView5,@"delay":@1.0},@{@"view":imageView6,@"delay":@1.4},@{@"view":imageView7,@"delay":@1.4},@{@"view":imageView8,@"delay":@1.8},@{@"view":imageView9,@"delay":@1.8},nil];
    
    UIImage *image = [self imageWithColor:[UIColor colorWithRed:196.0/255.0f green:0.0/255.0f blue:245.0/255.0f alpha:1.0f] frame:self.view.frame];
    
    self.introPageViewController1 = [[IntroPageViewController alloc]initViews:views background:image];
    
}

-(void)initIntroPageViewController2{
    
    float offsetY = 25.0f;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, self.view.frame.size.width, 60.0f)];
    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:40.0f];
    titleLabel.text = @"培 养 啥?";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX, self.paddingY+offsetY , 220, 200)];
    imageView1.image = [UIImage imageNamed:@"2_bg_cube"];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX - 20,  self.paddingY+offsetY - 70, 90, 110)];
    imageView2.image = [UIImage imageNamed:@"2_curious_label"];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 30 , self.paddingY+offsetY + 10 , 65, 65)];
    imageView3.image = [UIImage imageNamed:@"2_curious_glass"];
    
    
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 85,  self.paddingY+offsetY + 125, 90, 100)];
    imageView4.image = [UIImage imageNamed:@"2_rule_label"];
    
    UIImageView *imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 80,  self.paddingY+offsetY + 70, 80, 95)];
    imageView5.image = [UIImage imageNamed:@"2_rule_ruler"];
    
    UIImageView *imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX - 50, self.paddingY+offsetY + 120, 80, 80)];
    imageView6.image = [UIImage imageNamed:@"2_focus_label"];
    
    
    UIImageView *imageView7 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX - 10, self.paddingY+offsetY + 75, 90, 90)];
    imageView7.image = [UIImage imageNamed:@"2_focus_blocks"];
    
    UIImageView *imageView8 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 180,  self.paddingY+offsetY + 110, 95, 95)];
    imageView8.image = [UIImage imageNamed:@"2_leadership_label"];
    
    UIImageView *imageView9 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 160, self.paddingY+offsetY + 50, 80, 70)];
    imageView9.image = [UIImage imageNamed:@"2_leadership_flag"];
    
    UIImageView *imageView10 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 120,  self.paddingY+offsetY - 60, 85, 110)];
    imageView10.image = [UIImage imageNamed:@"2_creative_label"];
    
    UIImageView *imageView11 = [[UIImageView alloc]initWithFrame:CGRectMake(self.paddingX + 115, self.paddingY +offsetY- 10 , 75, 75)];
    imageView11.image = [UIImage imageNamed:@"2_creative_bulb"];
    
    NSArray *views = [[NSArray alloc]initWithObjects:@{@"view":titleLabel,@"delay":@0},@{@"view":imageView1,@"delay":@0.2},@{@"view":imageView2,@"delay":@0.6},@{@"view":imageView3,@"delay":@0.6},@{@"view":imageView4,@"delay":@1.0},@{@"view":imageView5,@"delay":@1.0},@{@"view":imageView6,@"delay":@1.4},@{@"view":imageView7,@"delay":@1.4},@{@"view":imageView8,@"delay":@1.8},@{@"view":imageView9,@"delay":@1.8},@{@"view":imageView10,@"delay":@2.2},@{@"view":imageView11,@"delay":@2.2},nil];

    UIImage *image = [self imageWithColor:[UIColor colorWithRed:67.0/255.0f green:227.0/255.0f blue:117.0/255.0f alpha:1.0f] frame:self.view.frame];
    self.introPageViewController2 = [[IntroPageViewController alloc]initViews:views background:image];
    
}

-(void)initIntroPageViewController3{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height - 125, self.view.frame.size.width-60, (self.view.frame.size.width-60)*0.19)];
    [button setBackgroundImage:[UIImage imageNamed:@"3_btn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(introFinished) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*1.55)];
    imageView1.image = [UIImage imageNamed:@"3_bbws_all"];
    //imageView1.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:119/255.0f blue:119/255.0f alpha:1.0f];
    
    self.introPageViewController3 = [[UIViewController alloc]init];
    [self.introPageViewController3.view addSubview:imageView1];
    
    self.introPageViewController3.view.backgroundColor = [UIColor whiteColor];
    [self.introPageViewController3.view addSubview:button];
    
}

-(void)initIntroView{
    
    self.introViewController = [[IntroViewController alloc]init];
    self.introViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.introViewController.delegate = self;
    self.introViewController.dataSource = self;
    
    [self.introViewController renderViews];
    
    [self.view addSubview:self.introViewController.view];
    [self addChildViewController:self.introViewController];

}


-(NSUInteger)numberOfViewsForIntro:(IntroViewController *)introViewController{
    return 3;
}

-(UIViewController *)introView:(IntroViewController *)introViewController contentViewControllerForViewAtIndex:(NSUInteger)index{
    
    UIViewController *introPageViewController;
    
    switch (index) {
        case 0:
            introPageViewController = self.introPageViewController1;
            break;
        case 1:
            introPageViewController = self.introPageViewController2;
            break;
        case 2:
            introPageViewController = self.introPageViewController3;
            break;
        default:
            break;
    }
    
    return introPageViewController;
    
    
}
-(void)introView:(IntroViewController *)introViewController didChangeTabToIndex:(NSUInteger)index{
    
    switch (index) {
        case 0:
            [self.introPageViewController1 performAnimation];
            break;
        case 1:
            [self.introPageViewController2 performAnimation];
            break;
        case 2:
            break;
        default:
            break;
    }
    
}
-(void)introFinished{
    [self.delegate introViewFinished];
    
}
- (UIImage *)imageWithColor: (UIColor *) color frame:(CGRect)aFrame
{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, aFrame);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
