//
//  ListDetailTableViewCell.m
//  EasyCheck
//
//  Created by JinWei on 16/5/8.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "ListDetailTableViewCell.h"
#import "GlobalDefinition.h"
#import "StudentModel.h"
#import "HistoryDetailModel.h"
#import "CodeFragments.h"
#import "UIView+Utils.h"

@implementation ListDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         __weak typeof(self) wSelf = self;
       
        wSelf.contentCellView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        wSelf.contentCellView.backgroundColor = [UIColor whiteColor];
        wSelf.contentCellView.userInteractionEnabled = YES;
        [wSelf.contentView addSubview:wSelf.contentCellView];
        
        //序号
        wSelf.numberView = [[UIView alloc] initWithFrame:CGRectMake(10,24, 15, 15)];
        wSelf.numberView.backgroundColor = [UIColor colorFromHexString:@"8abaf4" alpha:0.5];
        wSelf.numberView.layer.cornerRadius = 2;
        [wSelf.contentView addSubview:wSelf.numberView];
        
        wSelf.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 15, 15)];
        wSelf.numberLabel.textColor = [UIColor whiteColor];
        wSelf.numberLabel.text = @"1";
        wSelf.numberLabel.font = [UIFont systemFontOfSize:11];
        [wSelf.numberView addSubview:wSelf.numberLabel];
        
        
        //学生名
        wSelf.studentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 20)];
        wSelf.studentNameLabel.font = [UIFont systemFontOfSize:16];
        [wSelf.contentCellView addSubview:wSelf.studentNameLabel];
        
        //学号
        wSelf.studentNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 35, 100, 20)];
        wSelf.studentNoteLabel.font = [UIFont systemFontOfSize:13];
        [wSelf.contentCellView addSubview:wSelf.studentNoteLabel];
        wSelf.studentNoteLabel.backgroundColor = [UIColor clearColor];
        wSelf.studentNoteLabel.textColor = [UIColor grayColor];
        
        //考勤项
        wSelf.leaveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 5, 32, 32)];
        wSelf.leaveImageView.image = [UIImage imageNamed:@"stu_leave_icon"];
        wSelf.leaveImageView.userInteractionEnabled = YES;
        [wSelf.contentCellView addSubview:wSelf.leaveImageView];
        
        wSelf.leaveLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 157, 36, 40, 20)];
        wSelf.leaveLabel.text = @"请假";
        wSelf.leaveLabel.textColor = [UIColor blackColor];
        wSelf.leaveLabel.font = [UIFont systemFontOfSize:14];
        [wSelf.contentCellView addSubview:wSelf.leaveLabel];
        
        wSelf.absenceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 5, 32, 32)];
        wSelf.absenceImageView.image = [UIImage imageNamed:@"stu_absence_icon"];
        wSelf.absenceImageView.userInteractionEnabled = YES;
        [wSelf.contentCellView addSubview:wSelf.absenceImageView];
        
        wSelf.absenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 117, 36, 40, 20)];
        wSelf.absenceLabel.text = @"缺勤";
        wSelf.absenceLabel.textColor = [UIColor blackColor];
        wSelf.absenceLabel.font = [UIFont systemFontOfSize:14];
        [wSelf.contentCellView addSubview:wSelf.absenceLabel];
        
        wSelf.attentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 5, 32, 32)];
        wSelf.attentImageView.image = [UIImage imageNamed:@"stu_attent_icon"];
        wSelf.attentImageView.userInteractionEnabled = YES;
        [wSelf.contentCellView addSubview:wSelf.attentImageView];
        
        wSelf.attentLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 77, 36, 40, 20)];
        wSelf.attentLabel.text = @"到勤";
        wSelf.attentLabel.textColor = [UIColor blackColor];
        wSelf.attentLabel.font = [UIFont systemFontOfSize:14];
        [wSelf.contentCellView addSubview:wSelf.attentLabel];
        
        wSelf.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, wSelf.contentCellView.center.y - 13, 16, 16)];
        wSelf.arrowImageView.image = [UIImage imageNamed:@"stu_arrow_icon"];
        [wSelf.contentCellView addSubview:wSelf.arrowImageView];
        
        //线
        self.lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 60, SCREEN_WIDTH, 0.5)];
        _lineImageV.backgroundColor = [UIColor colorFromHexString:@"d8d8d8" alpha:0.7];
        [self.contentCellView addSubview:_lineImageV];
        
    }
    return  self;
    
}


+ (id)stuListCellWithReuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type{
    return [[ListDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier andType:type];
}

- (void)drawCellWithData:(StudentModel *)studentModel{
    self.studentNameLabel.text = studentModel.stuNames;
    self.studentNoteLabel.text = studentModel.stuNote;

}

///给cell赋值
- (void)drawCellWithDataByHistoryDetailModel:(HistoryDetailModel *)historyDetailModel{
    self.studentNameLabel.text = historyDetailModel.stuNames;
    self.studentNoteLabel.text = historyDetailModel.stuNote;
    if (historyDetailModel.attendance.intValue == 0) {
       _leaveImageView.image = [UIImage imageNamed:@"stu_leave_sel_icon"];
    } else if (historyDetailModel.attendance.intValue == 1) {
        _absenceImageView.image = [UIImage imageNamed:@"stu_absence_sel_icon"];
    } else if (historyDetailModel.attendance.intValue ==2) {
        _attentImageView.image = [UIImage imageNamed:@"stu_attent_sel_icon"];
    }
}


-(void)dealloc{
    self.studentNameLabel = nil;
    self.studentNoteLabel = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
