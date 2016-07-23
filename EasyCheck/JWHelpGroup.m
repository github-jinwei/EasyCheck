//
//  JWHelpGroup.m
//  EasyCheck
//
//  Created by jinwei on 16/5/28.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "JWHelpGroup.h"
#import "JWHelp.h"
@implementation JWHelpGroup

+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        NSMutableArray *helpArray = [NSMutableArray array];
        JWHelp *help = [JWHelp helpWithDict:dict];
        
        [helpArray addObject:help];
        
        self.helps = helpArray;
//        // 2.特殊处理friends属性
//        NSMutableArray *helpArray = [NSMutableArray array];
//        for (NSDictionary *dict in self.help) {
//            JWHelp *help = [JWHelp helpWithDict:dict];
//            [helpArray addObject:help];
//        }
//        self.help = helpArray;
    }
    return self;
}

@end
