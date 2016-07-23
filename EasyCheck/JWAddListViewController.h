//
//  JWAddList1ViewController.h
//  EasyCheck
//
//  Created by JinWei on 16/4/24.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWBaseViewController.h"

typedef enum {
    AddClassList, // 添加
    UploadClassList // 更新
}EditingType;
@class ClassList;
@interface JWAddListViewController : JWBaseViewController
/**
 *  type
 */
@property(nonatomic,assign)EditingType editType;

/**
 *  ClassList
 */
@property(nonatomic,strong)ClassList *listModel;

@end
