//
//  JWShareContentView.m
//  EasyCheck
//
//  Created by jinwei on 16/5/24.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWShareContentView.h"
#import "CodeFragments.h"
#import "Masonry.h"
#import "UIView+Utils.h"

@implementation JWShareContentView
- (id) initActivity:(BOOL)isActivity {
    if(self = [super init]) {
        [self setBackgroundColor:[UIColor colorFromHexString:@"1A1A1A"]];
        [self initializationTitleLabel];
        [self initializationButtons:isActivity];
        
    }
    return self;
}

- (void)initializationButtons:(BOOL)isActivity{
    __weak typeof(self) wSelf = self;
    UIButton* wChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [wChatButton setImage:[UIImage imageNamed:@"share_to_wechat_session"] forState:UIControlStateNormal];
    [wChatButton setImage:[UIImage imageNamed:@"share_to_wechat_session"] forState:UIControlStateHighlighted];
    
    [wChatButton setTapActionWithBlock:^{
        if([wSelf.delegate respondsToSelector:@selector(shareContentView:didSelectedButtonIndex:)]){
            [wSelf.delegate shareContentView:wSelf didSelectedButtonIndex:0];
        }
    }];
    
    UILabel* weChatLabel = [[UILabel alloc] init];
    [weChatLabel setBackgroundColor:[UIColor clearColor]];
    [weChatLabel setTextColor:[UIColor whiteColor]];
    [weChatLabel setTextAlignment:NSTextAlignmentCenter];
    [weChatLabel setFont:[UIFont systemFontOfSize:14]];
    [weChatLabel setText:NSLocalizedString(@"微信", nil)];
    
    UIButton* weChartTimeLine = [UIButton buttonWithType:UIButtonTypeCustom];
    [weChartTimeLine setImage:[UIImage imageNamed:@"share_to_wechat_timeline"] forState:UIControlStateNormal];
    [weChartTimeLine setImage:[UIImage imageNamed:@"share_to_wechat_timeline"] forState:UIControlStateHighlighted];
    [weChartTimeLine setTapActionWithBlock:^{
        if([wSelf.delegate respondsToSelector:@selector(shareContentView:didSelectedButtonIndex:)]){
            [wSelf.delegate shareContentView:wSelf didSelectedButtonIndex:1];
        }
    }];
    
    UILabel* timeLineLabel = [[UILabel alloc] init];
    [timeLineLabel setBackgroundColor:[UIColor clearColor]];
    [timeLineLabel setTextColor:[UIColor whiteColor]];
    [timeLineLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLineLabel setFont:[UIFont systemFontOfSize:14]];
    [timeLineLabel setText:NSLocalizedString(@"朋友圈", nil)];
    
    UIButton* library = [UIButton buttonWithType:UIButtonTypeCustom];
    [library setImage:[UIImage imageNamed:@"share_save_to_local"] forState:UIControlStateNormal];
    [library setImage:[UIImage imageNamed:@"share_save_to_local"] forState:UIControlStateHighlighted];
    [library setTapActionWithBlock:^{
        if([wSelf.delegate respondsToSelector:@selector(shareContentView:didSelectedButtonIndex:)]){
            [wSelf.delegate shareContentView:wSelf didSelectedButtonIndex:2];
        }
    }];
    
    UILabel* libraryLabel = [[UILabel alloc] init];
    [libraryLabel setBackgroundColor:[UIColor clearColor]];
    [libraryLabel setTextColor:[UIColor whiteColor]];
    [libraryLabel setTextAlignment:NSTextAlignmentCenter];
    [libraryLabel setFont:[UIFont systemFontOfSize:14]];
    [libraryLabel setText:NSLocalizedString(@"本地", nil)];
    if(isActivity){
        libraryLabel.alpha = 0.0;
        library.alpha = 0.0;
        
    } else {
        
        libraryLabel.alpha = 1.0;
        library.alpha = 1.0;
    }
    [self addSubview:wChatButton];
    [self addSubview:weChatLabel];
    [self addSubview:weChartTimeLine];
    [self addSubview:timeLineLabel];
    [self addSubview:library];
    [self addSubview:libraryLabel];
    
    [wChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70.0);
        make.centerY.mas_equalTo(wSelf.mas_centerY).with.offset(0);
        make.left.equalTo(wSelf.mas_left).with.offset(0);
        make.right.equalTo(weChartTimeLine.mas_left).with.offset(0);
        make.width.equalTo(weChartTimeLine.mas_width).with.multipliedBy(1);
    }];
    
    [weChartTimeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70.0);
        make.centerY.mas_equalTo(wSelf.mas_centerY).with.offset(0);
        make.left.equalTo(wChatButton.mas_right).with.offset(0);
        make.right.equalTo(library.mas_left).with.offset(0);
        make.width.equalTo(wChatButton.mas_width).with.multipliedBy(1);
    }];
    
    [library mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.centerY.mas_equalTo(wSelf.mas_centerY).with.offset(0);
        make.left.equalTo(weChartTimeLine.mas_right).with.offset(0);
        make.right.equalTo(wSelf.mas_right).with.offset(0);
        make.width.equalTo(wChatButton.mas_width).with.multipliedBy(1);
    }];
    
    
    [weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wChatButton.mas_bottom).with.offset(5);
        make.left.equalTo(wChatButton.mas_left).with.offset(0);
        make.right.equalTo(wChatButton.mas_right).with.offset(0);
    }];
    
    [timeLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weChartTimeLine.mas_bottom).with.offset(5);
        make.left.equalTo(weChartTimeLine.mas_left).with.offset(0);
        make.right.equalTo(weChartTimeLine.mas_right).with.offset(0);
    }];
    
    [libraryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(library.mas_bottom).with.offset(5);
        make.left.equalTo(library.mas_left).with.offset(0);
        make.right.equalTo(library.mas_right).with.offset(0);
    }];
}

- (void)initializationTitleLabel{
    __weak typeof(self) wSelf = self;
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.titleLabel setText:NSLocalizedString(@"将帅气照片分享到", nil)];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.equalTo(wSelf.mas_top).with.offset(0);
        make.left.equalTo(wSelf.mas_left).with.offset(0);
        make.right.equalTo(wSelf.mas_right).with.offset(0);
    }];
}

@end
