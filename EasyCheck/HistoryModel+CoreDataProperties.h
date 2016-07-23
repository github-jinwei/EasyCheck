//
//  HistoryModel+CoreDataProperties.h
//  EasyCheck
//
//  Created by jinwei on 16/5/15.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "HistoryModel.h"

@interface HistoryModel (CoreDataProperties)


@property (nullable, nonatomic, retain) NSNumber *historyId;
@property (nullable, nonatomic, retain) NSNumber *classId;
@property (nullable, nonatomic, retain) NSString *classNames;
@property (nullable, nonatomic, retain) NSDate *createTime;

@end
