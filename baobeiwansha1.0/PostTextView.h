//
//  PostTextView.h
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/23.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTiledLayerWithoutFade.h"
#import "DTAttributedTextView.h"
#import "DTLazyImageView.h"
#import "DTCoreText.h"

@protocol PostTextViewDelegate <NSObject>

-(void)relayoutPostTextView:(CGSize)textSize;

@end
@interface PostTextView : UIView<DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>

@property (nonatomic,weak) id<PostTextViewDelegate> delegate;

-(id)initWithDict:(NSDictionary *)dict frame:(CGRect)frame;
-(CGSize)getTextViewHeight;

@end
