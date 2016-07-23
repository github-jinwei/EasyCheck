//
//  JWRootViewViewController.h
//  EasyCheck
//
//  Created by JinWei on 16/4/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWBaseViewController.h"

#import "JWStatisticsViewController.h"
#import "JWListViewController.h"
#import "JWHistoryViewController.h"
#import "JWSettingViewController.h"

@interface JWRootViewViewController : JWBaseViewController

@property(nonatomic, strong)UITabBarController *tabbarVC;

@end

