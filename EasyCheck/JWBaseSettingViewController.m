//
//  JWBaseSettingViewController.m
//  Easy Check
//
//  Created by jin on 15-12-8.
//  Copyright (c) 2015年 nciae. All rights reserved.
//

#import "JWBaseSettingViewController.h"
#import "JWSettingItem.h"
#import "JWSettingArrowItem.h"
#import "JWSettingSwitchItem.h"
#import "JWSettingGroup.h"
#import "JWSettingCell.h"


@interface JWBaseSettingViewController ()

@end

@implementation JWBaseSettingViewController

-(id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //backgroundView的优先级大于backgroundColor
    self.tableView.backgroundView=nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
}
-(NSArray *)data
{
    if (_data==nil) {
        
        _data = [NSMutableArray array];
    }
    return  _data;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JWSettingGroup *group = self.data[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1.创建cell
    JWSettingCell *cell=[JWSettingCell cellWithTableView:tableView];
    
    //2.给cell传递模型的数据
    JWSettingGroup *group = self.data[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    //3.返回cell
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //2.模型数据
    JWSettingGroup *group=self.data[indexPath.section];
    JWSettingItem *item=group.items[indexPath.row];
    if (item.option) {
        item.option();
    }
    //如果没有需要跳转的控制器
    if ([item isKindOfClass:[JWSettingArrowItem class]]) {
        JWSettingArrowItem *arrowItem=(JWSettingArrowItem *)item;
        
        if (arrowItem.destVcClass==nil) return;
        
        UIViewController *vc=[[arrowItem.destVcClass alloc]init];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    JWSettingGroup *group=self.data[section];
    return  group.header;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    JWSettingGroup *group=self.data[section];
    return group.footer;
}

////section头部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;//section头部高度
//}
////section头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    view.backgroundColor = [UIColor clearColor];
//    return [view autorelease];
//}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
////section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    view.backgroundColor = [UIColor clearColor];
//    return [view autorelease];
//}


@end
