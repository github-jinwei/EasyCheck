//
//  JWFoldListView.h
//  EasyCheck
//
//  Created by jinwei on 16/5/14.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JWFoldListView;
@protocol JWFoldListViewDelegate <NSObject>

-(void)JWFoldListView:(JWFoldListView*)foldListView didSelectObject:(id)obj;

@end

//按钮的样式,图片在左侧和在右侧两种
typedef NS_ENUM(NSInteger,FoldListViewType) {
    FoldListViewTypeNormal = 0,//
    FoldListViewRight  = 1,//图片在右
};

//block 回调返回选中结果
typedef void(^JWFoldListViewBlock)(id obj);

@interface JWFoldListView : UIView

/** 设置按钮的样式 */
@property (assign,nonatomic)FoldListViewType foldListViewType;

/** 设置按钮标题字号 */
@property (assign,nonatomic)CGFloat jwTitleFontSize;
/** 选择后是否改变title为选择的内容,默认YES */
@property (assign,nonatomic)BOOL jwTitleChanged;
/** 按钮的选中状态 */
@property (assign,nonatomic,readonly)BOOL jwSelected;
/** 设置按钮的代理 */
@property (weak,nonatomic) id <JWFoldListViewDelegate> jwDelegate;
/** 以block形式回调选中结果 */
@property (copy,nonatomic) JWFoldListViewBlock jwResultBlock;

#pragma mark - 以下是设置展开后的下拉列表相关信息
/** 设置展开的视图背景色 */
@property (strong,nonatomic)UIColor *jwColor;
/** 设置展开后的视图透明度 */
@property (assign,nonatomic)CGFloat jwAlpha;

/** 设置下拉列表文字大小 */
@property (assign,nonatomic)CGFloat jwFontSize;
/** 设置下拉列表文字颜色 */
@property (strong,nonatomic)UIColor *jwFontColor;
/** 展开cell的高度 默认44*/
@property (assign,nonatomic)CGFloat jwHeight;


/**
 *
 *  按钮的初始化方法
 *
 *  @param frame frame
 *  @param dataArray 需要在列表显示的数据源
 *
 *  @return 返回初始化的对象
 */
-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray<NSString *> *)dataArray;

/** 外部关闭列表的方法 */
- (void)jwCloseTable;

/** 外部打开列表的方法 */
- (void)jwOpenTable;

/** 设置按钮的标题 */
- (void)jwSetTitle:(NSString*)title forState:(UIControlState)state;
/** 设置按钮的标题颜色 */
-(void)jwSetTitleColor:(UIColor*)color forState:(UIControlState)state ;
/** 设置按钮的背景图片 */
- (void)jwSetBackgroundImage:(UIImage *)image forState:(UIControlState)state;
/** 设置按钮的图片 */
- (void)jwSetImage:(UIImage *)image forState:(UIControlState)state;


@end
