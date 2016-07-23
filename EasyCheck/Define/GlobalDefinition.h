//
//  GlobalDefinition.h
//  Vodka
//
//  Created by fusunlang on 8/25/14.
//  Copyright (c) 2014 Beijing Beast Technology Co.,Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef Vodka_GlobalDefinition_h
#define Vodka_GlobalDefinition_h

#pragma mark - APP CONFIGURATION

// Apple ID
#define APPLE_ID                                @"931448360"
#define kShareSDK_AppKey                        @"f01a73632152"

// 第三方登录 - 微信
#define kWeixinAppID                        @"wx9518a9961f317f45"
#define kWechatSecretKey                    @"d4cd22c7aa4920329b6150da222c55f4"

// App 版本号.
#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// APP BUILD NUMBER.
#define APP_BUILD_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//设备的model
#define DEVICE_LOCALIZED_MODEL        [[UIDevice currentDevice]localizedModel]
//设备的model
#define DEVICE_SYSTEM_VERSION         [[[UIDevice currentDevice] systemVersion] floatValue]


#define IS_IPHONE4      (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)480 ) < DBL_EPSILON )
#define IS_IPHONE5      (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568 ) < DBL_EPSILON )
#define IS_IPHONE6      (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)667 ) < DBL_EPSILON )

#define IS_IPHONE6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)736 ) < DBL_EPSILON )
// iOS7.0及以上版本
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
// iOS8.0及以上版本
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
// iOS9.0及以上版本
#define IS_IOS9 ([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending)
#pragma mark - 尺寸


#define IPHONE4_FRAMESET    88.0

#define kOfflineCellHeight 60.0
//获取屏幕 宽度、高度
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
// 状态栏高度
#define StatusBar_HEIGHT    ([[UIApplication sharedApplication] statusBarFrame].size.height)
//NavBar高度
#define NavigationBar_HEIGHT    44
// 底部TabBar高度
#define TabBar_HEIGHT           49
#define GLOBAL_SCREEN_INDENCITY_FACTOR     (IS_IPHONE6_PLUS ? 1.5 : 1.0)
#define GLOBAL_SCRREN_WIDTH_FACTOR          (SCREEN_WIDTH / 320)


#pragma mark - 值安全检查
// 读取String检查
#define SAFE_GET_STRING(presence, key) \
([presence objectForKey: key] != nil && [presence objectForKey: key] != [NSNull null]) ? [presence objectForKey: key] : @"" \

// 检查String是否合法
#define CHECK_STRING_SAFE(val) val != nil ? [NSString stringWithFormat: @"%@", val]  : @"" \

#define SAFE_GET_NUMBER(presence, key)  \
([presence objectForKey: key] != nil && [presence objectForKey: key] != [NSNull null]) ? [presence objectForKey: key] : 0 \

#pragma mark - 字体
// Helvetica
#define FONT_Helvetica(F) [UIFont fontWithName:@"Helvetica" size:F]
// Helvetica-LIGHT
#define FONT_Helvetica_LIGHT(F) [UIFont fontWithName:@"Helvetica-light" size:F]
// Helvetica
#define FONT_Helvetica_BOLD(F) [UIFont fontWithName:@"Helvetica-bold" size:F]

#define FONT_NUMBER_BEBAS_NEUE(fontSize) [UIFont fontWithName:@"BebasNeue" size:fontSize]

#pragma mark - block使用时的安全判断
// 主线程安全判断
#define EXECUTE_BLOCK_IN_MAIN_SAFELY(block, result) {   \
    if (block) { \
        dispatch_async(dispatch_get_main_queue(), ^{    \
            block(result);                    \
        });  \
    }                                    \
}

#define ReleaseEx(x) if(x){ CFRelease(x),x=NULL;}

#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue]>=7.0)

//获得rgb颜色
#define JWColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#endif
