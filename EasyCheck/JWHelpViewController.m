//
//  JWHelpViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/16.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWHelpViewController.h"
#import "JWHelpGroup.h"
#import "JWHelp.h"
#import "JWHeaderView.h"
#import "JWHelpCell.h"

@interface JWHelpViewController()<JWHeaderViewDelegate>
@property (nonatomic, strong) NSArray *groups;

@end

@implementation JWHelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 每一行cell的高度
    self.tableView.rowHeight = 120;
    // 每一组头部控件的高度
    self.tableView.sectionHeaderHeight = 44;
}

- (NSArray *)groups
{
    if (_groups == nil) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"helpPlist.plist" ofType:nil]];
        
        NSMutableArray *groupArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            JWHelpGroup *group = [JWHelpGroup groupWithDict:dict];
            [groupArray addObject:group];
        }
        
        _groups = groupArray;
    }
    return _groups;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JWHelpGroup *group = self.groups[section];
    
    return (group.isOpened ? group.helps.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    JWHelpCell *cell = [JWHelpCell cellWithTableView:tableView];
    
    // 2.设置cell的数据
    JWHelpGroup *group = self.groups[indexPath.section];
    
    cell.helpData = group.helps[indexPath.row];
    
    return cell;
}

/**
 *  返回每一组需要显示的头部标题(字符出纳)
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1.创建头部控件
    JWHeaderView *header = [JWHeaderView headerViewWithTableView:tableView];
    header.delegate = self;
    
    // 2.给header设置数据(给header传递模型)
    header.group = self.groups[section];
    
    return header;
}

#pragma mark - headerView的代理方法
/**
 *  点击了headerView上面的名字按钮时就会调用
 */
- (void)headerViewDidClickedNameView:(JWHeaderView *)headerView
{
    [self.tableView reloadData];
}


@end
