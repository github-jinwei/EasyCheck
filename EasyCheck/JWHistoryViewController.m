//
//  JWHistoryViewController.m
//  EasyCheck
//
//  Created by JinWei on 16/4/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//
#define TableCellHeight     60.0

#import "JWHistoryViewController.h"
#import "HistoryListViewCell.h"
#import "GlobalDefinition.h"
#import "HistoryModel.h"
#import "CoreDataManager.h"
#import "UIView+Utils.h"
#import "CodeFragments.h"
#import "JWHistoryDetailViewController.h"

@interface JWHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    HistoryListViewCell *_cell;
    UITableView *_tableView;
    UIView *headView;
    NSMutableArray *_dataArray; // 数据源数组
    UILabel *yearTimeLabel;
}

@end

@implementation JWHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addBarButton =[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editHistoryInfo)];
    [addBarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addBarButton;
    _dataArray = [NSMutableArray array];
    if (self.view) {
        [self initHeadView];//初始化表头
        [self initTableView];//初始化列表
    }
   
}

//初始化table
- (void)initTableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = headView;
        [self.view addSubview:_tableView];
        [_tableView reloadData];
    }
}

- (void)initHeadView {
    headView = [[UIView alloc] init];
    headView.size = CGSizeMake(SCREEN_WIDTH, 20);
    headView.userInteractionEnabled = YES;
    headView.backgroundColor = [UIColor whiteColor];//[UIColor colorFromHexString:@"8abaf4" alpha:1];
    
    UIView *headContentView = [[UIView alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH - 10, 20)];
    headContentView.layer.cornerRadius = 2;
    headContentView.backgroundColor = [UIColor colorFromHexString:@"2ab2f5" alpha:1];
    headContentView.userInteractionEnabled = YES;
    [headView addSubview:headContentView];
    
    yearTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,1, 100, 20)];
    yearTimeLabel.text = @"16年5月";
    yearTimeLabel.font = [UIFont systemFontOfSize:14];
    yearTimeLabel.textColor = [UIColor whiteColor];
    [headContentView addSubview:yearTimeLabel];
}

//编辑历史信息
-(void)editHistoryInfo{
    NSLog(@"你点击了我");
    
    int hisId = 0;
    // 用户 id 如果没有就存个0 如果有值新建的用户 id 对比上个用户 id +1
    NSNumber *lastId = [[NSUserDefaults standardUserDefaults] objectForKey:@"hisId"];
    if (lastId)
    {
        hisId = lastId.intValue +1;
    }else{
        
        [[NSUserDefaults standardUserDefaults]setObject:@0 forKey:@"hisId"];
    }
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YY-MM-dd hh:mm"];
//    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    HistoryModel *hisModel = [CoreDataManager insertNewObjectForEntityForName:[HistoryModel class]];
    hisModel.classNames = @"软件工程";
    hisModel.classId = @(1);
    hisModel.createTime = currentDate;
    hisModel.historyId = @(hisId);
    
    NSError *error  = nil;
    [CoreDataManager save:&error];
    if (!error) {
        //[self.navigationController popViewControllerAnimated:YES];
        NSLog(@"添加成功");
        [_tableView reloadData];
    }
}

#pragma mark UITableViewDataSource - 代理
#pragma mark - UITableViewDataSource 方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listTableCellView";
    _cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!_cell){
        _cell = [HistoryListViewCell historyListCellWithReuseIdentifier:CellIdentifier andType:nil];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.row == ( _dataArray.count - 1)) {
        [_cell.line2VerticalView setHidden:YES];
    }
    
    HistoryModel *historyModel = _dataArray[indexPath.row];
    
    yearTimeLabel.text = [NSString stringWithFormat:@"%@年%@月",[historyModel.createTime dateWithFormat:@"YY"],[historyModel.createTime dateWithFormat:@"MM"]];
    
    [_cell drawCellWithData:historyModel];
    
    return _cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"你点击了我");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HistoryModel *hisModel = _dataArray[indexPath.row];
    JWHistoryDetailViewController *hisDetailVC =  [[JWHistoryDetailViewController alloc] init];
    hisDetailVC.historyId = hisModel.historyId;
    [self.navigationController pushViewController:hisDetailVC animated:YES];
    
    
    //AddFriendViewController *addVC = [[AddFriendViewController alloc]  init];
    //addVC.type = UploadFriend;
    //addVC.people = p;
    //[self.navigationController pushViewController:addVC animated:YES];
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath && _dataArray.count==0) {
        return;
    }
    __weak UITableView *table = tableView;
    __weak HistoryModel *historyModel = _dataArray[indexPath.row];
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"historyId = %@",historyModel.historyId];
    // 删除之前需要先查询 找了那个对象才能执行删除的操作
    [CoreDataManager executeFetchRequest:[HistoryModel class] predicate:predicate complete:^(NSArray *array, NSError *error) {
        if (array && array.count>0) {
            // 取出结果数组里的模型 并删除 然后保存上下文
            for (HistoryModel *his in array) {
                [CoreDataManager deleteObject:his];
            }
            NSError *error = nil;
            // 保存上下文就存储数据
            [CoreDataManager save:&error];
            if (!error) {
                [_dataArray removeObject:historyModel];
            }
            //移除tableView中的数据
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDatas];
}


/**
 *   从数据库读取数据
 */
- (void)loadDatas
{
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@",id];
    //获取所有班级列表
    [CoreDataManager executeFetchRequest:[HistoryModel class] predicate:nil complete:^(NSArray *array, NSError *error)
     {
         [_dataArray removeAllObjects];
         if (array && array.count > 0) {
             for (HistoryModel *his in array) {
                 [_dataArray addObject:his];
             }
             [_tableView reloadData];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
