//
//  JWHeaderView.h
//  EasyCheck
//
//  Created by jinwei on 16/5/28.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JWHelpGroup, JWHeaderView;

@protocol JWHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(JWHeaderView *)headerView;
@end

@interface JWHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) JWHelpGroup *group;

@property (nonatomic, weak) id<JWHeaderViewDelegate> delegate;

@end
