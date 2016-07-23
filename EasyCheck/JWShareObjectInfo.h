//
//  JWShareObjectInfo.h
//  EasyCheck
//
//  Created by jinwei on 16/5/25.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JWShareObjectInfo : NSObject
// 分享我的活动
@property (nonatomic, retain) UIImage  *image;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *iconUrl;
@property (nonatomic, retain) NSString *descriptions;
@property (nonatomic, retain) NSString *shareLinkUrl;


@end
