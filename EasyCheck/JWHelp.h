//
//  JWHelp.h
//  EasyCheck
//
//  Created by jinwei on 16/5/28.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWHelp : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

+ (instancetype)helpWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
