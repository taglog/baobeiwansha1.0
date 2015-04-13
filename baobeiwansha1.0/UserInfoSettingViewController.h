//
//  UserInfoViewController.h
//  baobeiwansha
//
//  Created by 上海震渊信息技术有限公司 on 15/2/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
@protocol UserInfoSettingViewDelegate

-(void)popUserInfoSettingViewController;

@end

@interface UserInfoSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate>

@property (nonatomic,retain) id <UserInfoSettingViewDelegate> delegate;
@property (nonatomic,assign) BOOL showLeftBarButtonItem;

@end
