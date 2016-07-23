//
//  DefineFragments.h
//  CodeFragment
//
//  Created by jinyu on 15/1/30.
//  Copyright (c) 2015年 jinyu. All rights reserved.
//

#ifndef CodeFragment_DefineFragments_h
#define CodeFragment_DefineFragments_h


/**
 *  @brief 输出格式如下的打印信息：(类名:行数   打印的信息), 只有在DEBUG模式下输出，release模式不会输出(Build Settings 中 Preprocessor Macros 的 Debug 后边会有 DEBUG = 1 定义)
 */

#ifdef DEBUG
//    #define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

    #define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
    #define NSLog(...)
#endif

/**
 *  @brief  iOS 系统 Document 目录宏定义
 */
#define SYSTEM_DOCUMENT_PATH     NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

/**
 *  @brief  iOS 系统 Libiary 目录宏定义
 */
#define SYSTEM_LIBIARY_PATH      NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]

#define WEAK(object)     __weak typeof(object)


    //单例化一个类 instanceMothed:单例的方法名称
#define instance_interface(className, instanceMothed)   \
\
+(instancetype)instanceMothed;

    //实现方法
#define instance_implementation(className, instanceMothed)   \
\
static className *_instance;\
\
+(instancetype)instanceMothed\
{   static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc]init];\
});\
return _instance;\
}\
\
+(id)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
-(id)copyWithZone:(NSZone *)zone{\
return _instance;\
}

#endif
