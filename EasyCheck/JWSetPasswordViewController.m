//
//  JWSetPasswordViewController.m
//  EasyCheck
//
//  Created by jinwei on 16/5/16.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWSetPasswordViewController.h"
#import "JWSettingItem.h"
#import "JWSettingArrowItem.h"
#import "JWSettingSwitchItem.h"
#import "JWSettingGroup.h"
#import "JWSettingCell.h"
#import "CodeFragments.h"
#import "JWLockController.h"

@interface JWSetPasswordViewController()

@property(nonatomic,strong)NSMutableArray *data;

@end

@implementation JWSetPasswordViewController

@dynamic data;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名单";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d3d2d7" alpha:0.6];
    
    [self setupGroup0];
    
    [self setupGroup1];
    
}

- (void)setupGroup0{
    //0组
    JWSettingItem *setPasswordName = [JWSettingSwitchItem itemwithTitle:@"密码设置"];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults boolForKey:@"密码设置"] == 1) {
//        JWLockController *lockC = [[JWLockController alloc] init];
//        lockC.resetpassword = NO;
//        [self presentViewController:lockC animated:YES completion:nil];
//    } else {
//       
//    }

    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    
    group0.items=@[setPasswordName];
    [self.data addObject:group0];
}

- (void)setupGroup1{
    //0组
    
    JWSettingItem *modifyName = [JWSettingArrowItem itemwithTitle:@"修改密码"];
    
        modifyName.option = ^{
            JWLockController *lockController = [[JWLockController alloc] init];
            lockController.resetpassword = YES;
            [self presentViewController:lockController animated:YES completion:nil];
        };
    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    group0.items=@[modifyName];
    [self.data addObject:group0];
}

@end
