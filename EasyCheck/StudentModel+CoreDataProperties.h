//
//  StudentModel+CoreDataProperties.h
//  EasyCheck
//
//  Created by jinwei on 16/5/12.
//  Copyright © 2016年 Weijin. All rights reserved.
//

#import "StudentModel.h"

@interface StudentModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *stuId;
@property (nullable, nonatomic, retain) NSString *stuNames;
@property (nullable, nonatomic, retain) NSString *stuNumber;
@property (nullable, nonatomic, retain) NSString *stuSex;
@property (nullable, nonatomic, retain) NSString *stuPhone;
@property (nullable, nonatomic, retain) NSString *stuNote;
@property (nullable, nonatomic, retain) NSNumber *classId;

@end
