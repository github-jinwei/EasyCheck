//
//  JWSettingItem.m
//  Easy Check
//
//  Created by jin on 15-12-9.
//  Copyright (c) 2015年 nciae. All rights reserved.
//

#import "JWSettingItem.h"

@implementation JWSettingItem



+(instancetype)itemwithIcon:(NSString *)icon title:(NSString *)title{
    JWSettingItem *item=[[self alloc]init];
    item.icon = icon;
    item.title = title;
   
    return item;
    
}

+(instancetype)itemwithTitle:(NSString *)title
{
    return [self itemwithIcon:nil title:title];
}
@end
