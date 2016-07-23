//
//  JWSettingGroup.h
//  Easy Check
//
//  Created by jin on 15-12-9.
//  Copyright (c) 2015年 nciae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWSettingGroup : NSObject

/**
 *头部标题
 */
@property(nonatomic,copy)NSString *header;

/**
 *尾部标题
 */

@property(nonatomic,copy)NSString *footer;

/**
 *存放这组所有的模型数据
 */
@property(nonatomic,copy)NSArray *items;

@end
