//
//  JWHistoryDetailViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#define TableCellHeight     60.0

#import "JWHistoryDetailViewController.h"
#import "ListDetailTableViewCell.h"
#import "GlobalDefinition.h"
//#import "StudentModel.h"
#import "CoreDataManager.h"
#import "HistoryDetailModel.h"

@interface JWHistoryDetailViewController() <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property (strong, nonatomic) ListDetailTableViewCell *cell;
@property (strong, nonatomic) NSMutableArray *dataArray;      // 数据源数组
@end

@implementation JWHistoryDetailViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"历史详情";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];

    self.dataArray = [NSMutableArray array];
    [self initTableView];
}

//初始化table
- (void)initTableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];//UITableViewStyleGrouped
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
}

#pragma mark UITableViewDataSource - 代理
#pragma mark - UITableViewDataSource 方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
        _cell = [ListDetailTableViewCell stuListCellWithReuseIdentifier:CellIdentifier andType:nil];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    HistoryDetailModel *hisDetail = self.dataArray[indexPath.row];
    NSLog(@"------%@-----2",hisDetail);
    
    _cell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    //_cell.contentCellView.backgroundColor = [UIColor colorFromHexString:@"737373" alpha:0.3];
    [_cell drawCellWithDataByHistoryDetailModel:hisDetail];
    
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];//点击后动画消失
    _cell = [tableView  cellForRowAtIndexPath:indexPath];
//    StudentModel *stu = _dataArray[indexPath.row];
//    __weak typeof(self) wSelf = self;
//    //考勤点击
//    [_cell.leaveImageView setTapActionWithBlock:^{  //请假
//        wSelf.cell.leaveImageView.image = [UIImage imageNamed:@"stu_leave_sel_icon"];
//        wSelf.cell.attentImageView.image = [UIImage imageNamed:@"stu_attent_icon"];
//        wSelf.cell.absenceImageView.image = [UIImage imageNamed:@"stu_absence_icon"];
//    }];
//    
//    [_cell.absenceImageView setTapActionWithBlock:^{ //缺席
//        wSelf.cell.leaveImageView.image = [UIImage imageNamed:@"stu_leave_icon"];
//        wSelf.cell.attentImageView.image = [UIImage imageNamed:@"stu_attent_icon"];
//        wSelf.cell.absenceImageView.image = [UIImage imageNamed:@"stu_absence_sel_icon"];
//        attendanceStatus = 1;
//    }];
//    
//    [_cell.attentImageView setTapActionWithBlock:^{  //出席
//        wSelf.cell.leaveImageView.image = [UIImage imageNamed:@"stu_leave_icon"];
//        wSelf.cell.attentImageView.image = [UIImage imageNamed:@"stu_attent_sel_icon"];
//        wSelf.cell.absenceImageView.image = [UIImage imageNamed:@"stu_absence_icon"];
//        attendanceStatus = 2;
//    }];
    
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath && self.dataArray.count==0) {
        return;
    }
    __weak UITableView *table = tableView;
    __weak HistoryDetailModel *hisDetail = self.dataArray[indexPath.row];
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hisDetailId = %@",hisDetail.hisDetailId];
    // 删除之前需要先查询 找了那个对象才能执行删除的操作
    [CoreDataManager executeFetchRequest:[HistoryDetailModel class] predicate:predicate complete:^(NSArray *array, NSError *error) {
        if (array && array.count>0) {
            // 取出结果数组里的模型 并删除 然后保存上下文
            for (HistoryDetailModel *hisDetail in array) {
                [CoreDataManager deleteObject:hisDetail];
            }
            NSError *error = nil;
            // 保存上下文就存储数据
            [CoreDataManager save:&error];
            if (!error) {
                [self.dataArray removeObject:hisDetail];
            }
            //移除tableView中的数据
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.dataArray count]-1){
        //_tableView.tableFooterView = footView;
        
    }
    
    
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"historyId = %@",self.historyId];
    //获取所有班级列表
    [CoreDataManager executeFetchRequest:[HistoryDetailModel class] predicate:predicate complete:^(NSArray *array, NSError *error)
     {
         [self.dataArray removeAllObjects];
         if (array && array.count > 0) {
             for (HistoryDetailModel *hisDetail in array) {
                 [self.dataArray addObject:hisDetail];
             }
             
             [_tableView reloadData];
         }
     }];
}

@end
