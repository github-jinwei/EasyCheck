//
//  JWAboutUsViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/16.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWAboutUsViewController.h"
#import "JWSettingItem.h"
#import "JWSettingArrowItem.h"
#import "JWSettingSwitchItem.h"
#import "JWSettingGroup.h"
#import "JWSettingCell.h"
#import "CodeFragments.h" 
#import "GlobalDefinition.h"

@interface JWAboutUsViewController()
@property(nonatomic,strong)NSMutableArray *data;

@end

@implementation JWAboutUsViewController

@dynamic data;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d3d2d7" alpha:0.6];
    
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//    headView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:headView];
    
    [self setupGroup0];

    
}

//第0组数据
-(void)setupGroup0
{
    //0组
    JWSettingItem *phoneName = [JWSettingArrowItem itemwithTitle:@"技术支持:010-2345384"];
    
    JWSettingItem *emailName = [JWSettingArrowItem itemwithTitle:@"联系我们:winp21@163.com"];
    
    JWSettingItem *qqName = [JWSettingArrowItem itemwithTitle:@"关于QQ:7654321"];
    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    group0.items=@[phoneName,emailName,qqName];
    [self.data addObject:group0];
}

@end
