//
//  LLViewController.m
//  LUITabBarViewController
//
//  Created by JinWei on 16/4/22.
//  Copyright (c) 2013年 Oran Wu. All rights reserved.
//

#import "JWListViewController.h"
#import "ListTableViewCell.h"
#import "CodeFragments.h"
#import "GlobalDefinition.h"
#import "JWAddListViewController.h"
#import "CoreDataManager.h"
#import  "ClassList.h"
#import "JWListDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

#define TableCellHeight     60.0

@interface JWListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    ListTableViewCell *_cell;
    UITableView *_tableView;
    
     NSMutableArray *_dataArray; // 数据源数组
}
@end

@implementation JWListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"名单";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClassList)];
    [addBarButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = addBarButton;
    _dataArray = [NSMutableArray array];
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
        //[_tableView reloadData];
    }

}

//添加班级
- (void)addClassList{
    
    JWAddListViewController *addListVC = [[JWAddListViewController alloc] init];
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;//可更改为其他方式
    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.duration = 0.5;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:addListVC animated:NO];
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
        _cell = [ListTableViewCell listCellWithReuseIdentifier:CellIdentifier andType:nil];
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
     ClassList *p = _dataArray[indexPath.row];
    [_cell drawCellWithData:p];
    
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
    JWListDetailViewController *listDetailVC =  [[JWListDetailViewController alloc] init];
    listDetailVC.classId = c.classId;
    listDetailVC.classNames = c.classNames;
    [self.navigationController pushViewController:listDetailVC animated:YES];
    
    
    //AddFriendViewController *addVC = [[AddFriendViewController alloc]  init];
    //addVC.type = UploadFriend;
    //addVC.people = p;
    //[self.navigationController pushViewController:addVC animated:YES];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
