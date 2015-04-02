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
#import "JGProgressHUDErrorIndicatorView.h"

@interface HomePagePostViewController ()

@property (nonatomic,retain) PostView *postView;

@property (nonatomic,retain) AppDelegate *appDelegate;

@property (nonatomic,strong) NSDictionary *postDict;

@property (nonatomic,retain) JGProgressHUD *HUD;
@property (nonatomic,retain) UIScrollView *scrollView;

@property (nonatomic,retain) UIButton *canButton;
@property (nonatomic,retain) UIButton *cantButton;

@property (nonatomic,retain) UIButton *nextPostButton;
@property (nonatomic,retain) UIButton *prevPostButton;


@property (nonatomic) int pressCount; // 点击下一篇增加1，点击上一篇减少1

@end
@implementation HomePagePostViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.title = @"宝贝成长";
    self.pressCount = 0;
    [self defaultSettings];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 114)];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
        
        [self.view addSubview:self.scrollView];
    }
    
    [self initPostView];
    
}

-(void)initPostView{
    
    self.postView = [[PostView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) dict:self.postDict];
    self.postView.delegate = self;
    [self.scrollView addSubview:self.postView];

}

-(void)postWebViewDidFinishLoading:(CGFloat)height{
    [self dismissHUD];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,height);
    
}
-(void)updateTextView{
    [self.postView removeFromSuperview];
    // 测试用
    //NSMutableDictionary *testDict = [[NSMutableDictionary alloc]init];
    //[testDict setObject:@"test title" forKey:@"post_title"];
    //[testDict setObject:@"test content" forKey:@"post_content"];
    //self.postDict = testDict;
    [self initPostView];
    
}

-(void)initChoiceButtons{
    
    if(!self.canButton){
        self.canButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 85, 500 + 10, 70, 35)];
        [self.canButton setBackgroundImage:[UIImage imageNamed:@"skill_select_able"] forState:UIControlStateNormal];
        [self.canButton setBackgroundImage:[UIImage imageNamed:@"skill_able"] forState:UIControlStateSelected];

        [self.scrollView addSubview:self.canButton];
    }
    
    if(!self.cantButton){
        self.cantButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 + 15, 500 + 10, 70, 35)];
        [self.cantButton setBackgroundImage:[UIImage imageNamed:@"skill_select_unable"] forState:UIControlStateNormal];
        [self.cantButton setBackgroundImage:[UIImage imageNamed:@"skill_unable"] forState:UIControlStateSelected];
        [self.scrollView addSubview:self.cantButton];
    }
    
    
}

-(void)initBottomButton{
    
    self.prevPostButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width/2, 50)];
    
    [self.prevPostButton addTarget:self action:@selector(prevPost) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.prevPostButton setBackgroundImage:[UIImage imageNamed:@"searchbg"] forState:UIControlStateNormal];
    [self.prevPostButton setBackgroundImage:[UIImage imageNamed:@"pressedcolor"] forState:UIControlStateHighlighted];
    UILabel *labelp = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width/2, 50)];
    labelp.text = @"上一篇";
    labelp.textColor = [UIColor blackColor];
    labelp.font = [UIFont systemFontOfSize:15.0f];
    labelp.textAlignment = NSTextAlignmentLeft;
    [self.prevPostButton addSubview:labelp];
    
    
    self.nextPostButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height - 49, self.view.frame.size.width/2, 50)];
    
    [self.nextPostButton addTarget:self action:@selector(nextPost) forControlEvents:UIControlEventTouchUpInside];
    [self.nextPostButton setBackgroundImage:[UIImage imageNamed:@"searchbg"] forState:UIControlStateNormal];
    [self.nextPostButton setBackgroundImage:[UIImage imageNamed:@"pressedcolor"] forState:UIControlStateHighlighted];
    
    UILabel *labeln = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2-15, 50)];
    labeln.text = @"下一篇";
    labeln.textColor = [UIColor blackColor];
    labeln.font = [UIFont systemFontOfSize:15.0f];
    labeln.textAlignment = NSTextAlignmentRight;
    [self.nextPostButton addSubview:labeln];
    
    
    
    
    [self.view addSubview:self.prevPostButton];
    [self.view addSubview:self.nextPostButton];
    
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f].CGColor;
    [self.view.layer addSublayer:topBorder];
    
    
    
}

//每加载好一张图片，文章页面大小会变化
-(void)relayoutPostTextView:(CGSize)textSize{
    

    
    
}


-(void)getRemotePost{
    
    

    [self showHUD];
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInteger:self.originalDaysIndex],@"daysIndex",
                                  self.appDelegate.generatedUserID,@"userIdStr",
                                  [NSNumber numberWithInteger:self.pressCount], @"pressCount",
                                  nil];
    
    
    
    
    NSString *postRouter = @"dailyMessage/index";
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        if(responseDict != (id)[NSNull null]){
            
            self.postDict = responseDict;
            if (self.currentDaysIndex == [[responseDict valueForKey:@"days_index"] integerValue]) {
                // 同一天，说明已经到顶或者到底了，提示一下，并回复presscount
                if (self.pressCount > 0) {
                    self.pressCount --;
                } else {
                    self.pressCount ++;
                }
                self.HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
                self.HUD.textLabel.text = @"没有更多了";
                self.HUD.detailTextLabel.text = nil;
                //self.HUD.layoutChangeAnimationDuration = 0.4;
                
                [self.HUD dismissAfterDelay:1];
            } else {
                self.currentDaysIndex = [[responseDict valueForKey:@"days_index"] integerValue];
                [self updateTextView];
                [self dismissHUD];
            } 
            
        }else{
            
            NSMutableDictionary *errorDict = [[NSMutableDictionary alloc]init];
            [errorDict setObject:@"网络连接错误" forKey:@"post_title"];
            [errorDict setObject:@"无法从服务器端取得数据，请检查网络连接..." forKey:@"post_content"];
            self.postDict = errorDict;
            [self updateTextView];
            [self dismissHUD];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self dismissHUD];
    }];

}


-(void)nextPost{
    
    self.pressCount ++;
    [self getRemotePost];
    
}


-(void)prevPost{
    
    self.pressCount --;
    [self getRemotePost];

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
