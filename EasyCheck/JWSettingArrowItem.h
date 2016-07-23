//
//  JWSettingArrowItem.h
//  Easy Check
//
//  Created by jin on 15-12-9.
//  Copyright (c) 2015年 nciae. All rights reserved.
//

#import "JWSettingItem.h"


//typedef enum{
//    JWSettingArrowItemVcShowTypePush,
//    JWSettingArrowItemVcShowTypeModal
//    
//}JWSettingArrowItemVcShowType;

@interface JWSettingArrowItem : JWSettingItem
@property(nonatomic,assign)Class destVcClass;

//@property(nonatomic,assign)JWSettingArrowItemVcShowType vcShowType;

+(instancetype)itemwithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;

+(instancetype)itemwithTitle:(NSString *)title destVcClass:(Class)destVcClass;
@end
