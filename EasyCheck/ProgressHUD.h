//
//  ProgressHUD.h
//  Vodka
//
//  Created by fusunlang on 14-9-27.
//  Copyright (c) 2014年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define sheme_white

#define HUD_STATUS_FONT			[UIFont boldSystemFontOfSize:16]
#define HUD_ALPHA               0.65

#ifdef sheme_white

#define HUD_STATUS_COLOR		[UIColor whiteColor]
#define HUD_SPINNER_COLOR		[UIColor whiteColor]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithRed:0 green:0 blue:0 alpha:1]
#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"ProgressHUD.bundle/success-white.png"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"ProgressHUD.bundle/error-white.png"]
#endif

#ifdef sheme_black
#define HUD_STATUS_COLOR		[UIColor blackColor]
#define HUD_SPINNER_COLOR		[UIColor blackColor]
#define HUD_BACKGROUND_COLOR	[UIColor colorWithWhite:0.9 alpha:0.2]
#define HUD_IMAGE_SUCCESS		[UIImage imageNamed:@"ProgressHUD.bundle/success-black.png"]
#define HUD_IMAGE_ERROR			[UIImage imageNamed:@"ProgressHUD.bundle/error-black.png"]
#endif

@interface ProgressHUD : UIView

+ (ProgressHUD *)shared;

+ (void)dismiss;
///下面一行文字，上面一个loading 图  wait 传 YES
+ (void)show:(NSString *)status wait:(BOOL)wait;
///暂时一行文字。wait传 NO
+ (void)show:(NSString *)status wait:(BOOL)wait delay:(NSTimeInterval)delay;
+ (void)showSuccess:(NSString *)status;
+ (void)showSuccess:(NSString *)status delay:(NSTimeInterval)delay;
+ (void)showError:(NSString *)status;
+ (void)showError:(NSString *)status delay:(NSTimeInterval)delay;
///自己加了个延迟dismiss的方法。
+ (void)dismissDelay:(NSTimeInterval)delay;

/**
 *  展示ProgressHud
 *
 *  @param status  <#status description#>
 *  @param wait    <#wait description#>
 *  @param aEnable 背景是否可点击
 */
+ (void)show:(NSString *)status wait:(BOOL)wait enableTouchBg:(BOOL) aEnable;

/**
 *  展示ProgressHud
 *
 *  @param status  <#status description#>
 *  @param wait    <#wait description#>
 *  @param aEnable 背景是否可点击
 *  @param delay   延迟消失事件
 */
+ (void)show:(NSString *)status wait:(BOOL)wait enableTouchBg:(BOOL) aEnable delay:(NSTimeInterval)delay;

@property (atomic, strong) UIWindow *window;
@property (atomic, strong) UIToolbar *hud;
@property (atomic, strong) UIActivityIndicatorView *spinner;
@property (atomic, strong) UIImageView *image;
@property (atomic, strong) UILabel *label;
@property (atomic, strong) NSMutableArray *imageArr;//豹子的动画。

@end
