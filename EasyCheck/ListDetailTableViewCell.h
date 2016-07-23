//
//  ListDetailTableViewCell.h
//  EasyCheck
//
//  Created by JinWei on 16/5/8.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StudentModel;
@class HistoryDetailModel;

@interface ListDetailTableViewCell : UITableViewCell

@property (nonatomic, strong)UIView *contentCellView;

@property (nonatomic, strong)UIView *numberView; //序号
@property (nonatomic, strong)UILabel *numberLabel;

@property (nonatomic, strong)UIImageView *leaveImageView;
@property (nonatomic, strong)UILabel *leaveLabel;

@property (nonatomic, strong)UIImageView *absenceImageView;
@property (nonatomic, strong)UILabel *absenceLabel;

@property (nonatomic, strong)UIImageView *attentImageView;
@property (nonatomic, strong)UILabel *attentLabel;

@property (nonatomic, strong)UIImageView *arrowImageView;

@property (nonatomic, strong)UILabel *studentNameLabel;
@property (nonatomic, strong)UILabel *studentNoteLabel;

@property (nonatomic, strong)UIImageView *lineImageV;//线。

//初始化cell
+ (id)stuListCellWithReuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type;
///给cell赋值
- (void)drawCellWithData:(StudentModel *)studentModel;

///给cell赋值
- (void)drawCellWithDataByHistoryDetailModel:(HistoryDetailModel *)historyDetailModel;

@end
