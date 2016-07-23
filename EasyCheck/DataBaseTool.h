//
//  DataBaseTool.h
//  CoreData 封装
//
//  Created by dabing on 15/10/24.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;
/**
 *   数据库管理者
 */
@interface DataBaseTool : NSObject
/**
 *   初始化数据库 并制定数据库文件的名字  格式为 database.sqlite
 */
+ (void)initCoreDataBaseWithFileName:(NSString*)fileName;
/**
 *   将产品信息插入到数据库中
 *
 *   @param product 产品
 */
+ (void)insertProcuct:(Product*)product;

//+ (NSArray*)getAllProducts;

@end
