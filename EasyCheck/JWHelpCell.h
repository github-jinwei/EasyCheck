//
//  JWHelpCell.h
//  EasyCheck
//
//  Created by jinwei on 16/5/28.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWHelp;
@interface JWHelpCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic, strong) JWHelp *helpData;

@end
