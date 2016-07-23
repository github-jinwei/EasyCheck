//
//  ClassList+CoreDataProperties.h
//  EasyCheck
//
//  Created by JinWei on 16/5/8.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "ClassList.h"

@interface ClassList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *classId;
@property (nullable, nonatomic, retain) NSString *classNames;
@property (nullable, nonatomic, retain) NSString *classNote;
@property (nullable, nonatomic, retain) NSString *createTime;

@end
