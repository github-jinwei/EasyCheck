//
//  NetworkManager.h
//  CodeFragmentsDemo
//
//  Created by jinyu on 15/11/17.
//  Copyright © 2015年 Jeevan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <netinet/in.h>

typedef NS_ENUM(NSInteger, NetWorkType) {
    kNetWorkInvalid = 0,                //无网络连接
    kNetWorkWIFI    = 1,                //wifi 连接
    kNetWorkWWAN    = 2                 //WWAN 连接
};

typedef void (^NetworkChangedBlock) (NetWorkType networkType);

@interface NetworkManager : NSObject

+ (instancetype)defaultManager;

/**
 *  @brief  获取当前的网络状态
 *
 *  @param  response 网络变化的回调，传入nil时，不启用网络变化监听
 *
 *  @return 当期的网络状态
 */
+ (NetWorkType)getNetworkTypeWithNetworkChangedBlock:(NetworkChangedBlock)response;

@end