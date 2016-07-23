//
//  NSString+CodeFragments.h
//  CodeFragment
//
//  Created by jinyu on 15/1/30.
//  Copyright (c) 2015年 jinyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CodeFragments)

/**
 *  @brief  将NSString进行16位小写MD5加密.
 *
 *  @return 加密后的字符串.
 */
- (NSString*)md5String;

/**
 *  @brief  把 JSON 字符串转为 NSDictionary 或者 NSArray
 *
 *  @return NSDictionary或NSArray的对象(需要强制转换)
 */
- (id)jsonvalue;

/**
 *  @brief  判断字符串是否为空
 *
 *  @return YES:空字符串， NO:非空字符串.
 */
- (BOOL)isEmpty;

/**
 *  @brief 判断NSString是否包含另一个字符串
 *
 *  @param subString 子字符串
 *
 *  @return YES:包含，NO:不包含.
 */
- (BOOL)stringContainsSubString:(NSString *)subString;

/**
 *  @brief 字符串匹配正则表达式
 *
 *  @param regString 正则表达式
 *
 *  @return YES:匹配， NO:不匹配.
 */
- (BOOL)matchStringWithRegextes:(NSString*)regString;

/**
 *  @brief  将16进制字符串转换为NSData.
 *
 *  @return 16进制 data
 */
- (NSData*)hexData;
- (NSString*)digitString:(NSInteger)digit;

+ (BOOL)isEmptyString:(NSString *)string;
@end
