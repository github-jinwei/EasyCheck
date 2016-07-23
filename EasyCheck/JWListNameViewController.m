//
//  JWListNameViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/15.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWListNameViewController.h"
#import "JWSettingItem.h"
#import "JWSettingArrowItem.h"
#import "JWSettingSwitchItem.h"
#import "JWSettingGroup.h"
#import "JWSettingCell.h"
#import "CodeFragments.h"

#import "JWModifyListNameViewController.h"
#import "JWShareListNameViewController.h"
#import "JWStatisticsListNameViewController.h"

@interface JWListNameViewController()

@property(nonatomic,strong)NSMutableArray *data;

@end

@implementation JWListNameViewController

@dynamic data;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名单";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d3d2d7" alpha:0.6];
    
    [self setupGroup0];
    
}

- (void)setupGroup0{
    //0组
    JWSettingItem *modifyListName = [JWSettingArrowItem itemwithTitle:@"修改名单" destVcClass:[JWModifyListNameViewController class]];
    
    JWSettingItem *shareListName = [JWSettingArrowItem itemwithTitle:@"名单分享" destVcClass:[JWShareListNameViewController class]];
    
    JWSettingItem *statisticListName = [JWSettingArrowItem itemwithTitle:@"统计名单" destVcClass:[JWStatisticsListNameViewController class]];
    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    group0.items=@[modifyListName,shareListName,statisticListName];
    [self.data addObject:group0];
}

@end
