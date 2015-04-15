//
//  CommentCreateViewController.h
//  baobaowansha2
//
//  Created by 上海震渊信息技术有限公司 on 14/12/2.
//  Copyright (c) 2014年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommentCreateDelegate

-(void)commentCreateSuccess:(NSDictionary*)dict;

@end
@interface CommentCreateViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>

-(id)initWithID:(NSInteger)postID;
-(void)addUserName:(NSString *)userName;

@property(nonatomic,retain)id<CommentCreateDelegate>delegate;

@end
