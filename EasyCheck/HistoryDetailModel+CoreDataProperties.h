//
//  HistoryDetailModel+CoreDataProperties.h
//  EasyCheck
//
//  Created by jinwei on 16/5/16.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "HistoryDetailModel.h"

@interface HistoryDetailModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *attendance;
@property (nullable, nonatomic, retain) NSNumber *historyId;
@property (nullable, nonatomic, retain) NSNumber *classId;
@property (nullable, nonatomic, retain) NSNumber *stuId;
@property (nullable, nonatomic, retain) NSString *stuNames;
@property (nullable, nonatomic, retain) NSString *stuNote;
@property (nullable, nonatomic, retain) NSNumber *hisDetailId;

@end
