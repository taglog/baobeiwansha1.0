//
//  UserInfoViewController.m
//  baobeiwansha
//
//  Created by 刘昕 on 15/2/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "UserInfoSettingViewController.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "JGProgressHUDErrorIndicatorView.h"


#define ORIGINAL_MAX_WIDTH 640.0f

@interface UserInfoSettingViewController ()

@property (nonatomic,retain)UIScrollView *scrollView;

@property (nonatomic,assign) BOOL isHeadImageSet;
@property (nonatomic,retain) UIImageView *headImage;

@property (nonatomic,assign) BOOL isBabyGenderSelected;
@property (nonatomic,assign) BOOL isGirlSelected;
@property (nonatomic,retain) UIImageView *crown;
@property (nonatomic,retain) UIButton *boyButton;
@property (nonatomic,retain) UIButton *girlButton;
@property (nonatomic,retain) UIView *checkMark;

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) UITextField *babyNickName;
@property (nonatomic,retain) UILabel *userGender;
@property (nonatomic,retain) UILabel *babyBirthday;
@property (nonatomic,assign) BOOL isKeyboardShow;

@property (nonatomic,retain) UIView *toolBar;
@property (nonatomic,retain) UIDatePicker *datePicker;
@property (nonatomic,assign) BOOL isDatePickerShow;

@property (nonatomic,retain) UIButton *submitButton;

@property (nonatomic,retain) AppDelegate *appDelegate;


@property (nonatomic,retain) UIView *mask;
@property (nonatomic,assign) BOOL isMaskShow;

@property (nonatomic, strong) NSMutableDictionary *userInfoDict;

@end

@implementation UserInfoSettingViewController

-(id)init{
    self = [super init];
    
    self.showLeftBarButtonItem = YES;
    self.isBabyGenderSelected = NO;
    self.isHeadImageSet = NO;
    
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor colorWithRed:255.0/255.0f green:119/255.0f blue:119/255.0f alpha:1.0f] forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initLeftBarButtonItem];

    self.title = @"设置宝贝信息";
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self initViews];
    [self initUserInfo];
    
    
}
-(void)initLeftBarButtonItem{
    
    if(self.showLeftBarButtonItem == YES){
        
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
        self.navigationItem.leftBarButtonItem = leftBarButton;
    }else{
        self.navigationItem.leftBarButtonItem = nil;

    }
}
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - 初始化views
-(void)initViews{
    
    [self initScrollView];
    
    [self initHeadImage];
    
    [self initBabyGenderButton];
    
    [self initCellLabels];
    
    [self initForm];
    
    [self initSubmitButton];
    
}

-(void)initScrollView{
    
    if(!self.scrollView){
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 36);
        [self.view addSubview:self.scrollView];
    }
    
}

-(void)initHeadImage{
    
    if(!self.headImage){
        self.headImage = [[UIImageView alloc]init];
        self.headImage.frame = CGRectMake((self.view.frame.size.width - 90)/2, 24, 90, 90);
        self.headImage.image = [UIImage imageNamed:@"btn_avatar"];
        self.headImage.layer.cornerRadius = CGRectGetHeight(self.headImage.frame)/2;
        self.headImage.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeadImage)];
        tap.numberOfTouchesRequired = 1;
        [self.headImage addGestureRecognizer:tap];
        self.headImage.userInteractionEnabled = YES;
        [self.scrollView addSubview:self.headImage];
    }
    
}


-(void)initBabyGenderButton{
    
    if(!self.boyButton){
        
        self.boyButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 75, (SHORT_SCREEN)?130:150, 60, 40)];
        
        [self.boyButton setBackgroundImage:[UIImage imageNamed:@"btn_boy_gray"] forState:UIControlStateNormal];
        [self.boyButton setBackgroundImage:[UIImage imageNamed:@"btn_boy"] forState:UIControlStateSelected];
        
        self.boyButton.layer.cornerRadius = 4;
        self.boyButton.layer.masksToBounds = YES;
        [self.boyButton addTarget:self action:@selector(editBabyGender:) forControlEvents:UIControlEventTouchUpInside];
        self.boyButton.tag = 1;
        [self.scrollView addSubview:self.boyButton];
        
        
    }
    if(!self.girlButton){
        
        self.girlButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 + 15, (SHORT_SCREEN)?130:150, 60, 40)];
        
        [self.girlButton setBackgroundImage:[UIImage imageNamed:@"btn_girl_gray"] forState:UIControlStateNormal];
        [self.girlButton setBackgroundImage:[UIImage imageNamed:@"btn_girl"] forState:UIControlStateSelected];
        self.girlButton.layer.cornerRadius = 4;
        self.girlButton.layer.masksToBounds = YES;
        [self.girlButton addTarget:self action:@selector(editBabyGender:) forControlEvents:UIControlEventTouchUpInside];
        self.girlButton.tag = 0;
        [self.scrollView addSubview:self.girlButton];
        
    }
    
    
}
-(void)initCellLabels{
    
    UIColor *fontColor = [UIColor colorWithRed:159.0/255.0f green:159.0/255.0f blue:159.0/255.0f alpha:1.0f];
    UIFont *font = [UIFont systemFontOfSize:16.0f];

    if(!self.babyNickName){
        self.babyNickName = [[UITextField alloc]init];
        self.babyNickName.frame = CGRectMake(0, 0, self.view.frame.size.width - 100, 40);
        self.babyNickName.textAlignment = NSTextAlignmentCenter;
        self.babyNickName.textColor = [UIColor colorWithRed:109.0/255.0f green:109.0/255.0f blue:109.0/255.0f alpha:1.0f];
        self.babyNickName.placeholder = @"宝贝昵称";
        [self.babyNickName setValue:fontColor
                         forKeyPath:@"_placeholderLabel.textColor"];
        self.babyNickName.font = font;
        self.babyNickName.returnKeyType = UIReturnKeyDone;
        self.babyNickName.delegate = self;

    }
    

    if(!self.userGender){
        self.userGender = [[UILabel alloc]init];
        self.userGender.text = @"你是爸爸，妈妈，或者？";
        self.userGender.frame = CGRectMake(0, 0, self.view.frame.size.width - 100, 40);
        self.userGender.textAlignment = NSTextAlignmentCenter;
        self.userGender.textColor = fontColor;
        self.userGender.font = font;

    }
    
    if(!self.babyBirthday){
        self.babyBirthday = [[UILabel alloc]init];
            self.babyBirthday.frame = CGRectMake(0, 0, self.view.frame.size.width - 100, 40);
            self.babyBirthday.text = @"请选择宝贝的生日或预产期";
            self.babyBirthday.textAlignment = NSTextAlignmentCenter;
            self.babyBirthday.textColor = fontColor;
            self.babyBirthday.font = font;
        
    }
    
}
-(void)initForm{
    
    if(!self.tableView){
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(50, (SHORT_SCREEN)?200:230, self.view.frame.size.width - 100, 200)];
        self.tableView.scrollEnabled = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *tableViewMask = [[UIView alloc]init];
        tableViewMask.backgroundColor =[UIColor clearColor];
        self.tableView.tableFooterView = tableViewMask;
        
        [self.scrollView addSubview:self.tableView];
    }
}

-(void)initSubmitButton{
    
    if(!self.submitButton){
        self.submitButton = [[UIButton alloc]initWithFrame:CGRectMake(50, (SHORT_SCREEN)?360:440, self.view.frame.size.width - 100, 50)];
        self.submitButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:126.0f/255.0f blue:131.0f/255.0f alpha:1.0];
        [self.submitButton setTitle:@"保   存" forState:UIControlStateNormal];
        self.submitButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:23.0f];
        self.submitButton.tintColor = [UIColor whiteColor];
        self.submitButton.layer.cornerRadius = 4;
        [self.submitButton addTarget:self action:@selector(syncUserInfo) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.submitButton];
    }
    
}
-(void)initUserInfo{
   
    NSString *filePath = [AppDelegate dataFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"will load persisted data from file");
        self.userInfoDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        // NSLog(@"reading: %@", self.userInfoDict);
        [self setPlaceHolders];
        
    } else {
        NSLog(@"file is not exist and need init self.dict");
        
        self.userInfoDict = [[NSMutableDictionary alloc]initWithCapacity:6];
        //[self.userInfoDict setObject:@"" forKey:@"babyGender"];
        //[self.userInfoDict setObject:@"" forKey:@"userGender"];
        //[self.userInfoDict setObject:@"" forKey:@"nickName"];
        //[self.userInfoDict setObject:[NSDate date] forKey:@"babyBirthday"];
        [self.userInfoDict setObject:[NSNumber numberWithBool:NO] forKey:@"isHeadImageSet"];
    }
    
}
-(void)setPlaceHolders{
    
    self.isHeadImageSet = [[self.userInfoDict valueForKey:@"isHeadImageSet"] boolValue];
    //NSLog(@"isHeadImageSet is %hhd", self.isHeadImageSet);
    self.headImage.image = [UIImage imageWithData:[self.userInfoDict valueForKey:@"headImage"]];
    self.babyNickName.text = [self.userInfoDict valueForKey:@"nickName"];
    [self setUserGenderText:[[self.userInfoDict valueForKey:@"userGender"]integerValue]];
    [self setDatePickerText:[self.userInfoDict valueForKey:@"babyBirthday"]];
    [self setBabyGender:[[self.userInfoDict valueForKey:@"babyGender"]integerValue]];
    
}
#pragma  mark - 同步信息
-(void)syncUserInfo{
    
    
    if(![self.userInfoDict objectForKey:@"babyGender"]){
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        HUD.textLabel.text = @"请选择宝贝性别";
        [HUD showInView:self.view];
        [HUD dismissAfterDelay:2.0];
        return;
    }

    //没有填nickname
    if(![self.userInfoDict objectForKey:@"nickName"] || [[self.userInfoDict objectForKey:@"nickName"] isEqual:@""]){
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        HUD.textLabel.text = @"请填写宝贝昵称";
        [HUD showInView:self.view];
        [HUD dismissAfterDelay:2.0];
        return;
    }

    if(![self.userInfoDict objectForKey:@"userGender"]){
        NSLog(@"no userGender");
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        HUD.textLabel.text = @"请选择您的身份";
        [HUD showInView:self.view];
        [HUD dismissAfterDelay:2.0];
        return;
    }

    if(![self.userInfoDict objectForKey:@"babyBirthday"]){
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        HUD.textLabel.text = @"请选择宝贝生日";
        [HUD showInView:self.view];
        [HUD dismissAfterDelay:2.0];
        return;
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"保存中...";
    [HUD showInView:self.view];
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    
    //NSLog(@"sending: %@", self.userInfoDict);
    
    [self.userInfoDict setObject:self.appDelegate.generatedUserID forKey:@"userIdStr"];
    
    NSString * userInfoURL = [self.appDelegate.rootURL stringByAppendingString:@"/serverside/user_info.php"];
    
    
    AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
    afnmanager.requestSerializer.timeoutInterval = 20;
    afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    // 仅上传非图片部分
    NSMutableDictionary * userTextInfoDict = [[NSMutableDictionary alloc] init];
    [userTextInfoDict setValue:[self.userInfoDict objectForKey:@"babyGender"] forKey:@"babyGender"];
    [userTextInfoDict setValue:[self.userInfoDict objectForKey:@"nickName"] forKey:@"nickName"];
    [userTextInfoDict setValue:[self.userInfoDict objectForKey:@"userGender"] forKey:@"userGender"];
    [userTextInfoDict setValue:[self.userInfoDict objectForKey:@"babyBirthday"] forKey:@"babyBirthday"];
    [userTextInfoDict setObject:self.appDelegate.generatedUserID forKey:@"userIdStr"];
    
    
    [afnmanager POST:userInfoURL parameters:userTextInfoDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Sync successed: %@", responseObject);
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        //加入
        NSString *filePath = [AppDelegate dataFilePath];
        [self.userInfoDict writeToFile:filePath atomically:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoChanged" object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            HUD.textLabel.text = @"保存成功";
            HUD.detailTextLabel.text = nil;
            HUD.layoutChangeAnimationDuration = 0.4;
            HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD dismiss];
            [self.appDelegate popUserInfoSettingViewController];
            // 如果是点击过来的，需要弹出
            
            [self.navigationController popViewControllerAnimated:YES];
            

            
        });
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Sync Error: %@", error);
        
        HUD.textLabel.text = @"网络连接失败，请重试一下吧~";
        HUD.detailTextLabel.text = nil;
        HUD.layoutChangeAnimationDuration = 0.4;
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        [HUD dismissAfterDelay:2];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
    
    
    
}
#pragma mark - 更换头像
-(void)changeHeadImage{
    
    UIActionSheet *headSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取",@"默认", nil];
   
        [headSheet showInView:self.view];

}


#pragma mark - 选择宝宝性别
-(void)initCrown:(NSInteger)babyGender{
    
    if(!self.crown){
        self.crown = [[UIImageView alloc]init];
        self.crown.image = [UIImage imageNamed:@"crown"];
        [self.scrollView addSubview:self.crown];
    }
    //女孩
    if(babyGender == 0){
        self.crown.frame = CGRectMake(self.view.frame.size.width/2 + 35 , (SHORT_SCREEN)?110:128, 20, 18);
    }else{
        self.crown.frame = CGRectMake(self.view.frame.size.width/2 - 55, (SHORT_SCREEN)?110:128, 20, 18);
    }
    
}

-(void)editBabyGender:(id)sender{
    
    [self setBabyGender:[sender tag]];
    
}


-(void)setBabyGender:(NSInteger)babyGender{
    //选择了男孩

    if(babyGender == 1){
        [self boyButtonSelected];
    }
    
    //如果选择了女孩
    if(babyGender == 0){
        
        [self girlButtonSelected];
    }



}
-(void)boyButtonSelected{
    
    if(self.isBabyGenderSelected == NO){
        self.boyButton.selected = YES;
        [self initCrown:1];
        self.isBabyGenderSelected = YES;

    }
    
    if(self.isGirlSelected == YES){
        self.girlButton.selected = NO;
        self.boyButton.selected = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.crown.frame = CGRectMake(self.view.frame.size.width/2 - 55, (SHORT_SCREEN)?110:128, 20, 18);
            
        }];

    }
    if(self.isHeadImageSet == NO){
        self.headImage.image = [UIImage imageNamed:@"boyhead"];
    }
    self.isGirlSelected = NO;
    [self.userInfoDict setValue:[NSNumber numberWithInt:1] forKey:@"babyGender"];

}

-(void)girlButtonSelected{
    
    if(self.isBabyGenderSelected == NO){
        self.girlButton.selected = YES;
        [self initCrown:0];
        self.isBabyGenderSelected = YES;
        
    }
    
    if(self.isGirlSelected == NO){
        self.girlButton.selected = YES;
        self.boyButton.selected = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.crown.frame = CGRectMake(self.view.frame.size.width/2 + 35 , (SHORT_SCREEN)?110:128, 20, 18);
            
        }];
    }
    
    if(self.isHeadImageSet == NO){
        self.headImage.image = [UIImage imageNamed:@"girlhead"];
    }
    
    self.isGirlSelected = YES;
    [self.userInfoDict setValue:[NSNumber numberWithInt:0] forKey:@"babyGender"];
    
}

#pragma mark - 表格
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"List";
    
    //创建cell
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        //宝宝昵称
        if(indexPath.row == 2){
            
            [cell.contentView addSubview:self.babyNickName];
            
            
            
        }
        //用户身份
        else if(indexPath.row == 1){
            
            
            [cell.contentView addSubview:self.userGender];
        }
        //宝宝生日
        else if(indexPath.row == 0){
            
            
            [cell.contentView addSubview:self.babyBirthday];
            
        }
        
        CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(0.0f, 43.0f, self.view.frame.size.width - 100, 0.5f);
        
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                         alpha:1.0f].CGColor;
        
        [cell.layer addSublayer:bottomBorder];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SHORT_SCREEN)?45.0f:70.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        
        [self showKeyboard];
        [self showMaskView];
        
    }else if(indexPath.row == 1){
        [self editUserGender];
        
    }else if(indexPath.row == 0){
        [self showDatePicker];
        [self showMaskView];
        
    }
    
}

#pragma mark - textField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showKeyboard];
    [self showMaskView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self hideKeyboard];
    [self dismissMaskView];
    return NO;
}

-(void)showKeyboard{
    [self.babyNickName becomeFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 80);
    } completion:^(BOOL finished) {
    }];
    self.isKeyboardShow = YES;
}

-(void)hideKeyboard{
    
    [self.babyNickName resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
    }];
    self.isKeyboardShow = NO;
    [self.userInfoDict setValue:self.babyNickName.text forKey:@"nickName"];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([actionSheet.title isEqual:@"请选择您的角色"]) {
        [self setUserGenderText:buttonIndex];
        [self setUserGenderToDict:buttonIndex];
    }else{
        if (buttonIndex == 0) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
            
        } else if (buttonIndex == 1) {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        } else if (buttonIndex == 2) {
            //恢复默认背景图片
            UIImage *defaultImg = [UIImage imageNamed:@"btn_avatar"];
            self.headImage.image = defaultImg;
            [self.userInfoDict setObject:UIImagePNGRepresentation(defaultImg) forKey:@"headImage"];
            self.isHeadImageSet = NO;
            [self.userInfoDict setObject:[NSNumber numberWithBool:NO] forKey:@"isHeadImageSet"];
        }

    }
}

-(void)setUserGenderText:(NSInteger)buttonIndex{
    
    UIColor *color = [UIColor colorWithRed:109.0/255.0f green:109.0/255.0f blue:109.0/255.0f alpha:1.0f];
    if (buttonIndex == 0) {
        
        self.userGender.text = @"我是妈妈";
        self.userGender.textColor = color;
        
    } else if (buttonIndex == 1) {
        
        self.userGender.text = @"我是爸爸";
        self.userGender.textColor = color;

    } else if (buttonIndex == 2){
        
        self.userGender.text = @"其他";
        self.userGender.textColor = color;

    }
    


}

-(void)setUserGenderToDict:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self.userInfoDict setValue:[NSNumber numberWithInt:0] forKey:@"userGender"];
        
    } else if (buttonIndex == 1) {
       
        [self.userInfoDict setValue:[NSNumber numberWithInt:1] forKey:@"userGender"];
    } else if (buttonIndex == 2){
        
        [self.userInfoDict setValue:[NSNumber numberWithInt:2] forKey:@"userGender"];
    }
}

//用户身份
-(void)editUserGender{
    
    UIActionSheet *userGenderSheet = [[UIActionSheet alloc] initWithTitle:@"请选择您的角色"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"我是妈妈", @"我是爸爸", @"其他", nil];
    [userGenderSheet showInView:self.view];
    
}

#pragma mark - 设置宝宝年龄
-(void)showDatePicker{
    
    [self showMaskView];
    if(!self.datePicker){
        
        self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height + 30, self.view.frame.size.width, 200)];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        if([self.userInfoDict objectForKey:@"babyBirthday"]){
            [self.datePicker setDate:[self.userInfoDict objectForKey:@"babyBirthday"]];

        }else{
            [self.datePicker setDate:[NSDate date]];
        }
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:10 * 30 * 24 * 60 * 60]; // 设置最大时间
        self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:6* 365 * 24 * 60 * 60 * -1]; // 设置最小时间
        
        self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
        self.toolBar.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:101.0/255.0f blue:108.0/255.0f alpha:1.0f];
        
        UIButton *datePickerDoneButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 45, 0, 30, 40)];
        [datePickerDoneButton setTitle:@"确定" forState:UIControlStateNormal];
        datePickerDoneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [datePickerDoneButton addTarget:self action:@selector(datePickerDone) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *datePickerCancelButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 30, 40)];
        [datePickerCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        datePickerCancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [datePickerCancelButton addTarget:self action:@selector(datePickerCancel) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.toolBar addSubview:datePickerCancelButton];
        [self.toolBar addSubview:datePickerDoneButton];
        
        [self.navigationController.view addSubview:self.toolBar];
        
        [self.navigationController.view addSubview:self.datePicker];
        
    }
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.datePicker.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 240);
        self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - 240, self.view.frame.size.width, 40);
        
    } completion:^(BOOL finished) {
        
        self.isDatePickerShow = YES;
        
    }];
    
}
-(void)datePickerDone{
    
    [self setDatePickerText:[self.datePicker date]];
    [self.userInfoDict setObject:[self.datePicker date] forKey:@"babyBirthday"];
    
    [self hideDatePicker];
    
    
}
-(void)setDatePickerText:(NSDate *)date{
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *locationString=[formatter stringFromDate:date];
    
    self.babyBirthday.text = locationString;
    self.babyBirthday.textColor = [UIColor colorWithRed:109.0/255.0f green:109.0/255.0f blue:109.0/255.0f alpha:1.0f];
    
}
-(void)datePickerCancel{
    
    [self hideDatePicker];
    
    
}
-(void)hideDatePicker{
    
    [self dismissMaskView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.datePicker.frame = CGRectMake(0, self.view.frame.size.height + 30, self.view.frame.size.width, 200);
        self.toolBar.frame = CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, 30);
        
    } completion:^(BOOL finished) {
        self.isDatePickerShow = NO;
        
    }];
    
}

-(void)dismissViews{
    
    if(self.isKeyboardShow == YES){
        [self hideKeyboard];
    }
    
    if(self.isDatePickerShow == YES){
        [self hideDatePicker];
    }
    
    [self dismissMaskView];
}


-(void)showMaskView{
    
    if(!self.mask){
        self.mask = [[UIView alloc]initWithFrame:self.view.frame];
        self.mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViews)];
        tapGesture.cancelsTouchesInView = NO;
        
        [self.mask addGestureRecognizer:tapGesture];
        [self.navigationController.view addSubview:self.mask];
        
    }
    self.mask.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    } completion:^(BOOL finished) {
        self.isMaskShow = YES;
    }];
    
}

-(void)dismissMaskView{
    
    if(self.isMaskShow == YES){
        
        [UIView animateWithDuration:0.2 animations:^{
            self.mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        } completion:^(BOOL finished) {
            self.mask.hidden = YES;
            self.isMaskShow = NO;
        }];
    }
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    self.headImage.image = editedImage;
    self.isHeadImageSet = YES;
    [self.userInfoDict setObject:[NSNumber numberWithBool:YES] forKey:@"isHeadImageSet"];

    [self.userInfoDict setObject:UIImagePNGRepresentation(editedImage) forKey:@"headImage"];
    
    //self.userAvatarImageView.image = editedImage;
    //[self.delegate updateAvatarImage:editedImage];

    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        float ratio = 1;
        
        float orgHeight = (self.view.frame.size.height - self.view.frame.size.width/ratio)/2;
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, orgHeight, self.view.frame.size.width, self.view.frame.size.width/ratio) limitScaleRatio:2.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}



@end
