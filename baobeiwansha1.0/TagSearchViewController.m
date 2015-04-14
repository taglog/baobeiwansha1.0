//
//  TagSearchViewController.m
//  baobaowansha4
//
//  Created by 上海震渊信息技术有限公司 on 15/1/22.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//

#import "TagSearchViewController.h"
#import "TagPostTableViewController.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"

@interface TagSearchViewController ()

@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,strong) JGProgressHUD *HUD;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *historyArray;
@end


@implementation TagSearchViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBarButtonItem];
    [self initViews];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TagSearch"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TagSearch"];
}

-(void)initBarButtonItem{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    leftBarButton.tintColor = [UIColor colorWithRed:255.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}


-(void)popViewController{

    [self.navigationController popViewControllerAnimated:YES];

}
-(void)initViews{
    [self initHistoryArray];
    [self initSearchBar];
    [self initTableView];

}
-(void)initHistoryArray{
    NSString *filePath = [self dataFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"will load persisted data from file");
        self.historyArray = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
        
    } else {
        NSLog(@"file is not exist and need init self.dict");
        self.historyArray = [[NSMutableArray alloc]init];
    }

}
-(void)initSearchBar{
    
    self.searchBar = [[UISearchBar alloc]init];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbg"] forState:UIControlStateNormal];
    self.searchBar.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];


}
-(void)initTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}


#pragma mark - searchBar delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if([self.searchBar.text isEqualToString:@""]){
        //初始化HUD
        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        self.HUD.textLabel.text = @"请输入搜索内容";
        [self.HUD showInView:self.view];
        [self.HUD dismissAfterDelay:1.0];
        return;
    }
    [self.searchBar resignFirstResponder];
    
    
    //把新增加的搜索词存入历史记录里面
    [self.tableView beginUpdates];
    [self.historyArray insertObject:self.searchBar.text atIndex:0];
    NSArray *historyAddRow = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.tableView insertRowsAtIndexPaths:historyAddRow withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    NSString *filePath = [self dataFilePath];
    [self.historyArray writeToFile:filePath atomically:YES];
    
    TagPostTableViewController *tagPostViewController = [[TagPostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/tagsearch"} tag:self.searchBar.text];
    [self.navigationController pushViewController: tagPostViewController animated:YES];
    
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identity = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.textLabel.text = [self.historyArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TagPostTableViewController *tagPostViewController = [[TagPostTableViewController alloc]initWithURL:@{@"requestRouter":@"post/tagsearch"} tag:[self.historyArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController: tagPostViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"searchhistoy.plist"];
}
@end
