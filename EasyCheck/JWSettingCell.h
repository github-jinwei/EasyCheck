//
//  JWSettingCell.h
//  Easy Check
//
//  Created by jin on 15-12-9.
//  Copyright (c) 2015年 nciae. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWSettingItem;

@interface JWSettingCell : UITableViewCell

@property(nonatomic,strong)JWSettingItem *item;


+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
