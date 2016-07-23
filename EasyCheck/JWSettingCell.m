//
//  JWSettingCell.m
//  Easy Check
//
//  Created by jin on 15-12-9.
//  Copyright (c) 2015年 nciae. All rights reserved.
//

#import "JWSettingCell.h"
#import "JWSettingItem.h"
#import "JWSettingArrowItem.h"
#import "JWSettingSwitchItem.h"
#import "JWSettingLabelItem.h"
#import "GlobalDefinition.h"

@interface JWSettingCell()

//箭头
@property(nonatomic,strong)UIImageView *arrowView;

//开关
@property(nonatomic,strong)UISwitch *switchView;

//标签
@property(nonatomic,strong)UILabel *labelView;


@end

@implementation JWSettingCell

-(UIImageView *)arrowView
{
    if (_arrowView==nil) {
        
        _arrowView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"statistics_arrow"]];
    }
    return _arrowView;
}

-(UISwitch *)switchView
{
    if (_switchView == nil) {
        
        _switchView =[[UISwitch alloc]init];
        
        [_switchView addTarget:self action:@selector(switchStateChange) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

//开关状态改变事件
-(void)switchStateChange
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:self.switchView.isOn forKey:self.item.title];
    
    [defaults synchronize];
}
-(UILabel *)labelView
{
    if (_labelView==nil) {
        
        _labelView=[[UILabel alloc]init];
        _labelView.bounds = CGRectMake(0, 0, 100, 30);
        _labelView.backgroundColor=[UIColor redColor];
    }
    return _labelView;
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting";
    JWSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        
        cell=[[JWSettingCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID] ;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       //初始化操作
        
        //初始化背景
        [self setupBg];
        
        //初始化控件
        [self setupSubviews];     
    }
    return self;
    
}

-(void)setupBg
{
    //设置普通背景
    UIView *bg = [[UIView alloc]init];
    bg.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bg;
    
    //设置选中时的背景
    UIView *selectBg=[[UIView alloc]init];
    selectBg.backgroundColor = JWColor(241,240,206);
    self.selectedBackgroundView = selectBg;
}

-(void)setupSubviews
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
}

-(void)setupRightContent
{
    if ([self.item isKindOfClass:[JWSettingArrowItem class]]) {
        //箭头
        self.accessoryView = self.arrowView;
    }
    else if ([self.item isKindOfClass:[JWSettingSwitchItem class]])
    {
        //开关
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //设置开关的状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.switchView.on = [defaults boolForKey:self.item.title];
        
    }
    else if ([self.item isKindOfClass:[JWSettingLabelItem class]])
    {
        //标签
        self.accessoryView = self.labelView;
    }
    else
    {
        self.accessoryView = nil;
    }
}

-(void)setFrame:(CGRect)frame
{
    frame.size.width += 20;
    frame.origin.x -= 10;
    
    [super setFrame:frame];
}

-(void)setItem:(JWSettingItem *)item
{
    _item=item;
    //1.设置数据
    [self setupData];
    
    //2.设置右边的内容
    [self setupRightContent];
}

-(void)setupData
{
    
    if (self.item.icon) {
         self.imageView.image=[UIImage imageNamed:self.item.icon];
    }
   
   self.textLabel.text=self.item.title;
   self.detailTextLabel.text=self.item.subtitle;
    
}

@end
