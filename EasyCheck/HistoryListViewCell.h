//
//  JWHistoryListViewCell.h
//  EasyCheck
//
//  Created by jinwei on 16/5/15.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryModel;

@interface HistoryListViewCell : UITableViewCell

@property (nonatomic, strong)UIView *contentCellView;//cellview

@property (nonatomic, strong)UIView *dataView; //日期view
@property (nonatomic, strong)UILabel *dataLabel;//日期

@property (nonatomic, strong)UIView *timeView;//时间view
@property (nonatomic, strong)UILabel *timeLabel;// 时间

@property (nonatomic, strong)UIView *classNameView;//班级名称view
@property (nonatomic, strong)UILabel *classNameLabel;//班级名称

@property (nonatomic, strong)UIImageView *arrowImageView;//箭头

@property (nonatomic, strong)UIView *line1VerticalView;//竖线1
@property (nonatomic, strong)UIView *line2VerticalView;//竖线2

@property (nonatomic, strong)UIView *line1HorizonalView;//横线1
@property (nonatomic, strong)UIView *line2HorizonalView;//横线2。

//初始化cell
+ (id)historyListCellWithReuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type;
///给cell赋值
- (void)drawCellWithData:(HistoryModel *)historyModel;

@end
