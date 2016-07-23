//
//  JWHeaderView.m
//  EasyCheck
//
//  Created by jinwei on 16/5/28.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWHeaderView.h"
#import "JWHelpGroup.h"

@interface JWHeaderView()

@property (nonatomic, weak) UIButton *nameView;

@end

@implementation JWHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    JWHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[JWHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

/**
 *  在这个初始化方法中,MJHeaderView的frame\bounds没有值
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        // 1.添加按钮
        UIButton *nameView = [UIButton buttonWithType:UIButtonTypeCustom];
        // 背景图片
        //[nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
        //[nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
        // 设置按钮内部的左边箭头图片
        //[nameView setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        [nameView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 设置按钮的内容左对齐
        nameView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 设置按钮的内边距
        //        nameView.imageEdgeInsets
        nameView.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        nameView.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [nameView addTarget:self action:@selector(nameViewClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 设置按钮内部的imageView的内容模式为居中
        nameView.imageView.contentMode = UIViewContentModeCenter;
        // 超出边框的内容不需要裁剪
        nameView.imageView.clipsToBounds = NO;
        
        [self.contentView addSubview:nameView];
        self.nameView = nameView;
        
    }
    return self;
}

/**
 *  当一个控件的frame发生改变的时候就会调用
 *
 *  一般在这里布局内部的子控件(设置子控件的frame)
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置按钮的frame
    self.nameView.frame = self.bounds;
}

- (void)setGroup:(JWHelpGroup *)group
{
    _group = group;
    
    // 1.设置按钮文字(组名)
    [self.nameView setTitle:group.title forState:UIControlStateNormal];
    
}

/**
 *  监听组名按钮的点击
 */
- (void)nameViewClick
{
    // 1.修改组模型的标记(状态取反)
    self.group.opened = !self.group.isOpened;
    
    // 2.刷新表格
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedNameView:)]) {
        [self.delegate headerViewDidClickedNameView:self];
    }
}

/**
 *  当一个控件被添加到父控件中就会调用
 */
- (void)didMoveToSuperview
{
    if (self.group.opened) {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}
@end
