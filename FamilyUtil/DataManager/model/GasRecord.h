//
//  GasRecord.h
//  FamilyUtil
//
//  Created by 马汝军 on 15/1/16.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GasRecord;

@interface GasRecord : NSManagedObject

@property (nonatomic, retain) NSDate * begin_date;
@property (nonatomic, retain) NSNumber * begin_number;
@property (nonatomic, retain) NSNumber * day_index;
@property (nonatomic, retain) NSDate * end_date;
@property (nonatomic, retain) NSNumber * end_number;
@property (nonatomic, retain) NSNumber * is_other;
@property (nonatomic, retain) GasRecord *target;

@end
