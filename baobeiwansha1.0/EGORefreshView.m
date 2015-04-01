//
//  EGORefreshView.m
//  baobeiwansha1.0
//
//  Created by 刘昕 on 15/3/4.
//  Copyright (c) 2015年 刘昕. All rights reserved.
//

#import "EGORefreshView.h"

#define FLIP_ANIMATION_DURATION 0.18f
#define TEXT_COLOR	 [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0]
#define TEXT_COLOR2	 [UIColor whiteColor]

@interface EGORefreshView (Private)

@end
@implementation EGORefreshView

-(id)initWithScrollView:(UIScrollView *)scrollView position:(EGORefreshPosition)position{
    _scrollView = scrollView;
    _position = position;
    self.isTextColorBlack = YES;
    if (_position == EGORefreshHeader) {
        
        self = [self initWithFrame:CGRectMake(0.0f, 10.0f - _scrollView.bounds.size.height, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
    }else{
        
        self = [self initWithFrame:CGRectMake(0, 0,_scrollView.frame.size.width,40.0f)];
    }
    
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        if(_position == EGORefreshHeader){
            //上次更新label
            self.lastUpdateLabel = [[UILabel alloc] init];
            if(_position == EGORefreshHeader){
                self.lastUpdateLabel.frame = CGRectMake(0.0f, frame.size.height - 37.0f, self.frame.size.width, 20.0f);
            }
            else{
                self.lastUpdateLabel.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 20.0f);
            }
            self.lastUpdateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            self.lastUpdateLabel.font = [UIFont systemFontOfSize:12.0f];
            
            self.lastUpdateLabel.textColor = TEXT_COLOR;
            
            self.lastUpdateLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
            self.lastUpdateLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
            self.lastUpdateLabel.backgroundColor = [UIColor clearColor];
            self.lastUpdateLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:self.lastUpdateLabel];
            _lastUpdateLabel = self.lastUpdateLabel;
            
            //箭头
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 20.0f, 40.0f);
            layer.contentsGravity = kCAGravityResizeAspect;
            layer.contents = (id)[UIImage imageNamed:@"grayArrow.png"].CGImage;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                layer.contentsScale = [[UIScreen mainScreen] scale];
            }
#endif
            
            [[self layer] addSublayer:layer];
            _arrowImage=layer;

        }
        
        //状态label
        self.statusLabel = [[UILabel alloc] init];
        if(_position == EGORefreshHeader){
            self.statusLabel.frame = CGRectMake(0.0f, frame.size.height - 60.0f, self.frame.size.width, 20.0f);
        }
        else{
            self.statusLabel.frame = CGRectMake(0.0f, frame.size.height - 7.0f, self.frame.size.width, 20.0f);
        }
        self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        
        self.statusLabel.textColor = TEXT_COLOR;

        
        self.statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        self.statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLabel];
        _statusLabel = self.statusLabel;
        
        
        //开始加载的指示
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        if(_position == EGORefreshHeader){
            view.frame = CGRectMake(30.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        }
        else{
            view.frame = CGRectMake(frame.size.width/2.0f - 10.0f, frame.size.height - 30.0f, 20.0f, 20.0f);
        }
        
        [self addSubview:view];
        _activityView = view;
        
        
        [self setState:EGOOPullRefreshNormal];
        
    }
    return self;
}
-(void)setIsTextColorBlack:(BOOL)isTextColorBlack{
    
    if(isTextColorBlack == NO){
        
        self.statusLabel.textColor = TEXT_COLOR2;
        self.statusLabel.shadowColor = [UIColor clearColor];

        self.lastUpdateLabel.textColor = TEXT_COLOR2;
        self.lastUpdateLabel.shadowColor = [UIColor clearColor];


    }
}
- (void)refreshLastUpdatedDate {
    
    if(_position == EGORefreshHeader){
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
            
            NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            _lastUpdateLabel.text = [NSString stringWithFormat:@"上次更新: %@", [formatter stringFromDate:date]];
            [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else {
            
            _lastUpdateLabel.text = nil;
            
        }
    }
    
}
#pragma mark -
#pragma mark Setters

-(void)setState:(EGOPullRefreshState)aState{
    
    switch (aState) {
        case EGOOPullRefreshPulling:
            
            _statusLabel.text = NSLocalizedString(@"释放刷新", @"Release to refresh status");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            
            break;
        case EGOOPullRefreshNormal:
            
            if (_state == EGOOPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            
            if(_position == EGORefreshHeader){
                _statusLabel.text = NSLocalizedString(@"下拉刷新", @"Pull down to refresh status");
            }else{
                _statusLabel.text = NSLocalizedString(@"上拉刷新", @"Pull down to refresh status");
            }
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            [self refreshLastUpdatedDate];
            
            break;
        case EGOOPullRefreshLoading:
            
            _statusLabel.text = NSLocalizedString(@"正在加载", @"Loading Status");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            break;
        default:
            break;
    }
    
    _state = aState;
    
}

#pragma mark - 滚动相关的方法
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_state == EGOOPullRefreshLoading) {
        
        if(_position == EGORefreshHeader){
            
            CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
            offset = MIN(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        }
        else{
            
            CGFloat offset = MAX(scrollView.frame.size.height+scrollView.contentOffset.y-scrollView.contentSize.height, 0);
            offset = MIN(offset, 60);
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
        }
        
    } else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
            _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
        }
        
        BOOL pullingCondition = NO;
        BOOL normalCondition = NO;
        
        if(_position == EGORefreshHeader){
            
            pullingCondition = (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f);
            normalCondition = (scrollView.contentOffset.y < -65.0f);
            
        }else{
            
            CGFloat y = scrollView.contentOffset.y+scrollView.frame.size.height;
            pullingCondition = ((y < (scrollView.contentSize.height+65.0f)) && (y > scrollView.contentSize.height));
            normalCondition = (y > (scrollView.contentSize.height+65.0f));
        }
        
        if (_state == EGOOPullRefreshPulling && pullingCondition && !_loading) {
            
            [self setState:EGOOPullRefreshNormal];
            
        } else if (_state == EGOOPullRefreshNormal && normalCondition && !_loading) {
            
            [self setState:EGOOPullRefreshPulling];
        }
        
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
        
    }
    
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
    }
    
    BOOL condition = NO;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if(_position == EGORefreshHeader){
        condition = (scrollView.contentOffset.y <= - 45.0f);
        insets = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        _pullDown = condition ? YES : NO;
        
    }else{
        CGFloat y = scrollView.contentOffset.y+scrollView.frame.size.height-scrollView.contentSize.height;
        condition = (y > 45.0f);
        insets = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        _pullUp = condition ? YES : NO;
    }
    
    if (condition && !_loading) {
        
        if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
        }
        
        [self setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = insets;
        [UIView commitAnimations];
        
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    [self setState:EGOOPullRefreshNormal];
    
}

@end
