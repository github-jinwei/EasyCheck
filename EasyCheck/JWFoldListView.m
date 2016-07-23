//
//  JWFoldListView.m
//  EasyCheck
//
//  Created by jinwei on 16/5/14.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#define FoldCellHeight  ((_dataArray.count + 1)* self.jwHeight)

#import "JWFoldListView.h"
#import "ClassList.h"

@interface JWFoldListView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGSize _showSize;
    BOOL _isTableFold;
    NSMutableArray *_dataArray;
}

@property (strong,nonatomic)UITableView *foldTableView;
@property (strong,nonatomic)UIButton *selectButton;
@property (strong,nonatomic)UIView *foldBackgroundView;
@end

@implementation JWFoldListView

-(instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray*)dataArray {
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
        self.frame = frame;
        _showSize = frame.size;
        _dataArray = dataArray;
        _jwTitleChanged = YES;
        _jwHeight = 44;
        [self initWithFoldListView];
    }
    
    return self;
}

- (void)jwCloseTable {
    if (self.jwSelected == YES) {
        [self buttonClick:self.selectButton];
    }
}

- (void)jwOpenTable {
    if (self.selectButton.selected == NO) {
        [self buttonClick:self.selectButton];
    }
}

- (void)initWithFoldListView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.bounds;
    NSString *title = nil;
    if (_dataArray.count > 0 && !title) {
        ClassList *c = [_dataArray objectAtIndex:0];
        title = c.classNames;
    } else {
        title = @"选择";
    }
    //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //button.contentEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _selectButton = button;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, _showSize.height, _showSize.width, 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    _foldBackgroundView = bgView;
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, _showSize.height, _showSize.width, 0) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor clearColor];
    [self addSubview:table];
    _foldTableView = table;
}

#pragma mark - UITableView 代理及数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foldButtonCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"foldButtonCellID"];
        cell.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:self.jwFontSize];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    ClassList *c = _dataArray[indexPath.row];
    cell.textLabel.text = c.classNames;//[_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //id obj = [_dataArray objectAtIndex:indexPath.row];
    ClassList *c = _dataArray[indexPath.row];
    
    if (self.jwDelegate && [self.jwDelegate respondsToSelector:@selector(JWFoldListView:didSelectObject:)]) {
        [self.jwDelegate JWFoldListView:self didSelectObject:c.classId];
    }
    
    if (self.jwResultBlock) {
        self.jwResultBlock(c.classNames);
    }
    
    if (self.jwTitleChanged) {
        [self jwSetTitle:c.classNames forState:UIControlStateNormal];
    }
    
    [self buttonClick:self.selectButton];
}

#pragma mark - 自定义按钮设置方法
- (void)jwSetTitle:(NSString*)title forState:(UIControlState)state {
    
    self.selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.selectButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.selectButton setTitle:title forState:state];
}

-(void)jwSetTitleColor:(UIColor*)color forState:(UIControlState)state {
    [self.selectButton setTitleColor:color forState:state];
}

- (void)jwSetBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [self.selectButton setBackgroundImage:image forState:state];
}

- (void)jwSetImage:(UIImage *)image forState:(UIControlState)state {
    [self.selectButton setImage:image forState:state];
    
    if (_foldListViewType == FoldListViewRight) {
        [self setFoldListButtonType:FoldListViewRight];
    }
}

#pragma mark - 重写属性setter方法
-(void)setBackgroundColor:(UIColor *)backgroundColor {
    
    self.selectButton.backgroundColor = backgroundColor;
}

- (void)setjwTitleFontSize:(CGFloat)jwTitleFontSize {
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:jwTitleFontSize];
}

-(void)setJwColor:(UIColor *)jwColor {
    _jwColor = jwColor;
    self.foldBackgroundView.backgroundColor = jwColor;
}

- (void)setJwAlpha:(CGFloat)jwAlpha {
    self.foldBackgroundView.alpha = jwAlpha;
    _jwAlpha = jwAlpha;
}

- (void)setFoldListButtonType:(FoldListViewType)foldListViewType {
    _foldListViewType = foldListViewType;
    
    switch (foldListViewType) {
        case FoldListViewTypeNormal:
            break;
        case FoldListViewRight:{
            
            //需要在外部修改标题背景色的时候将此代码注释
            self.selectButton.titleLabel.backgroundColor = self.selectButton.backgroundColor;
            self.selectButton.imageView.backgroundColor = self.selectButton.backgroundColor;
            
            CGSize titleSize = self.selectButton.titleLabel.bounds.size;
            CGSize imageSize = self.selectButton.imageView.bounds.size;
            CGFloat interval = 1.0;
            
            //[self.selectButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            //[self.selectButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            
            [self.selectButton setImageEdgeInsets:UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval))];
            [self.selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval)];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 重写属性getter方法
- (BOOL)jwSelected {
    
    return self.selectButton.selected;
}

#pragma mark - 按钮点击事件
- (void)buttonClick:(UIButton*)button {
    button.selected = !button.selected;
    if (_isTableFold) {
        
        [self tableClose];
    } else {
        
        [self tableOpen];
    }
}

- (void)tableClose {
    //如果已经关闭了,直接返回
    if (_isTableFold == NO) {
        return;
    }
    _isTableFold = NO;
    CGRect rect = self.frame;
    rect.size.height -= FoldCellHeight;
    self.frame = rect;
    [UIView animateWithDuration:0.1 animations:^{
        CGRect rect1 = self.foldTableView.frame;
        rect1.size.height -= FoldCellHeight;
        self.foldTableView.frame = rect1;
        
        CGRect rect2 = self.foldBackgroundView.frame;
        rect2.size.height -= FoldCellHeight;
        self.foldBackgroundView.frame = rect2;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tableOpen {
    //如果已经展开了,直接返回
    if (_isTableFold == YES) {
        return;
    }
    _isTableFold = YES;
    CGRect rect = self.frame;
    rect.size.height += FoldCellHeight;
    self.frame = rect;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect1 = self.foldTableView.frame;
        rect1.size.height += FoldCellHeight;
        self.foldTableView.frame = rect1;
        
        CGRect rect2 = self.foldBackgroundView.frame;
        rect2.size.height += FoldCellHeight;
        self.foldBackgroundView.frame = rect2;
    } completion:^(BOOL finished) {
        
    }];
}
@end
