//
//  PublicInterface.h
//  Vodka
//
//  Created by fusunlang on 14-10-10.
//  Copyright (c) 2014年 Beijing Beast Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicInterface : NSObject

+ (void)setVariableValue:(id)value forKey:(NSString*)key;
+ (id)variableValueWithKey:(NSString*)key;

@end
