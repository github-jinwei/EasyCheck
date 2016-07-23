//
//  AppDelegate.m
//  EasyCheck
//
//  Created by JinWei on 16/4/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "AppDelegate.h"
//#import "JWStatisticsViewController.h"
//#import "JWListViewController.h"
//#import "JWHistoryViewController.h"
//#import "JWSettingViewController.h"
#import "JWRootViewViewController.h"
#import "JWLockController.h"
#import "CoreDataManager.h"
#import <CodeFragments.h>
#import "GlobalDefinition.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>


//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //使用数据库前必须先进行初始化工作
    [CoreDataManager initCoreDataBaseWithFileName:@"contact"];
    

    // 初始化 NavigationBar UI
    [self initializationAppearStyle];
    
//    JWListViewController *ListVC = [[JWListViewController alloc] init];
//    JWStatisticsViewController *StatisticsVC = [[JWStatisticsViewController alloc] init];
//    JWHistoryViewController *HistoryVC = [[JWHistoryViewController alloc] init];
//    JWSettingViewController *SettingVC = [[JWSettingViewController alloc] init];
//    
//    
//    UINavigationController *ListNav = [[UINavigationController alloc] initWithRootViewController:ListVC];
//    UINavigationController *StatisticsNav = [[UINavigationController alloc] initWithRootViewController:StatisticsVC];
//    UINavigationController *HistoryNav = [[UINavigationController alloc] initWithRootViewController:HistoryVC];
//    UINavigationController *SettingNav = [[UINavigationController alloc] initWithRootViewController:SettingVC];
//    
//    //把ListNav StatisticsNav生成一个数组，赋值给tabbarVC.viewControllers
//    UITabBarController *tabbarVC = [[UITabBarController alloc] init];
//    tabbarVC.viewControllers = [NSArray arrayWithObjects:ListNav, StatisticsNav,HistoryNav,SettingNav, nil];
//    
//    UITabBar *tabBar = tabbarVC.tabBar;
//    UITabBarItem *aTabBarItem = [tabBar.items objectAtIndex:0];
//    UITabBarItem *bTabBarItem = [tabBar.items objectAtIndex:1];
//    UITabBarItem *cTabBarItem = [tabBar.items objectAtIndex:2];
//    UITabBarItem *dTabBarItem = [tabBar.items objectAtIndex:3];
//    
//    aTabBarItem.title = @"名单";
//    bTabBarItem.title = @"统计";
//    cTabBarItem.title = @"历史";
//    dTabBarItem.title = @"设置";
//    
//    [aTabBarItem setSelectedImage:[UIImage imageNamed:@"tab_list_icon"]];
//    [aTabBarItem setImage:[UIImage imageNamed:@"tab_list_select_icon"]];
//    [bTabBarItem setSelectedImage:[UIImage imageNamed:@"tab_statistics_icon"]];
//    [bTabBarItem setImage:[UIImage imageNamed:@"tab_statistics_select_icon"]];
//    [cTabBarItem setSelectedImage:[UIImage imageNamed:@"tab_history_icon"]];
//    [cTabBarItem setImage:[UIImage imageNamed:@"tab_history_select_icon"]];
//    [dTabBarItem setSelectedImage:[UIImage imageNamed:@"tab_setting_icon"]];
//    [dTabBarItem setImage:[UIImage imageNamed:@"tab_setting_icon"]];
//    
//    UIColor *titleHighlightedColor = [UIColor colorFromHexString:@"18b89f"];
//    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                       titleHighlightedColor, NSForegroundColorAttributeName,
//                                                       nil,nil] forState:UIControlStateHighlighted];
    
    //设置tabbarVC 为winddow的rootViewController
    JWRootViewViewController *rootVC = [[JWRootViewViewController alloc] init];

    JWLockController *lockC = [[JWLockController alloc] init];
    lockC.resetpassword = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"密码设置"] == 1) {
        self.window.rootViewController = lockC;
    } else {
        self.window.rootViewController = rootVC.tabbarVC;
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [ShareSDK registerApp:@"易点名"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeRenren),
                            @(SSDKPlatformTypeGooglePlus)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4ef89aead0e263b8"
                                       appSecret:@"cc5ea93079f632bfa4f161260202b7f8"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeGooglePlus:
                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                            redirectUri:@"http://localhost"];
                 break;
             default:
                 break;
         }
     }];
    
    return YES;

}


#pragma mark - 初始化navigationBar样式
/**
 *  @brief  初始化Navigationbar的样式
 */
- (void)initializationAppearStyle{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexString:@"18b89f"]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]]; //顶部标题颜色
   
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]]; //底部导航栏颜色
    [[UITabBar appearance] setTintColor:[UIColor colorFromHexString:@"18b89f"]];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"background_mode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
