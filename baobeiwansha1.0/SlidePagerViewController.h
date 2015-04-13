//
//  SlidePagerViewController.h
//  
//
//  Created by 上海震渊信息技术有限公司 on 15/3/6.
//
//

#import <UIKit/UIKit.h>


@protocol SlidePagerViewControllerDelegate;
@protocol SlidePagerViewControllerDataSource;

typedef NS_ENUM(NSUInteger, SlidePagerOption) {
    SlidePagerOptionTabHeight,
    SlidePagerOptionTabWidth,
};



@interface SlidePagerViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic,assign) id <SlidePagerViewControllerDelegate> delegate;
@property (nonatomic,assign) id <SlidePagerViewControllerDataSource> dataSource;

-(void)renderViews;

@end


@protocol SlidePagerViewControllerDataSource <NSObject>
@required
//tab button个数
-(NSUInteger)numberOfTabsForSlidePager:(SlidePagerViewController *)slideView;

//tabView
-(UIView *)slidePager:(SlidePagerViewController *)slideView viewForTabAtIndex:(NSUInteger)index;

//viewPager
-(UIViewController *)slidePager:(SlidePagerViewController *)slidePager contentViewControllerForTabAtIndex:(NSUInteger)index;

@end

@protocol SlidePagerViewControllerDelegate <NSObject>
@required
- (CGFloat)slidePager:(SlidePagerViewController *)slidePager valueForOption:(SlidePagerOption)option withDefault:(CGFloat)value;
@optional
-(void)slidePager:(SlidePagerViewController *)slidePager didChangeTabToIndex:(NSUInteger)index;
@end
