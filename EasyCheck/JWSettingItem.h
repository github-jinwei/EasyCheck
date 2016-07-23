//
//  JWSettingItem.h
//  Easy Check
//
//  Created by jin on 15-12-9.
//  Copyright (c) 2015年 nciae. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum {
//    JWSettingItemTypeArrow,
//    JWSettingItemTypeSwitch
//}JWSettingItemType;

typedef void (^JWSettingItemOption)();

@interface JWSettingItem : NSObject

//图标
@property(nonatomic,copy)NSString *icon;

//标题
@property(nonatomic,copy)NSString *title;

//子标题
@property(nonatomic,copy)NSString *subtitle;

//存储数据用的key
@property(nonatomic,copy)NSString *key;

//@property(nonatomic,assign)JWSettingItemType type;

@property(nonatomic,copy)JWSettingItemOption option;

+(instancetype)itemwithIcon:(NSString *)icon title:(NSString *)title;
+(instancetype)itemwithTitle:(NSString *)title;


@end
