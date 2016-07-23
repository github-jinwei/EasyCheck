//
//  ListTableViewCell.m
//  EasyCheck
//
//  Created by JinWei on 16/4/22.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "ListTableViewCell.h"
#import "Masonry.h"
#import "CodeFragments.h"
#import "GlobalDefinition.h"
#import "ClassList.h"

@implementation ListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type
{
    self = [super initWithStyle:style reuseIdentifier:type];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(self) wSelf = self;
        wSelf.contentCellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        wSelf.contentCellView.backgroundColor = [UIColor whiteColor];
        [wSelf.contentView addSubview:wSelf.contentCellView];
        
        
        //班级logo
        wSelf.listLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 35)];
        wSelf.listLogoImageView.clipsToBounds = YES;
        [wSelf.contentCellView addSubview:wSelf.listLogoImageView];
        
        //班级名称
        wSelf.listNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 20)];
        wSelf.listNameLabel.font = [UIFont systemFontOfSize:14];
        
        [wSelf.contentCellView addSubview:wSelf.listNameLabel];
        
        //班级备注
        wSelf.listNoteNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 35, 100, 20)];
        wSelf.listNoteNameLabel.font = [UIFont systemFontOfSize:13];
        [wSelf.contentCellView addSubview:wSelf.listNoteNameLabel];
         wSelf.listNoteNameLabel.backgroundColor = [UIColor clearColor];
        wSelf.listNoteNameLabel.textColor = [UIColor grayColor];
        
        //创建时间
        wSelf.listTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 6, 70, 20)];
        [wSelf.contentCellView addSubview:wSelf.listTimeLabel];
        wSelf.listTimeLabel.font = [UIFont systemFontOfSize:13];
        wSelf.listTimeLabel.textColor = [UIColor grayColor];
        
        //线
        self.lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 60, SCREEN_WIDTH, 0.5)];
        _lineImageV.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.7];
        [self.contentCellView addSubview:_lineImageV];
        
    }
    return  self;
    
}

+ (id)listCellWithReuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type{
    return [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier andType:type];
}

- (void)drawCellWithData:(ClassList *)classListModel{
    self.listLogoImageView.image = [UIImage imageNamed:@"note_list_icon"];
    self.listNameLabel.text = classListModel.classNames;
    self.listNoteNameLabel.text =classListModel.classNote;
    self.listTimeLabel.text = classListModel.createTime;
}



-(void)dealloc{
    self.listLogoImageView = nil;
    self.listNameLabel = nil;
    self.listNoteNameLabel = nil;
    self.listTimeLabel = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
