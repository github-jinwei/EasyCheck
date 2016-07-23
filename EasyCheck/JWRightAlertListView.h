//
//  JWRightAlertListView.h
//  EasyCheck
//
//  Created by jinwei on 16/5/14.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWRightAlertListViewDelegate <NSObject>

@optional
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef void(^dismissWithOperation)();

@interface JWRightAlertListView : UIView
@property (nonatomic, weak) id<JWRightAlertListViewDelegate> delegate;
@property (nonatomic, strong) dismissWithOperation dismissOperation;

//初始化方法
//传入参数：模型数组，弹出原点，宽度，高度（每个cell的高度）
- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height;

//弹出
- (void)pop;
//消失
- (void)dismiss;

@end

@interface RightAlertListCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

- (instancetype)initWithTitle:(NSString *)title;

@end
