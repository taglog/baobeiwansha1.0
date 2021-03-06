//
//  PostViewController.m
//  baobaowansha2
//
//  Created by 上海震渊信息技术有限公司 on 14/11/14.
//  Copyright (c) 2014年 上海震渊信息技术有限公司. All rights reserved.
//

#import "PostViewController.h"
#import "CommentTableViewCell.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"

#import "PostViewTimeAnalytics.h"
#import "UIImageView+AFNetworking.h"



@interface PostViewController ()
{
    CGFloat padding;
    CGRect _frame;
    
    
}
//scrollView里放入textView和评论的tableView
@property(nonatomic,retain) UIScrollView *postScrollView;
@property(nonatomic,retain) PostView *postView;
@property(nonatomic,strong) UIView *commentTableHeader;
@property(nonatomic,retain) UITableView *commentTableView;

@property(nonatomic,assign) CGFloat lastContentOffset;

//底部的bar
@property(nonatomic,retain)UIView *bottomBar;
@property(nonatomic,retain) UIButton *commentCreateButton;

//接收到的post数据
@property(nonatomic,strong) NSDictionary *postDict;

//把postTitle放入textView里面一起显示
@property(nonatomic,strong)NSString *postTitle;
@property(nonatomic,strong)NSString *postContent;
@property(nonatomic,strong)NSString *htmlPostContent;

//得到计算过后的textViewSize
@property(nonatomic,assign)CGFloat postViewHeight;

//评论的上拉刷新
@property (nonatomic,retain)EGORefreshView *refreshFooterView;

//用来更新tableViewCell的数组
@property (nonatomic,retain) NSMutableArray *commentTableViewCell;
@property (nonatomic,retain) NSIndexPath *commentTapIndexPath;

//是否reloading标志
@property (nonatomic,assign)BOOL reloading;

//postID
@property(nonatomic,assign)NSUInteger postID;
@property(nonatomic,retain)UIImageView *postCoverIV;

//收藏button
@property(nonatomic,retain)UIButton *collectionButton;
@property(nonatomic,retain)UIButton *collectionButtonSelected;

//增加一个bool值，防止在收藏还没有收到服务器返回值的时候，用户进行重复点击
@property(nonatomic,assign)BOOL collectButtonEnabled;

//没有评论的时候显示
@property(nonatomic,retain)UILabel *noCommentLabel;

@property (nonatomic,retain)AppDelegate *appDelegate;

@property (nonatomic,retain)JGProgressHUD *HUD;

@property (nonatomic,assign)NSInteger p;

@property (nonatomic,assign) CGFloat bottomBarHeight;
@property (nonatomic,assign) BOOL isScrollToBottom;

@end

@implementation PostViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self showHUD];
    self.isScrollToBottom = NO;
    [self initLeftBarButton];
    [self initRightBarButton];
    self.collectButtonEnabled = YES;
    //阻止自动调整滚轮位置，否则导航栏下会出现一段空间
    self.automaticallyAdjustsScrollViewInsets = NO;
    


}

-(void)initLeftBarButton{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

-(void)initRightBarButton{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareViewController)];

    rightBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}


// 17
-(NSString *)getEncodePostID:(NSInteger)postID{
    int x;
    int added = 0;
    NSString * rs = @"";
    for (int i=0; i<4; i++) {
        x = [self getRandomNumber:1000 to:9999];
        added += x;
        rs = [NSString stringWithFormat:@"%@%@",rs,[NSString stringWithFormat:@"%d",x]];
        NSLog(@"generate string: %@",rs);
    }
    added += postID;
    
    x = arc4random() % 10;
    rs = [NSString stringWithFormat:@"%@%@",rs,[NSString stringWithFormat:@"%d",x]];
    NSLog(@"generate string: %@",rs);
    
    rs = [NSString stringWithFormat:@"%@%@",rs,[NSString stringWithFormat:@"%ld",(long)postID]];
    NSLog(@"encoded  string: %@",rs);
    
    added = added % 10000;
    if (added < 1000) {
        added += 1000;
    }
    rs = [NSString stringWithFormat:@"%@%@",rs,[NSString stringWithFormat:@"%d",added]];
    NSLog(@"encoded  string: %@",rs);

    return rs;
}

//-(UIImage *) getImageFromURL:(NSString *)fileURL {
//    NSLog(@"get image from %@", fileURL);
//    UIImage * result;
//    
//    NSURL *imgUrl = [NSURL URLWithString:[fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSData * data = [NSData dataWithContentsOfURL:imgUrl];
//    result = [[UIImage alloc] initWithData:data];
//    NSLog(@"result is %@", data);
//    return result;
//}


-(void)getCoverImage{
    NSString *imagePathOnServer = @"http://blog.yhb360.com/wp-content/uploads/";
    NSString *imageGetFromServer = [self.postDict valueForKey:@"post_cover"];
    self.postCoverIV = [[UIImageView alloc]init];

    
    if(imageGetFromServer != (id)[NSNull null] && imageGetFromServer != nil){
        NSString *imageString = [imagePathOnServer stringByAppendingString:imageGetFromServer];
        NSURL *imageUrl = [NSURL URLWithString:[imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.postCoverIV setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"icon120.png"]];
    }else{
        //没有特色图像的时候，怎么办
        [self.postCoverIV setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"icon120.png"]];
        
    }


}


-(void)shareViewController{

    
    NSString *linkurl = [@"http://admin.yhb360.com/www/index.php/Home/WXCategory/pdenx.html?id=" stringByAppendingString:[self getEncodePostID:self.postID]];
    // 微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = linkurl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = [self.postDict objectForKey:@"post_title"];
    
    // 微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = linkurl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = [self.postDict objectForKey:@"post_title"];
    
    // 微信收藏
    [UMSocialData defaultData].extConfig.wechatFavoriteData.url = linkurl;
    [UMSocialData defaultData].extConfig.wechatFavoriteData.title = [self.postDict objectForKey:@"post_title"];
    
    // QQ分享
    [UMSocialData defaultData].extConfig.qqData.url = linkurl;
    [UMSocialData defaultData].extConfig.qqData.title = [self.postDict objectForKey:@"post_title"];

    
    // QQzone分享
    [UMSocialData defaultData].extConfig.qzoneData.url = linkurl;
    [UMSocialData defaultData].extConfig.qzoneData.title = [self.postDict objectForKey:@"post_title"];
    
    // renren 分享
    //[UMSocialData defaultData].extConfig.renrenData.url = linkurl;
    //[UMSocialData defaultData].extConfig.renrenData.appName = @"宝贝玩啥";
    
    // sina weibo
    //[[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.baidu.com/img/bdlogo.gif"];
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:@"1005055426082208"}];
    //[[UMSocialDataService defaultDataService] requestAddFollow:UMShareToSina followedUsid:@[@"1005055426082208"] completion:nil];
    
    // Email分享
    [UMSocialData defaultData].extConfig.emailData.title = [self.postDict objectForKey:@"post_title"];
    
    
    NSString *post_excerpt = @"";
    post_excerpt = [self.postDict objectForKey:@"post_excerpt"];
    NSLog(@"post excerpt %@", post_excerpt);
    if (post_excerpt.length == 0) {
        post_excerpt = @"宝贝玩啥:发现最有益的玩法";
    }
    
    UIImage *image = [[UIImage alloc] init];
    if (!self.postCoverIV) {
        image = [UIImage imageNamed:@"icon120.png"];
        //NSLog(@"icon 120");
    } else {
        image = self.postCoverIV.image;
        //NSLog(@"postCoverIV 's image");
    }
    
    
    

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:post_excerpt
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToDouban,UMShareToEmail]
                                       delegate:self];
    
    [UMSocialData defaultData].extConfig.emailData.shareText = [post_excerpt stringByAppendingString:@"</br><a href=\"https://itunes.apple.com/cn/app/id961562218\">下载连接: https://itunes.apple.com/cn/app/id961562218 </a>"];
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = [[self.postDict objectForKey:@"post_title"] stringByAppendingFormat:@"\n%@...\n 查看全文:%@",post_excerpt, linkurl];
    
    [UMSocialData defaultData].extConfig.doubanData.shareText = [[self.postDict objectForKey:@"post_title"] stringByAppendingFormat:@"\n%@...\n 查看全文:%@",post_excerpt, linkurl];

//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession]
//                                                        content:post_excerpt
//                                                          image:image
//                                                       location:nil
//                                                    urlResource:nil
//                                            presentedController:self
//                                                     completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
    
    
    
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PostView"];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PostView"];
    [PostViewTimeAnalytics endLogPageView:self.postID];

    
}

//初始化Controlller的View



-(void)initWithRequestURL:(NSString *) url requestParam:(NSDictionary *) requestParam {
    
    if (!self.appDelegate) {
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }

    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:url];

    
    NSString *urlString = [postRequestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url string is %@ and %@", url, postRequestUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:urlString parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        if(responseDict != (id)[NSNull null]){
            
            [self initViewWithDict:responseDict];
            
        }else{
            
            [self noDataAlert];
            
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@",error);
              [self showErrorHUD];
              //[self dismissHUD];
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }];


}





-(void)initViewWithDict:(NSDictionary *)dict{
    
    NSLog(@"init with dict %@", dict);
    
    self.p = 2;
    
    _postDict = dict;
    _postID = [[dict valueForKey:@"ID"]integerValue];
    _frame = self.view.frame;
    
    [PostViewTimeAnalytics beginLogPageView:self.postID];
    
    [self initPostView];
    
    [self getCoverImage];

}


-(void)initScrollView:(CGFloat)height{
    
    if(_postScrollView == nil){
        _postScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 64.0f)];
        _postScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
        _postScrollView.delegate = self;
        [self.view addSubview:_postScrollView];
        
    }
    [_postScrollView addSubview:self.postView];
    
}


//初始化textView
-(void)initPostView{
    
    self.postView = [[PostView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 3000) dict:self.postDict];
    self.postView.delegate = self;
    [self.postView initViews];
    
}


-(void)postWebViewBeganLoading:(CGFloat)height{
    [self dismissHUD];
    
    //初始化postScrollView
    //self.postView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    [self initScrollView:(CGFloat)height];
    
}

-(void)postWebViewDidFinishLoading:(CGFloat)height{
    // 更新高度 + 加入评论
    _postScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    
    self.postViewHeight = height;
    
    //初始化评论tableview
    [self initTableView];
    [self initCommentTableView];
    //初始化底部的bar
    [self initBottomBar];
    
    [self relayoutCommentTableView];
    
}




-(void)relayoutCommentTableView{
    
    CGFloat divHeigh = 40.0f;
    CGFloat refreshBarHeight = 49.5f;
    
    CGFloat commentTableHeight = [self getCommentTableViewHeight:self.commentTableViewCell];
    
    [_postScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.postViewHeight + commentTableHeight + refreshBarHeight + divHeigh)];
    
    [_commentTableView setFrame:CGRectMake(0, self.postViewHeight + divHeigh, self.view.frame.size.width, commentTableHeight)];
    
    [_refreshFooterView setFrame:CGRectMake(0, _postScrollView.contentSize.height - refreshBarHeight, self.view.frame.size.width, 50.0f)];
    
}
-(void)initBottomBar{
    
    self.bottomBarHeight = 50.0f;
    //初始化底部的bar
    if(!self.bottomBar){
        
        
        self.bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - self.bottomBarHeight, self.view.frame.size.width, self.bottomBarHeight)];
        self.bottomBar.backgroundColor = [UIColor whiteColor];
        
        //初始化底部的Button
        if(_commentCreateButton == nil){
            
            _commentCreateButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, self.bottomBarHeight)];
            _commentCreateButton.backgroundColor = [UIColor whiteColor];
            [_commentCreateButton addTarget:self action:@selector(showCommentCreateViewController) forControlEvents:UIControlEventTouchUpInside];
            _commentCreateButton.adjustsImageWhenHighlighted = NO;
            
            UILabel *commentCreateLabel = [[UILabel alloc]initWithFrame:CGRectMake(9.0f, 9.0f, self.view.frame.size.width - 60, self.bottomBarHeight-18)];
            commentCreateLabel.backgroundColor = [UIColor colorWithRed:230.0/255.0f green:225.0/255.0f blue:218.0/255.0f alpha:1.0f];
            commentCreateLabel.layer.cornerRadius = 5;
            commentCreateLabel.layer.masksToBounds = YES;
            
            UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(12.0f, 0.0f, self.view.frame.size.width - 60, self.bottomBarHeight-18)];
            commentLabel.text = @"输入内容";
            commentLabel.font = [UIFont systemFontOfSize:14.0f];
            
            commentLabel.textColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
            
            [commentCreateLabel addSubview:commentLabel];
            [_commentCreateButton addSubview:commentCreateLabel];
            
            [self.bottomBar addSubview:_commentCreateButton];
            
            CALayer *topBorder = [CALayer layer];
            
            topBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.5f);
            topBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                          alpha:1.0f].CGColor;
            [self.bottomBar.layer addSublayer:topBorder];
        }
        
        
        
        //初始化collectButton
        self.collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 60, 60)];
        UIImageView *collectionButtonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 24, 24)];
        collectionButtonImage.image = [UIImage imageNamed:@"unstar"];
        [self.collectionButton addSubview:collectionButtonImage];
        [self.collectionButton addTarget:self action:@selector(collectPost:) forControlEvents:UIControlEventTouchUpInside];
        self.collectionButton.tag = 0;
        
        
        self.collectionButtonSelected = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 60, 60)];
        UIImageView *collectionButtonSelectedImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 24, 24)];
        collectionButtonSelectedImage.image = [UIImage imageNamed:@"star"];
        [self.collectionButtonSelected addSubview:collectionButtonSelectedImage];
        [self.collectionButtonSelected addTarget:self action:@selector(collectPost:) forControlEvents:UIControlEventTouchUpInside];
        self.collectionButtonSelected.tag = 1;
        
        [self.bottomBar addSubview:self.collectionButton];
        [self.bottomBar addSubview:self.collectionButtonSelected];
        
        
        //是否已收藏该Post,设置收藏按钮的显示
        if([[_postDict valueForKey:@"isCollection"]integerValue] == 1){
            //已收藏
            self.collectionButton.hidden = YES;
            self.collectionButtonSelected.hidden = NO;
        }else{
            //未收藏
            self.collectionButton.hidden = NO;
            self.collectionButtonSelected.hidden = YES;
        }
        
        
        [self.view addSubview:self.bottomBar];
        
    }
    
}


-(CGFloat)getCommentTableViewHeight:(NSMutableArray *)commentTableViewCell{
    
    CGFloat height = 0;
    NSUInteger length = [commentTableViewCell count];
    for(int i = 0;i < length ; i++){
        height  += [CommentTableViewCell heightForCellWithDict:commentTableViewCell[i] frame:_frame];
    }
    return height;
    
}
-(IBAction)collectPost:(id)sender{
    
    if(self.collectButtonEnabled == YES){
        self.collectButtonEnabled = NO;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        
        UIButton *collectButtonSender =(UIButton *)sender;
        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        
        if(collectButtonSender.tag == 0){
            self.HUD.textLabel.text = @"正在收藏";
        }else{
            self.HUD.textLabel.text = @"正在取消";
        }
        
        [self.HUD showInView:self.view];
        
        //获取路径
        if (!self.appDelegate) {
            self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        }
        
        
        NSDictionary *collectParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.postID],@"postID", nil];
        
        NSString *collectRouter = @"/post/collect";
        NSString *collectRequestUrl = [self.appDelegate.rootURL stringByAppendingString:collectRouter];
        //进行收藏判断 userID,PostID
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer.timeoutInterval = 20;
        [manager POST:collectRequestUrl  parameters:collectParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
            NSInteger status = [[responseObject valueForKey:@"status"]integerValue];
            
            if(status == 1){
                
                if(collectButtonSender.tag == 0){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        self.collectionButton.hidden = YES;
                        self.collectionButtonSelected.hidden = NO;
                        
                    });
                    
                    self.HUD.textLabel.text = @"收藏成功";
                    [self.delegate updateCollectionCount:self.indexPath type:1];
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        self.collectionButton.hidden = NO;
                        self.collectionButtonSelected.hidden = YES;
                        
                    });
                    self.HUD.textLabel.text = @"取消成功";
                    [self.delegate updateCollectionCount:self.indexPath type:0];
                }
                self.HUD.layoutChangeAnimationDuration = 0.4;
                self.HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
                self.HUD.detailTextLabel.text = nil;
                [self.HUD dismissAfterDelay:1.0];
                self.collectButtonEnabled = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionChanged" object:nil];
                
                
            }else{
                //否则的话，弹出一个指示层
                self.HUD.textLabel.text = @"没有用户信息";
                self.HUD.detailTextLabel.text = nil;
                
                self.HUD.layoutChangeAnimationDuration = 0.4;
                self.HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.HUD dismiss];
                });
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@",error);
            
            self.HUD.textLabel.text = @"网络请求失败";
            self.HUD.detailTextLabel.text = nil;
            [self.HUD dismissAfterDelay:1.0];
            self.collectButtonEnabled = YES;
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
    }
    
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



//初始化评论栏
#pragma  mark 评论 tableView delegate
-(void)initCommentTableView{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    //初始化homeTableViewCell
    self.commentTableViewCell = [[NSMutableArray alloc]init];
    
    NSString *commentRouter = @"/comment/get";
    
    NSDictionary *postParam = [[NSDictionary alloc]initWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:1],@"p",[NSNumber numberWithInteger:self.postID],@"id",nil];
    NSString *commentRequestUrl = [self.appDelegate.rootURL stringByAppendingString:commentRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:commentRequestUrl parameters:postParam  success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        if(responseArray != (id)[NSNull null]){
            for(NSString *responseDict in responseArray){
                [self.commentTableViewCell addObject:responseDict];
            }
            [_commentTableView reloadData];
            [self relayoutCommentTableView];
            [_refreshFooterView removeFromSuperview];
            [self initRefreshView];
            
        }else{
            //没有评论的时候,显示一个label，说没有评论
            
            _commentTableView.hidden = YES;
            [self initNoCommentLabel];
            
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}


//初始化tableView
-(void)initTableView{
    
    
    //初始化tableView
    if(_commentTableView == nil){
        _commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.postViewHeight + 60, self.view.frame.size.width, 100.0)];
        
        _commentTableView.scrollEnabled = NO;
        
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        [_postScrollView addSubview:_commentTableView];
        [_commentTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    //初始化用户评论分隔栏
    if(_commentTableHeader == nil){
        _commentTableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, self.postViewHeight, self.view.frame.size.width, 40.0f)];
        _commentTableHeader.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0 alpha:1.0];
        UILabel *commentTableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.0f, 100.0f, 20.0f)];
        commentTableHeaderLabel.text = @"用户评论";
        commentTableHeaderLabel.textColor = [UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
        commentTableHeaderLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.commentTableHeader addSubview:commentTableHeaderLabel];
        
        [_postScrollView addSubview:_commentTableHeader];
    }
}

-(void)initNoCommentLabel{
    
    _noCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.postViewHeight + 100, self.view.frame.size.width, 20.0f)];
    _noCommentLabel.text = @"还没有人评论哦，快来第一个评论吧~";
    _noCommentLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    _noCommentLabel.textAlignment = NSTextAlignmentCenter;
    _noCommentLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [_postScrollView addSubview:_noCommentLabel];
    [_postScrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.postViewHeight+200)];
}


//初始化下拉刷新header
-(void)initRefreshView{
    
    _refreshFooterView = [[EGORefreshView alloc] initWithScrollView:_postScrollView position:EGORefreshFooter];
    _refreshFooterView.delegate = self;
    // ugly 此处会在comment加载后再次调用
    _refreshFooterView.frame = CGRectMake(0, _postScrollView.contentSize.height-50, self.view.frame.size.width, 50.0f);
    [_postScrollView addSubview:_refreshFooterView];
    
}


#pragma mark - commentTableView 委托实现

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentTableViewCell.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Comment";
    CommentTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell setDataWithDict:self.commentTableViewCell[indexPath.row] frame:_frame];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [CommentTableViewCell heightForCellWithDict:self.commentTableViewCell[indexPath.row] frame:self.view.frame];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.commentTapIndexPath = indexPath;
    
    if([[[self.commentTableViewCell objectAtIndex:indexPath.row]valueForKey:@"canDeleteComment"]integerValue]==1){
        
        UIActionSheet *deleteCommentSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                        delegate:self
                                                               cancelButtonTitle:@"取消"
                                                          destructiveButtonTitle:nil
                                                               otherButtonTitles:@"删除评论",  nil];
        
        [deleteCommentSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //删除评论
    if(buttonIndex == 0){
        
        NSInteger commentID = [[[self.commentTableViewCell objectAtIndex:self.commentTapIndexPath.row]valueForKey:@"comment_ID"]integerValue];
        
        [self.commentTableViewCell removeObjectAtIndex:self.commentTapIndexPath.row];
        [self.commentTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.commentTapIndexPath]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self relayoutCommentTableView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"commentDelete" object:nil];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        
        NSString *commentRouter = @"/comment/delete";
        
        
        NSDictionary *postParam = [[NSDictionary alloc]initWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:commentID],@"comment_ID",nil];
        
        NSString *commentRequestUrl = [self.appDelegate.rootURL stringByAppendingString:commentRouter];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer.timeoutInterval = 20;
        [manager POST:commentRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSArray *responseArray = [responseObject valueForKey:@"data"];
            
            if(responseArray != (id)[NSNull null]){
                
                
            }else{
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
    
}
#pragma mark 下拉数据刷新
- (void)reloadTableViewDataSource{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    //上拉刷新的数据处理
    if(_refreshFooterView.pullUp){
        
        NSString *commentRouter = @"/comment/get";
        
        NSDictionary *postParam = [[NSDictionary alloc]initWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.p],@"p",[NSNumber numberWithInteger:self.postID],@"id",nil];
        NSString *commentRequestUrl = [self.appDelegate.rootURL stringByAppendingString:commentRouter];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer.timeoutInterval = 20;
        [manager POST:commentRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSArray *responseArray = [responseObject valueForKey:@"data"];
            if(responseArray != (id)[NSNull null]){
                for(NSString *responseDict in responseArray){
                    [self.commentTableViewCell addObject:responseDict];
                }
                
                _reloading = YES;
                [_commentTableView reloadData];
                [self relayoutCommentTableView];
                
                
            }else{
                
                self.HUD.textLabel.text = @"没有评论了";
                self.HUD.indicatorView = nil;
                [self.HUD showInView:self.view];
                [self.HUD dismissAfterDelay:1.0f];
                
            }
            self.p++;
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            
            self.HUD.textLabel.text = @"网络请求失败~";
            [self.HUD showInView:self.view];
            [self.HUD dismissAfterDelay:1.0];
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }];
        
        
    }
}

- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.postScrollView];
    
}

#pragma mark - _postScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //没滚到底部之前
    if((scrollView.contentOffset.y + self.view.frame.size.height) <= (_postScrollView.contentSize.height)){
        
        self.isScrollToBottom = NO;
        
        scrollView.frame = CGRectMake(0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 64.0f);
        
        //向下拉
        if(self.lastContentOffset > (int)scrollView.contentOffset.y){
            
            [self.view bringSubviewToFront:self.bottomBar];
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomBar.frame = CGRectMake(0,self.view.frame.size.height - self.bottomBarHeight, self.view.frame.size.width, self.bottomBarHeight);
                //如果更改scrollView的frame，那么就会发生底部的抖动，这该怎么办
                //scrollView.frame = CGRectMake(0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 124.0f);
            }  completion:^(BOOL finished){
                
            }];
            
        }else{
            
            //向上拉
            [UIView animateWithDuration:0.3 animations:^{
                
                self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, self.bottomBarHeight);
                
            }  completion:^(BOOL finished){
                
            }];
            
            
        }
        
    }else{
        
        if(self.isScrollToBottom == NO){
            
            //scrollView.frame = CGRectMake(0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 114.0f);

            //如果到了底部，就始终显示
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomBar.frame = CGRectMake(0,self.view.frame.size.height - self.bottomBarHeight, self.view.frame.size.width, self.bottomBarHeight);
                
            }  completion:^(BOOL finished){
                self.isScrollToBottom = YES;
                
            }];
        }
    }
    
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshView *)view{
    
    [self reloadTableViewDataSource];
    
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshView *)view{
    
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshView *)view{
    
    return [NSDate date];
    
}
//创建评论的View
-(void)showCommentCreateViewController{
    
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    
    CommentCreateViewController *commentCreateView = [[CommentCreateViewController alloc]initWithID:self.postID];
    commentCreateView.delegate =self;
    
//    NSString *commentRouter = @"comment/getName";
//    NSString *commentRequestUrl = [self.appDelegate.rootURL stringByAppendingString:commentRouter];
//    NSDictionary *postParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr", nil];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:commentRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSArray *responseArray = [responseObject valueForKey:@"data"];
//        if(responseArray != (id)[NSNull null]&&responseArray != nil){
//            [commentCreateView addUserName:responseArray];
//        }
//        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
//    }];
    
    // 从本地获得用户名
    NSString *filePath = [AppDelegate dataFilePath];
    NSString *nickname = @"";
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        nickname = [dict valueForKey:@"nickName"];
    }else{
        NSLog(@"ERROR: create comment, but cannot find the user nickname!");
    }
    
    [commentCreateView addUserName:nickname];
    
    [self.navigationController pushViewController:commentCreateView animated:YES];
    
    
}



//创建评论成功的回调
-(void)commentCreateSuccess:(NSDictionary *)dict{
    
    if(_noCommentLabel){
        [_noCommentLabel removeFromSuperview];
        _commentTableView.hidden = NO;
    }
    
    [_commentTableView beginUpdates];
    [self.commentTableViewCell insertObject:dict atIndex:0];
    NSArray *commentAddRow = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_commentTableView insertRowsAtIndexPaths:commentAddRow withRowAnimation:UITableViewRowAnimationNone];
    [_commentTableView endUpdates];
    //NSLog(@"comment create success!");
    [self relayoutCommentTableView];
    [_postScrollView setContentOffset:CGPointMake(0, self.postViewHeight) animated:YES];
    
}

-(void)showHUD{
    //显示hud层
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    //self.HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    self.HUD.textLabel.text = @"正在加载";
    [self.HUD showInView:self.view];
}

-(void)dismissHUD{
    [self.HUD dismiss];
}

-(void)showErrorHUD{
    
    self.HUD.textLabel.text = @"网络连接失败，请重试一下吧~";
    self.HUD.detailTextLabel.text = nil;
    //self.HUD.layoutChangeAnimationDuration = 0.5;
    self.HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    [self.HUD dismissAfterDelay:3.0];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
