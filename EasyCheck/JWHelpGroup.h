//
//  JWHelpGroup.h
//  EasyCheck
//
//  Created by jinwei on 16/5/28.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWHelpGroup : NSObject

/**
 *  数组中装的都是MJFriend模型
 */
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *helps;

/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;

+ (instancetype)groupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
