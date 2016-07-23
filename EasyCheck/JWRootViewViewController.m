//
//  JWRootViewViewController.m
//  EasyCheck
//
//  Created by JinWei on 16/4/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWRootViewViewController.h"

@interface JWRootViewViewController ()
@end

@implementation JWRootViewViewController

- (id)init{
    if(self = [super init]){
        self.tabbarVC = [[UITabBarController alloc] init];
        
        JWListViewController *ListVC = [[JWListViewController alloc] init];
        JWStatisticsViewController *StatisticsVC = [[JWStatisticsViewController alloc] init];
        JWHistoryViewController *HistoryVC = [[JWHistoryViewController alloc] init];
        JWSettingViewController *SettingVC = [[JWSettingViewController alloc] init];
        
        
        UINavigationController *ListNav = [[UINavigationController alloc] initWithRootViewController:ListVC];
        UINavigationController *StatisticsNav = [[UINavigationController alloc] initWithRootViewController:StatisticsVC];
        UINavigationController *HistoryNav = [[UINavigationController alloc] initWithRootViewController:HistoryVC];
        UINavigationController *SettingNav = [[UINavigationController alloc] initWithRootViewController:SettingVC];
        self.tabbarVC.viewControllers = [NSArray arrayWithObjects:ListNav, StatisticsNav,HistoryNav,SettingNav, nil];
        
        //把ListNav StatisticsNav生成一个数组，赋值给tabbarVC.viewControllers
        
        UITabBar *tabBar = self.tabbarVC.tabBar;
        UITabBarItem *aTabBarItem = [tabBar.items objectAtIndex:0];
        UITabBarItem *bTabBarItem = [tabBar.items objectAtIndex:1];
        UITabBarItem *cTabBarItem = [tabBar.items objectAtIndex:2];
        UITabBarItem *dTabBarItem = [tabBar.items objectAtIndex:3];
        
        aTabBarItem.title = @"名单";
        bTabBarItem.title = @"统计";
        cTabBarItem.title = @"历史";
        dTabBarItem.title = @"设置";
        
        [aTabBarItem setSelectedImage:[UIImage imageNamed:@"tab_list_icon"]];
        [aTabBarItem setImage:[UIImage imageNamed:@"tab_list_select_icon"]];
        [bTabBarItem setSelectedImage:[UIImage imageNamed:@"tab_statistics_icon"]];
        [bTabBarItem setImage:[UIImage imageNamed:@"tab_statistics_select_icon"]];
        [cTabBarItem setSelectedImage:[UIImage imageNamed:@"tab_history_icon"]];
        [cTabBarItem setImage:[UIImage imageNamed:@"tab_history_select_icon"]];
        [dTabBarItem setSelectedImage:[UIImage imageNamed:@"tab_setting_icon"]];
        [dTabBarItem setImage:[UIImage imageNamed:@"tab_setting_icon"]];
        
        UIColor *titleHighlightedColor = [UIColor colorFromHexString:@"18b89f"];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           titleHighlightedColor, NSForegroundColorAttributeName,
                                                           nil,nil] forState:UIControlStateHighlighted];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
