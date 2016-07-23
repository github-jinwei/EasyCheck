//
//  JWSettingArrowItem.m
//  Easy Check
//
//  Created by jin on 15-12-9.
//  Copyright (c) 2015年 nciae. All rights reserved.
//

#import "JWSettingArrowItem.h"

@implementation JWSettingArrowItem


+(instancetype)itemwithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass{
    JWSettingArrowItem *item=[self itemwithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
    
}

+(instancetype)itemwithTitle:(NSString *)title destVcClass:(Class)destVcClass{
    return  [self itemwithIcon:nil title:title destVcClass:destVcClass];
}
@end
