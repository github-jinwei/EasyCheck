//
//  DataBaseTool.m
//  CoreData 封装
//
//  Created by dabing on 15/10/24.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

#import "DataBaseTool.h"
#import "CoreDataManager.h"
@implementation DataBaseTool
/**
 *   创建数据库文件
 *
 *   @param fileName 文件名 不加后缀即可
 */
+ (void)initCoreDataBaseWithFileName:(NSString *)fileName
{
    [CoreDataManager initCoreDataBaseWithFileName:fileName];
}
/**
 *   将产品信息插入到数据库中
 *
 *   @param product 产品
 */
+ (void)insertProcuct:(Product*)product
{
    NSError *error = nil;
    [CoreDataManager save:&error];
    if (error) {
        NSLog(@"插入失败");
    }else
    {
        NSLog(@"插入数据成功");
    }
}
//+ (NSArray*)getAllProducts
//{
//    NSMutableArray *tmp = [NSMutableArray array];
//    // predicate传 nil 则表示查询所有
//    NSError *error = nil;
//   
//    
//  
//    return nil;
//}
@end
