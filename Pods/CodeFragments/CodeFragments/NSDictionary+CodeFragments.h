//
//  NSDictionary+CodeFragments.h
//  CodeFragment
//
//  Created by jinyu on 15/2/4.
//  Copyright (c) 2015年 jinyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CodeFragments)

/**
 *  @brief  把NSDictionary转为JSONString.
 *
 *  @return json string
 */
- (NSString*)jsonstring;

@end
