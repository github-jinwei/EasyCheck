//
//  JWBaseViewController.h
//  EasyCheck
//
//  Created by JinWei on 16/4/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeFragments.h"
#import "Masonry.h"
#import "GlobalDefinition.h"


@class JWRootViewViewController;
@interface JWBaseViewController : UIViewController

//系统的导航条是否显示为透明（YES:透明, NO:不透明）default is NO.
@property(nonatomic, assign)BOOL        translucentNavigationBar;

//是否隐藏系统的 navigationBar (YES:隐藏， NO：不隐藏) default is NO.
@property(nonatomic, assign)BOOL        hideNavigationBar;

@property(nonatomic, assign)BOOL        showBottomBar;

@property(nonatomic, strong)UIView      *networkInavailableView;


/// 下个页面的返回按钮------（传空格就是只有一个箭头）
-(void)baseNextPageTitleButton:(NSString *)nextPageTitleString;
/// 导航栏右上角的按钮公用的方法-----尽量不要自己写了，避免位置不统一，影响navigation.titleView的位置。导致不居中。
- (void)rightButtonWithName:(NSString *)name image:(NSString *)imageString block:(void(^)(UIButton *btn))block;

/**
 *  导航栏右边按钮---靠右边的
 *
 *  @param name        按钮名称
 *  @param imageString 按钮图片
 *  @param block       返回导航栏右边按钮
 */
- (void)rightButtonWithNameRight:(NSString *)name image:(NSString *)imageString block:(void(^)(UIButton *btn))block;

@end
