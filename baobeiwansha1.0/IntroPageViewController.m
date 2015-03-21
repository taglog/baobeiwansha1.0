//
//  IntroPageViewController.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/20.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "IntroPageViewController.h"
#import "IntroView.h"
@interface IntroPageViewController ()

@property (nonatomic,retain) IntroView *introView;
@property (nonatomic,retain) NSArray *views;
@property (nonatomic,retain) UIImage *backgroudImage;

@end
@implementation IntroPageViewController

-(id)initViews:(NSArray *)views background:(UIImage *)backgroundImage{
    
    self = [super init];
    if(self){
        self.views = [[NSArray alloc]initWithArray:views];
        self.backgroudImage = backgroundImage;
    }
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];


}

-(void)initViews{
    
    if(!self.introView){
    self.introView = [[IntroView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) customViews:self.views background:self.backgroudImage];

        [self.view addSubview:self.introView];
    }

}

-(void)performAnimation{
    
    [self.introView performAnimation];
    
}

@end
