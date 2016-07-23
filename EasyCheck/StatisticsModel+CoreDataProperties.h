//
//  StatisticsModel+CoreDataProperties.h
//  EasyCheck
//
//  Created by jinwei on 16/5/16.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "StatisticsModel.h"

@interface StatisticsModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *absence;
@property (nullable, nonatomic, retain) NSNumber *attent;
@property (nullable, nonatomic, retain) NSNumber *leave;
@property (nullable, nonatomic, retain) NSNumber *statisticsId;
@property (nullable, nonatomic, retain) NSDate   *statisticsTime;
@property (nullable, nonatomic, retain) NSNumber *stuId;
@property (nullable, nonatomic, retain) NSString *stuNames;


@end
