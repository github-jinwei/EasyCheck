//
//  JWHistoryListViewCell.m
//  EasyCheck
//
//  Created by jinwei on 16/5/15.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "HistoryListViewCell.h"
#import "GlobalDefinition.h"
#import "HistoryModel.h"
#import "CodeFragments.h"

@implementation HistoryListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  andType:(NSString *)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) wSelf = self;
        
        //内容
        wSelf.contentCellView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        wSelf.contentCellView.backgroundColor = [UIColor whiteColor];
        wSelf.contentCellView.userInteractionEnabled = YES;
        [wSelf.contentView addSubview:wSelf.contentCellView];
        
        //日期
        wSelf.dataView = [[UIView alloc] initWithFrame:CGRectMake(14, 24, 18, 15)];
        wSelf.dataView.backgroundColor = [UIColor colorFromHexString:@"2ab2f5" alpha:1];
        wSelf.dataView.layer.cornerRadius = 4;
        [wSelf.contentView addSubview:wSelf.dataView];
        
        wSelf.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
        wSelf.dataLabel.textColor = [UIColor whiteColor];
        wSelf.dataLabel.text = @"1";
        wSelf.dataLabel.textAlignment = NSTextAlignmentCenter;
        wSelf.dataLabel.font = [UIFont systemFontOfSize:12];
        [wSelf.dataView addSubview:wSelf.dataLabel];
    
        //竖线1
        wSelf.line1VerticalView = [[UIImageView alloc]initWithFrame:CGRectMake(22.5, 0, 1, 24)];
        wSelf.line1VerticalView.backgroundColor = [UIColor colorFromHexString:@"2ab2f5" alpha:1];
        [self.contentCellView addSubview:wSelf.line1VerticalView];
        
        //竖线2
        wSelf.line2VerticalView = [[UIImageView alloc]initWithFrame:CGRectMake(22.5, 39, 1, 22)];
        wSelf.line2VerticalView.backgroundColor = [UIColor colorFromHexString:@"2ab2f5" alpha:1];
        [self.contentCellView addSubview:wSelf.line2VerticalView];
        
        //时间
        wSelf.timeView = [[UIView alloc] initWithFrame:CGRectMake(55, 24, 30, 15)];
        wSelf.timeView.backgroundColor = [UIColor colorFromHexString:@"fcfcfc" alpha:1];
        wSelf.timeView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        wSelf.timeView.layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        wSelf.timeView.layer.shadowOpacity = 0.1;//阴影透明度，默认0
        wSelf.timeView.layer.shadowRadius = 0.2;//阴影半径，默认3
        wSelf.timeView.layer.cornerRadius = 2;
        [wSelf.contentView addSubview:wSelf.timeView];
        
        wSelf.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 30, 15)];
        //wSelf.timeLabel.textColor = [UIColor whiteColor];
        wSelf.timeLabel.textAlignment = NSTextAlignmentCenter;
        wSelf.timeLabel.text = @"10:18";
        wSelf.timeLabel.font = [UIFont systemFontOfSize:8];
        [wSelf.timeView addSubview:wSelf.timeLabel];
        
        //横线1
        wSelf.line1HorizonalView = [[UIImageView alloc]initWithFrame:CGRectMake(33, 30, 21, 1)];
        wSelf.line1HorizonalView.backgroundColor = [UIColor colorFromHexString:@"2ab2f5" alpha:1];
        [self.contentCellView addSubview:wSelf.line1HorizonalView];
        
        //横线2
        wSelf.line2HorizonalView = [[UIImageView alloc]initWithFrame:CGRectMake(85, 30, 30, 1)];
        wSelf.line2HorizonalView.backgroundColor = [UIColor colorFromHexString:@"2ab2f5" alpha:1];
        [self.contentCellView addSubview:wSelf.line2HorizonalView];
        
        //班级名称
        wSelf.classNameView = [[UIView alloc] initWithFrame:CGRectMake(115, 10, 150, 40)];
        wSelf.classNameView.backgroundColor = [UIColor colorFromHexString:@"fcfcfc" alpha:1];
        wSelf.classNameView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        wSelf.classNameView.layer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3)
        wSelf.classNameView.layer.shadowOpacity = 0.1;//阴影透明度
        wSelf.classNameView.layer.shadowRadius = 0.2;//阴影半径
        wSelf.classNameView.layer.cornerRadius = 2;
        [wSelf.contentView addSubview:wSelf.classNameView];
        
        wSelf.classNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wSelf.classNameView.width, wSelf.classNameView.height)];
        wSelf.classNameLabel.text = @"软件工程1班";
        wSelf.classNameLabel.textAlignment = NSTextAlignmentCenter;
        wSelf.classNameLabel.font = [UIFont systemFontOfSize:16];
        [wSelf.classNameView addSubview:wSelf.classNameLabel];
        
        wSelf.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, wSelf.contentCellView.center.y - 10, 16, 16)];
        wSelf.arrowImageView.image = [UIImage imageNamed:@"stu_arrow_icon"];
        [wSelf.contentCellView addSubview:wSelf.arrowImageView];
        
//        UIImageView  *lineImageV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 60, SCREEN_WIDTH, 0.5)];
//        lineImageV.backgroundColor = [UIColor colorFromHexString:@"ffffff" alpha:1];
//        [self.contentCellView addSubview:lineImageV];
        
    }
    return  self;
}

+ (id)historyListCellWithReuseIdentifier:(NSString *)reuseIdentifier andType:(NSString *)type{
    return [[HistoryListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier andType:type];
}

- (void)drawCellWithData:(HistoryModel *)historyModel{
    self.dataLabel.text = [NSString stringWithFormat:@"%@",[historyModel.createTime dateWithFormat:@"dd"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[historyModel.createTime dateWithFormat:@"HH:mm"]];
    self.classNameLabel.text = historyModel.classNames;
    
}


-(void)dealloc{
    self.dataLabel = nil;
    self.timeLabel = nil;
    self.classNameLabel = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
