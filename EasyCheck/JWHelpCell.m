//
//  JWHelpCell.m
//  EasyCheck
//
//  Created by jinwei on 16/5/28.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWHelpCell.h"
#import "JWHelp.h"

@implementation JWHelpCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"friend";
    JWHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JWHelpCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setHelpData:(JWHelp *)helpData
{
    _helpData = helpData;
    
    self.textLabel.text = helpData.content;
    self.textLabel.font = [UIFont systemFontOfSize:8];
    self.textLabel.numberOfLines = 0;
    
}

@end
