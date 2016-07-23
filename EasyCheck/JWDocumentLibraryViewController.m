//
//  JWDocumentLibraryViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/15.
//  Copyright © 2016年 Weijin. All rights reserved.
//
#define TableCellHeight     44.0


#import "JWDocumentLibraryViewController.h"
#import "CodeFragments.h"
#import "GlobalDefinition.h"
#import "ClassList.h"
#import "JWListDetailViewController.h"
#import "CoreDataManager.h"
#import "JWAddListViewController.h"
#import "StudentModel.h"

@interface JWDocumentLibraryViewController()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray; // 数据源数组
    UITableViewCell *_cell;
    NSMutableArray *dataStuArray;
    NSString *classNames;
}

@end

@implementation JWDocumentLibraryViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的文件库";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d3d2d7" alpha:0.6];
    _dataArray = [NSMutableArray array];
    dataStuArray = [NSMutableArray array];
    if (self.view) {
        [self initTableView];
    }
}

//初始化table
- (void)initTableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,30,SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
       //_cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.4];
    [_cell.contentView addSubview:view];
    ClassList *p = _dataArray[indexPath.row];
    _cell.textLabel.text = [NSString stringWithFormat:@"%@<统计名单>.cvs",p.classNames];
    _cell.textLabel.font = [UIFont systemFontOfSize:15];
    //_cell.textLabel.text = [NSString stringWithFormat:@"%@<普通名单>.cvs",p.classNames];
    return _cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"你点击了我");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClassList *c = _dataArray[indexPath.row];
    [self loadStudentDatasByClassId:c.classId];
    classNames = c.classNames;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *docementDir = documentsDirectory;//[documents objectAtIndex:0];
    NSString *filePath = [docementDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@student.csv",classNames]];
    NSLog(@"filePath = %@", filePath);
    
    [self createFile:filePath];
    [self exportCSV:filePath];

//    JWAddListViewController *addListVC = [[JWAddListViewController alloc] init];
//    addListVC.editType = UploadClassList;
//    addListVC.listModel = c;
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionPush;//可更改为其他方式
//    transition.subtype = kCATransitionFromTop;//可更改为其他方式
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    transition.duration = 0.5;
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    [self.navigationController pushViewController:addListVC animated:NO];
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath&&_dataArray.count==0) {
        return;
    }
    __weak UITableView *table = tableView;
    __weak ClassList *c = _dataArray[indexPath.row];
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"classNames = %@ and classId = %@",c.classNames,c.classId];
    // 删除之前需要先查询 找了那个对象才能执行删除的操作
    [CoreDataManager executeFetchRequest:[ClassList class] predicate:predicate complete:^(NSArray *array, NSError *error) {
        if (array && array.count>0) {
            // 取出结果数组里的模型 并删除 然后保存上下文
            for (ClassList *c in array) {
                [CoreDataManager deleteObject:c];
            }
            NSError *error = nil;
            // 保存上下文就存储数据
            [CoreDataManager save:&error];
            if (!error) {
                [_dataArray removeObject:c];
            }
            //移除tableView中的数据
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 1;
//}

- (void)createFile:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileName error:nil];
    
    if (![fileManager createFileAtPath:fileName contents:nil attributes:nil]) {
        NSLog(@"不能创建文件");
    }
    
}

- (void)exportCSV:(NSString *)fileName {
    NSOutputStream *output = [[NSOutputStream alloc] initToFileAtPath:fileName append:YES];
    [output open];
    if (![output hasSpaceAvailable]) {
        NSLog(@"没有足够可用空间");
    } else {
        
        NSString *header = @"学号,姓名,手机号,性别,班级\n";
        const uint8_t *headerString = (const uint8_t *)[header cStringUsingEncoding:NSUTF8StringEncoding];
        NSInteger headerLength = [header lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        NSInteger result = [output write:headerString maxLength:headerLength];
        if (result <= 0) {
            NSLog(@"写入错误");
        }
        
        for (StudentModel *stu in dataStuArray) {
            
            NSString *row = [NSString stringWithFormat:@"%@,%@,%@,%@,%@\n", stu.stuNote, stu.stuNames,stu.stuPhone,stu.stuSex,classNames];
            const uint8_t *rowString = (const uint8_t *)[row cStringUsingEncoding:NSUTF8StringEncoding];
            NSInteger rowLength = [row lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            result = [output write:rowString maxLength:rowLength];
            if (result <= 0) {
                NSLog(@"无法写入内容");
            }
        }
        [output close];
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
    // 获取所有班级列表
    [CoreDataManager executeFetchRequest:[ClassList class] predicate:nil complete:^(NSArray *array, NSError *error)
     {
         [_dataArray removeAllObjects];
         if (array && array.count>0) {
             for (ClassList *c in array) {
                 [_dataArray addObject:c];
             }
             [_tableView reloadData];
         }
     }];
}

/**
 *   从数据库读取数据
 */
- (void)loadStudentDatasByClassId:(NSNumber*)classId
{
    
    // 设置查询条件 通过用户名 和 id 来约束查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"classId = %@",classId];
    //获取所有班级列表
    [CoreDataManager executeFetchRequest:[StudentModel class] predicate:predicate complete:^(NSArray *array, NSError *error)
     {
         [dataStuArray removeAllObjects];
         if (array && array.count > 0) {
             for (StudentModel *stu in array) {
                 [dataStuArray addObject:stu];
             }
         }
     }];
}

@end
