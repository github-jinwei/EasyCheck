//
//  JWShareContentView.h
//  EasyCheck
//
//  Created by jinwei on 16/5/24.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWShareContentView;
@protocol JWShareContentViewDelegate <NSObject>

@optional
- (void)shareContentView:(JWShareContentView*)view didSelectedButtonIndex:(NSInteger)buttonIndex;

@end

@interface JWShareContentView : UIView

@property(nonatomic, assign) id<JWShareContentViewDelegate> delegate;
@property (strong, nonatomic) UILabel *titleLabel;

- (id) initActivity:(BOOL)isActivity;

@end
