//
//  ListTableViewCell.h
//  EasyCheck
//
//  Created by JinWei on 16/4/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassList;
@interface ListTableViewCell : UITableViewCell

@property (nonatomic, strong)UIView*         contentCellView;
@property (nonatomic, strong)UIImageView*    listLogoImageView;
@property (nonatomic, strong)UILabel*        listNameLabel;
@property (nonatomic, strong)UILabel*        listNoteNameLabel;
@property (nonatomic, strong)UILabel*        listTimeLabel;
@property (nonatomic, strong)UIImageView*    lineImageV;//线。
@property (nonatomic, assign)BOOL            needTotalSizeLine;

//初始化cell
+ (id)listCellWithReuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type;
///给cell赋值
- (void)drawCellWithData:(ClassList *)classListModel;

@end
