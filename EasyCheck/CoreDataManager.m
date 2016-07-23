//
//  CoreDataManager.m
//  CoreData 封装
//
//  Created by dabing on 15/10/24.
//  Copyright © 2015年 大兵布莱恩特. All rights reserved.
//

#import "CoreDataManager.h"
#import "MJExtension.h"
@implementation CoreDataManager
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static CoreDataManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}
/**
 *   类方法创建实例
 */
+ (instancetype)manager
{
    return [[super alloc] init];
}
/**
 *   初始化 coreData
 */
+ (void)initCoreDataBaseWithFileName:(NSString *)fileName;
{
    // 1.上下文 关联Company.xcdatamodeld 模型文件
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    // 关联模型文件
    // 创建一个模型对象
    // 传一个nil 会把 bundle下的所有模型文件 关联起来
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 持久化存储调度器
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 存储数据库的名字
    NSError *error = nil;
    
    // 获取docment目录
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [NSString stringWithFormat:@"%@.sqlite",fileName];
    // 数据库保存的路径
    NSString *sqlitePath = [doc stringByAppendingPathComponent:file];
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    
    context.persistentStoreCoordinator = store;
    
    CoreDataManager *manager = [self manager];
    manager.context = context;
    
}
#pragma mark - 往数据库中插入一个对象首先需要将实体类和模型文件关联

/**
 *   将实体类和模型文件建立联系
 *
 *   @param class 传入一个你要操作的实体类的类名
 *
 *   @return 返回一 NSManagedObject的对象
 */
+ (id)insertNewObjectForEntityForName:(Class)modelClass
{
    CoreDataManager *manager = [CoreDataManager manager];
    NSManagedObject  *mgrObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(modelClass) inManagedObjectContext: manager.context];
    return mgrObject;
}

/**
 *  从字典中创建实例并转出 Coredata 的实例
 *
 *  @param dict       字典
 *  @param modelClass 模型
 *
 *  @return 返回一 NSManagedObject
 */
+ (id)insertNewObjectFromDictionary:(NSDictionary*)dict ForName:(Class)modelClass
{
    CoreDataManager *manager = [CoreDataManager manager];
    NSManagedObject *mgrObject = [modelClass mj_objectWithKeyValues:dict context:manager.context];
    return mgrObject;
}
/**
 *   保存数据
 *
 *   @param error  error 传& error
 *
 *   @return  返回是否成功
 */
+ (BOOL)save:(NSError **)error
{
    CoreDataManager *manager = [CoreDataManager manager];
    return  [manager.context save:error];
}
# pragma mark - 输入要查询对象的类名和查询语句 就可以得到一个查询结果集

/**
 *   查询语句
 *
 *   @param entityClass 实体类的类名
 *   @param sql         查询语句
 *   @param error       &error
 *
 *   @return 返回查询结果的数组
 */
+ (NSArray*)executeFetchRequest:(Class)entityClass predicate:(NSPredicate *)predicate error:(NSError**)error 
{
    CoreDataManager *manager = [CoreDataManager manager];
    //创建一个请求对象 （填入要查询的表名-实体类）
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(entityClass)];
    request.predicate = predicate;
    NSArray *emps = [manager.context executeFetchRequest:request error:error];
    return emps;
}

+ (void)executeFetchRequest:(Class)entityClass predicate:(NSPredicate *)predicate complete:(complete)complete
{
    CoreDataManager *manager = [CoreDataManager manager];
    //创建一个请求对象 （填入要查询的表名-实体类）
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(entityClass)];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *emps = [manager.context executeFetchRequest:request error:&error];
    if (complete)
    {
        complete(emps,error);
    }
}
#pragma mark - 删除对象
/**
 *   根据查询的结果集通过便利删除从数据库中删除数据
 *
 *   @param object 查询到的对象
 */
+ (void)deleteObject:(NSManagedObject*)object
{
    CoreDataManager *manager = [CoreDataManager manager];
    [manager.context deleteObject:object];
}

@end
