//
//  HomePagePostViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/23.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "HomePagePostViewController.h"
#import "AppDelegate.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"

@interface HomePagePostViewController ()

@property (nonatomic,retain) PostTextView *textView;
@property (nonatomic,assign) CGSize textViewSize;

@property (nonatomic,retain) AppDelegate *appDelegate;

@property (nonatomic,strong) NSDictionary *postDict;

@property (nonatomic,retain) JGProgressHUD *HUD;
@property (nonatomic,retain) UIScrollView *scrollView;

@property (nonatomic,retain) UIButton *canButton;
@property (nonatomic,retain) UIButton *cantButton;

@property (nonatomic,retain) UIButton *nextPostButton;
@property (nonatomic,retain) UILabel *nextPostTitleLabel;


@end
@implementation HomePagePostViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [self defaultSettings];
}

-(void)defaultSettings{
    self.view.backgroundColor = [UIColor whiteColor];

    [self initLeftBarButton];

}
-(void)initLeftBarButton{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initViewWithDict:(NSDictionary *)dict{
    self.postDict = dict;
    
    [self initViews];

}

-(void)initViews{
    
    [self initScrollView];
    [self initBottomButton];

}


-(void)initScrollView{
    if(!self.scrollView){
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
        
        [self.view addSubview:self.scrollView];
    }
    
    [self initTextView];
    
}

-(void)initTextView{
    
    self.textView = [[PostTextView alloc]initWithDict:self.postDict frame:self.view.frame];
    self.textView.delegate = self;
    self.textViewSize = [self.textView getTextViewHeight];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.textViewSize.height + 60);
    
    [self.scrollView addSubview:self.textView];
    //[self initChoiceButtons];

}

-(void)initChoiceButtons{
    
    if(!self.canButton){
        self.canButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 85, self.textViewSize.height + 10, 70, 35)];
        [self.canButton setBackgroundImage:[UIImage imageNamed:@"skill_select_able"] forState:UIControlStateNormal];
        [self.canButton setBackgroundImage:[UIImage imageNamed:@"skill_able"] forState:UIControlStateSelected];

        [self.scrollView addSubview:self.canButton];
    }
    
    if(!self.cantButton){
        self.cantButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 + 15, self.textViewSize.height + 10, 70, 35)];
        [self.cantButton setBackgroundImage:[UIImage imageNamed:@"skill_select_unable"] forState:UIControlStateNormal];
        [self.cantButton setBackgroundImage:[UIImage imageNamed:@"skill_unable"] forState:UIControlStateSelected];
        [self.scrollView addSubview:self.cantButton];
    }
    
    
}

-(void)initBottomButton{
    
    self.nextPostButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    
    [self.nextPostButton addTarget:self action:@selector(nextPost) forControlEvents:UIControlEventTouchUpInside];
    [self.nextPostButton setBackgroundColor:[UIColor colorWithRed:249.0/255.0f green:248.0/255.0f blue:244.0/255.0f alpha:1.0f]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width, 50)];
    label.text = @"点击进入下一篇";
    label.textColor = [UIColor colorWithRed:185.0/255.0f green:185.0/255.0f blue:185.0/255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentLeft;
    [self.nextPostButton addSubview:label];
    
    
    self.nextPostTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 15, 50)];
    self.nextPostTitleLabel.text = @"五岁三个月-数学启蒙";
    self.nextPostTitleLabel.textColor = [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1.0f];
    self.nextPostTitleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f];
    self.nextPostTitleLabel.textAlignment = NSTextAlignmentRight;
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, self.view.frame.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f].CGColor;
    [self.nextPostButton.layer addSublayer:topBorder];
    
    
    
    
    [self.nextPostButton addSubview:self.nextPostTitleLabel];
    
    
    
    [self.view addSubview:self.nextPostButton];
    
    
    
}

//每加载好一张图片，文章页面大小会变化
-(void)relayoutPostTextView:(CGSize)textSize{
    

    
    
}

-(void)nextPost{
    
    
    
    
    
    
    
}


-(void)noDataAlert{
    
    UILabel *noDataAlert = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height-64)/2, self.view.frame.size.width, 40.0f)];
    noDataAlert.text = @"暂时没有内容哦~";
    noDataAlert.textAlignment = NSTextAlignmentCenter;
    noDataAlert.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    noDataAlert.textAlignment = NSTextAlignmentCenter;
    noDataAlert.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:noDataAlert];
    
}
-(void)showHUD{
    //显示hud层
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = @"正在加载";
    [self.HUD showInView:self.view];
}

-(void)dismissHUD{
    [self.HUD dismiss];
}
@end
