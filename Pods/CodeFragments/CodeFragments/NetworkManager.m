//
//  NetworkManager.m
//  CodeFragmentsDemo
//
//  Created by jinyu on 15/11/17.
//  Copyright © 2015年 Jeevan. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()

@property(nonatomic, assign) SCNetworkReachabilityRef   defaultRouteReachability;
@property(nonatomic, strong) NetworkChangedBlock        networkChangedBlock;

@end

@implementation NetworkManager

+ (instancetype)defaultManager{
    static NetworkManager* pRet = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pRet = [[self alloc] init];
    });
    return pRet;
}


/**
 *  @brief  获取当前的网络状态
 *
 *  @param  response 网络变化的回调，传入nil时，不启用网络变化监听
 *
 *  @return 当期的网络状态
 */
+ (NetWorkType)getNetworkTypeWithNetworkChangedBlock:(NetworkChangedBlock)response{
    struct sockaddr_in zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(nil, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(reachability, &flags);
    
    if(response != nil){
        NSLog(@"start network changed notification");
        [NetworkManager defaultManager].networkChangedBlock = response;
        [[NetworkManager defaultManager] startNotifierNetworkChanged];
    }else{
        NSLog(@"get network without notification");
    }
    
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)  {
        return kNetWorkInvalid;
    }
    
    NetWorkType retVal = kNetWorkInvalid;
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0){
        retVal = kNetWorkWIFI;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)){
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0){
            retVal = kNetWorkWIFI;    
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN){
        retVal = kNetWorkWWAN;
    }
    return retVal;
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkConnectionFlags flags, void* info){
    [(__bridge id)info performSelector:@selector(reachabilityChanged)];
}


- (BOOL)startNotifierNetworkChanged{
    
    struct sockaddr_in zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    self.defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(nil, (struct sockaddr *)&zeroAddress);

    
    SCNetworkReachabilityContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
    
    if(SCNetworkReachabilitySetCallback(self.defaultRouteReachability, ReachabilityCallback, &context)){
        
        if(!SCNetworkReachabilityScheduleWithRunLoop(self.defaultRouteReachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes)){
            NSLog(@"==Error: Could not schedule reachability");
            SCNetworkReachabilitySetCallback(self.defaultRouteReachability, NULL, NULL);
            return NO;
        }else{
            return YES;
        }
    }
    
    NSLog(@"Error: Could not set reachability callback");
    SCNetworkReachabilitySetCallback(self.defaultRouteReachability, NULL, NULL);
    return NO;
}

- (void)reachabilityChanged{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(self.defaultRouteReachability, &flags);
        
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)  {
        self.networkChangedBlock(kNetWorkInvalid);
        return;
    }
    
    NetWorkType retVal = kNetWorkInvalid;
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0){
        retVal = kNetWorkWIFI;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)){
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0){
            retVal = kNetWorkWIFI;    
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN){
        retVal = kNetWorkWWAN;
    }
    self.networkChangedBlock(retVal);
}

@end
