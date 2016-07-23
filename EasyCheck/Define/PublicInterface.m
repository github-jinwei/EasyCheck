//
//  PublicInterface.m
//  Vodka
//
//  Created by fusunlang on 14-10-10.
//  Copyright (c) 2014年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import "PublicInterface.h"

@implementation PublicInterface

+ (void)setVariableValue:(id)value forKey:(NSString*)key
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    [myDefault setValue:value forKey:key];
    [myDefault synchronize];
}

+ (id)variableValueWithKey:(NSString*)key
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
    if ([myDefault valueForKey:key]) {
        return [myDefault valueForKey:key];
    }
    return nil;
}

@end
