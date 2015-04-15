//
//  PostView.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/30.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "PostView.h"
@interface PostView ()

@property (nonatomic,retain) NSDictionary *dict;
@property (nonatomic,retain) UIWebView *postWebView;

@end
@implementation PostView
-(id)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict{
    self = [super initWithFrame:frame];
    
    if(self){
        self.dict = dict;
    }
    return self;
    
}


-(void)initViews{
    
    //self.postWebView = [[UIWebView alloc]initWithFrame:self.frame];
    self.postWebView = [[UIWebView alloc]init];
    self.postWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    NSString *postTitle = [self.dict valueForKey:@"post_title"];
    NSString *postContent = [self.dict valueForKey:@"post_content"];
    NSString *htmlPostTitle = [NSString stringWithFormat:@"<div id =\"content\" style =\"margin:0 10px\"><h2 style='font-size:24px;color:#33333;margin:10px 0px'>%@</h2>",postTitle];
    NSString *htmlPostContent = [NSString stringWithFormat:@"%@%@</div>",htmlPostTitle,postContent];
    NSLog(@"%@",htmlPostContent);
    self.postWebView.delegate = self;
    self.postWebView.scrollView.scrollEnabled = NO;
    self.postWebView.autoresizesSubviews = YES;
    [self.postWebView loadHTMLString:htmlPostContent baseURL:nil];
    
    [self addSubview:self.postWebView];
    
    // estimate the height
    float estimateHeight = htmlPostContent.length*1.2;
    NSLog(@"UnderLoading: estimate height is %f", estimateHeight);
    self.postWebView.frame = CGRectMake(0, 0, self.frame.size.width, estimateHeight);
    [self.delegate postWebViewBeganLoading:(estimateHeight)];
  
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //CGFloat documentWidth = [[self.postWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
    CGFloat documentHeight = [[self.postWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
    //NSLog(@"documentWidth %f",documentWidth);
    NSLog(@"DidFinishLoad documentHeight %f",documentHeight);
    //CGSize mWebViewSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)];
    //CGRect mWebViewFrame = webView.frame;
    //mWebViewFrame.size.height = mWebViewSize.height+20;
    //self.postWebView.frame = mWebViewFrame;
    //NSLog(@"DidFinishLoad: height is %f", webView.frame.size.height);

    //加载完成后更新父view的frame
    if([self.delegate respondsToSelector:@selector(postWebViewDidFinishLoading:)]){
        self.postWebView.frame = CGRectMake(0, 0, self.frame.size.width, documentHeight+20);
        [self.delegate postWebViewDidFinishLoading:(documentHeight+20)];
    }
    
}

@end
