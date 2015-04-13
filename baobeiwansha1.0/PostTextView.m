//
//  PostTextView.m
//  baobeiwansha1.0
//
//  Created by 上海震渊信息技术有限公司 on 15/3/23.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "PostTextView.h"
@interface PostTextView ()

@property(nonatomic,strong) NSDictionary *postDict;

@property (nonatomic,retain) NSString *postTitle;
@property (nonatomic,retain) NSString *postContent;
@property (nonatomic,retain) DTAttributedTextView *textView;
@property (nonatomic,strong) NSString *htmlPostContent;

@property (nonatomic,assign) CGSize textViewSize;
@property (nonatomic,assign) CGRect aframe;
@end
@implementation PostTextView

-(id)initWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    self = [super init];
    
    self.postDict = dict;
    self.aframe = frame;
    
    [self initTextView];
    
    return self;
}

//初始化textView
-(void)initTextView{
    
    self.postTitle = [_postDict valueForKey:@"post_title"];
    self.postContent = [_postDict valueForKey:@"post_content"];
    
    //初始化PostTitle
    NSString *htmlPostTitleStart = @"<h2 style='font-size:16px;color:#33333;margin:10px 0'>";
    NSString *htmlPostTitleWithStart = [htmlPostTitleStart stringByAppendingString:self.postTitle];
    NSString *htmlPostTItleWithEnd = [htmlPostTitleWithStart stringByAppendingString:@"</h2>"];
    self.htmlPostContent = [htmlPostTItleWithEnd stringByAppendingString:self.postContent];

    //初始化DTTextView
    if(_textView == nil){
        _textView = [[DTAttributedTextView alloc] init];
        
        
        _textView.shouldDrawImages = NO;
        _textView.shouldDrawLinks = NO;
        _textView.scrollEnabled = NO;
        _textView.textDelegate = self;
        
        
        [_textView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        _textView.contentInset = UIEdgeInsetsMake(10, 15, 14, 15);
        
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        
        _textView.attributedString = [self _attributedStringForSnippetUsingiOS6Attributes:NO];
        
        _textViewSize = [self getTextViewHeight:_textView.attributedString];

        if(_textViewSize.height* 0.052 < 100){
            _textView.frame = CGRectMake(0, 0, self.aframe.size.width, _textViewSize.height +100);
        }else{
            _textView.frame = CGRectMake(0, 0, self.aframe.size.width, _textViewSize.height +_textViewSize.height* 0.052);
        }
        
        [self addSubview:_textView];
        
    }
    
}
-(CGSize)getTextViewHeight{
    CGSize textSize;
    
    if(_textViewSize.height* 0.052 < 100){
        
       textSize = CGSizeMake(_textViewSize.width, _textViewSize.height +100);

    }else{
        textSize = CGSizeMake(_textViewSize.width, _textViewSize.height +_textViewSize.height* 0.052);
    }
    return textSize;
}

//获取_textView的高度
-(CGSize)getTextViewHeight:(NSAttributedString *)string{
    
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:string];
    
    CGRect maxRect = CGRectMake(10, 20, self.aframe.size.width, CGFLOAT_HEIGHT_UNKNOWN);
    NSRange entireString = NSMakeRange(0, [string length]);
    DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:maxRect range:entireString];
    
    CGSize sizeNeeded = [layoutFrame frame].size;
    
    
    return sizeNeeded;
}

#pragma mark _textView的委托

- (NSAttributedString *)_attributedStringForSnippetUsingiOS6Attributes:(BOOL)useiOS6Attributes
{
    // Load HTML data
    NSString *html = self.htmlPostContent;
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create attributed string from HTML
    CGSize maxImageSize = CGSizeMake(self.aframe.size.width-30.0, 1.1*(self.aframe.size.width-30.0));
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        // the block is being called for an entire paragraph, so we check the individual elements
        
        for (DTHTMLElement *oneChildElement in element.childNodes)
        {
            // if an element is larger than twice the font size put it in it's own block
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }
    };
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption,
                                    [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                                    @"Helvetica Neue", DTDefaultFontFamily,
                                    @"purple", DTDefaultLinkColor,
                                    @"red", DTDefaultLinkHighlightColor,
                                    callBackBlock, DTWillFlushBlockCallBack,
                                    [NSNumber numberWithFloat:1.5], DTDefaultLineHeightMultiplier,
                                    [NSNumber numberWithInt:16],DTDefaultFontSize,
                                    nil];
    
    if (useiOS6Attributes)
    {
        [options setObject:[NSNumber numberWithBool:YES] forKey:DTUseiOS6Attributes];
    }
    
    //[options setObject:[NSURL fileURLWithPath:readmePath] forKey:NSBaseURLDocumentOption];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    
    return string;
}



- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
    return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTVideoTextAttachment class]])
    {
        // removed temp for no video is supported
    }
    else if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        // if the attachment has a hyperlinkURL then this is currently ignored
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        // if there is a hyperlink then add a link button on top of this image
        if (attachment.hyperLinkURL)
        {
            // NOTE: this is a hack, you probably want to use your own image view and touch handling
            // also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
            imageView.userInteractionEnabled = NO;
            
            DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
            button.URL = attachment.hyperLinkURL;
            button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
            button.GUID = attachment.hyperLinkGUID;
            
            // use normal push action for opening URL
            [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            // demonstrate combination with long press
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
            [button addGestureRecognizer:longPress];
            
            [imageView addSubview:button];
        }
        
        return imageView;
    }
    else if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
    {
        DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
        videoView.attachment = attachment;
        
        return videoView;
    }
    else if ([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        // somecolorparameter has a HTML color
        NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
        UIColor *someColor = DTColorCreateWithHTMLName(colorName);
        
        UIView *someView = [[UIView alloc] initWithFrame:frame];
        someView.backgroundColor = someColor;
        someView.layer.borderWidth = 1;
        someView.layer.borderColor = [UIColor blackColor].CGColor;
        
        someView.accessibilityLabel = colorName;
        someView.isAccessibilityElement = YES;
        
        return someView;
    }
    
    return nil;
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
    
    CGColorRef color = [textBlock.backgroundColor CGColor];
    if (color)
    {
        CGContextSetFillColorWithColor(context, color);
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextFillPath(context);
        
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextStrokePath(context);
        return NO;
    }
    
    return YES; // draw standard background
}


#pragma mark Actions

- (void)linkPushed:(DTLinkButton *)button
{
    NSURL *URL = button.URL;
    
    if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]])
    {
        [[UIApplication sharedApplication] openURL:[URL absoluteURL]];
    }
    else
    {
        if (![URL host] && ![URL path])
        {
            
            // possibly a local anchor link
            NSString *fragment = [URL fragment];
            
            if (fragment)
            {
                [_textView scrollToAnchorNamed:fragment animated:NO];
            }
        }
    }
}


- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        DTLinkButton *button = (id)[gesture view];
        button.highlighted = NO;
        
        if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]])
        {
            //UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[[button.URL absoluteURL] description] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
            //[action showFromRect:button.frame inView:button.superview animated:YES];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint location = [gesture locationInView:_textView];
        NSUInteger tappedIndex = [_textView closestCursorIndexToPoint:location];
        
        NSString *plainText = [_textView.attributedString string];
        NSString *tappedChar = [plainText substringWithRange:NSMakeRange(tappedIndex, 1)];
        
        __block NSRange wordRange = NSMakeRange(0, 0);
        
        [plainText enumerateSubstringsInRange:NSMakeRange(0, [plainText length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            if (NSLocationInRange(tappedIndex, enclosingRange))
            {
                *stop = YES;
                wordRange = substringRange;
            }
        }];
        
        NSString *word = [plainText substringWithRange:wordRange];
        NSLog(@"%lu: '%@' word: '%@'", (unsigned long)tappedIndex, tappedChar, word);
    }
}


#pragma mark - DTLazyImageViewDelegate

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    
    // update all attachments that matchin this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [_textView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        
        oneAttachment.originalSize = imageSize;
        float ratio = imageSize.height/imageSize.width;
        CGFloat imageHeight = (self.aframe.size.width - 30) * ratio;
        if(ratio > 1.2){
            imageHeight = (self.aframe.size.width - 100) * ratio;
            oneAttachment.displaySize = CGSizeMake(self.aframe.size.width - 100, imageHeight);
        }else{
            oneAttachment.displaySize = CGSizeMake(self.aframe.size.width - 30, imageHeight);
            
        }
        
        
    }
    
    // layout might have changed due to image sizes
    [_textView relayoutText];
    _textViewSize = [self getTextViewHeight:_textView.attributedString];
    
    if([self.delegate respondsToSelector:@selector(relayoutPostTextView:)]){
        [self.delegate relayoutPostTextView:_textViewSize];
    }
}

@end
