//
//  JWSettingViewController.m
//  EasyCheck
//
//  Created by JinWei on 16/4/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWSettingViewController.h"
#import "JWSettingItem.h"
#import "JWSettingArrowItem.h"
#import "JWSettingSwitchItem.h"
#import "JWSettingGroup.h"
#import "JWSettingCell.h"
#import "CodeFragments.h"

#import "JWListNameViewController.h"
#import "JWQRCodeListNameViewController.h"
#import "JWQRCodeAddListNameViewController.h"
#import "JWDocumentLibraryViewController.h"
#import "JWSetPasswordViewController.h"
#import "JWShareFriendViewController.h"
#import "JWHelpViewController.h"
#import "JWAboutUsViewController.h"
#import "JWVipUserViewController.h"



@interface JWSettingViewController ()

@property(nonatomic,strong)NSMutableArray *data;

@end

@implementation JWSettingViewController

@dynamic data;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorFromHexString:@"d3d2d7" alpha:0.6];
    
    [self setupGroup0];
    
    [self setupGroup1];
    
    [self setupGroup2];
    
    [self setupGroup3];
    
    [self setupGroup4];
    
    [self setupGroup5];
    
}

//第0组数据
-(void)setupGroup0
{
    //0组
    JWSettingItem *listName = [JWSettingArrowItem itemwithIcon:@"set_list_name_icon" title:@"名单"  destVcClass:[JWListNameViewController class]];
    
    JWSettingItem *qrListName = [JWSettingArrowItem itemwithIcon:@"set_qr_code_list_name_icon" title:@"二维码名单"  destVcClass:[JWQRCodeListNameViewController class]];
    
    JWSettingItem *qrAddListName = [JWSettingArrowItem itemwithIcon:@"set_qr_code_add_list_name_icon" title:@"扫一扫添加名单"  destVcClass:[JWQRCodeAddListNameViewController class]];
    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    group0.items=@[listName,qrListName,qrAddListName];
    [self.data addObject:group0];
}

- (void)setupGroup1 {
    //0组
    JWSettingItem *documentLibraryName = [JWSettingArrowItem itemwithIcon:@"set_document_library_icon" title:@"我的文件库"  destVcClass:[JWDocumentLibraryViewController class]];
    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    group0.items=@[documentLibraryName];
    [self.data addObject:group0];
}


- (void)setupGroup2 {
    JWSettingItem *passwordName = [JWSettingArrowItem itemwithIcon:@"set_password_icon" title:@"启动时需要密码"  destVcClass:[JWSetPasswordViewController class]];
    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    group0.items=@[passwordName];
    [self.data addObject:group0];

}

- (void)setupGroup3 {
    JWSettingItem *shareFriendName = [JWSettingArrowItem itemwithIcon:@"set_share_friend_icon" title:@"分享给好友"];
    shareFriendName.option = ^{
        // 新分享控件
        //[self showShareView];
    };
    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    group0.items=@[shareFriendName];
    [self.data addObject:group0];
}


- (void)setupGroup4 {
    JWSettingItem *helpName = [JWSettingArrowItem itemwithIcon:@"set_help_icon" title:@"帮助文档"  destVcClass:[JWHelpViewController class]];
    
    JWSettingItem *aboutUsName = [JWSettingArrowItem itemwithIcon:@"set_about_us_icon" title:@"关于我们"  destVcClass:[JWAboutUsViewController class]];
    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    group0.items=@[helpName,aboutUsName];
    [self.data addObject:group0];
}

- (void)setupGroup5 {
    JWSettingItem *vipName = [JWSettingArrowItem itemwithIcon:@"set_vip_user_icon" title:@"高级用户"  destVcClass:[JWShareFriendViewController class]];
    
    JWSettingGroup *group0 = [[JWSettingGroup alloc] init];
    group0.items=@[vipName];
    [self.data addObject:group0];
}

////第1组数据
//-(void)setupGroup1
//{
//    
//    //1组
//    JWSettingItem *update=[JWSettingItem itemwithIcon:@"MoreUpdate" title:@"检查新版本" ];
//    update.option=^{
//        [MBProgressHUD showMessage:@"正在拼命检查中..."];
//        
//        //几秒后消失
//        double delayInSeconds = 1.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            //移除HID
//            [MBProgressHUD hideHUD];
//            
//            //提醒有没有新版本
//            [MBProgressHUD showError:@"没有新版本"];
//        });
//    };
//    JWSettingItem *help=[JWSettingArrowItem itemwithIcon:@"MoreHelp" title:@"帮助"  destVcClass:[JWHelpViewController class]];
//    JWSettingItem *shate=[JWSettingArrowItem itemwithIcon:@"MoreShare" title:@"分享"  destVcClass:[JWShareViewController class]];
//    
//    JWSettingItem *ViewMsg=[JWSettingArrowItem itemwithIcon:@"MoreMessage" title:@"查看消息"  destVcClass:[JWAboutViewController class]];
//    
//    JWSettingItem *product=[JWSettingArrowItem itemwithIcon:@"handShake" title:@"产品推荐"  destVcClass:[JWProductViewController class]];
//    
//    JWSettingItem *about=[JWSettingArrowItem itemwithIcon:@"MoreAbout" title:@"关于"  destVcClass:[JWAboutViewController class]];
//    
//    
//    JWSettingGroup *group1=[[JWSettingGroup alloc]init];
//    group1.items=@[update,help,shate,ViewMsg,product,about];
//    
//    [self.data addObject:group1];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
