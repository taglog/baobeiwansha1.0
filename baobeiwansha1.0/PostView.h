//
//  PostView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/30.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PostViewDelegate <NSObject>

-(void)postWebViewDidFinishLoading:(CGFloat)height;

@end
@interface PostView : UIView<UIWebViewDelegate>

@property (nonatomic,weak) id<PostViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict;

@end
