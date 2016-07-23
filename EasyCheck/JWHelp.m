//
//  JWHelp.m
//  EasyCheck
//
//  Created by jinwei on 16/5/28.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWHelp.h"

@implementation JWHelp

+ (instancetype)helpWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
