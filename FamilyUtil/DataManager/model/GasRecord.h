//
//  GasRecord.h
//  FamilyUtil
//
//  Created by marujun on 15/1/8.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GasRecord : NSManagedObject

@property (nonatomic, retain) NSDate * begin_date;
@property (nonatomic, retain) NSDate * end_date;
@property (nonatomic, retain) UIImage *begin_image;
@property (nonatomic, retain) UIImage *end_image;
@property (nonatomic, retain) NSNumber * begin_number;
@property (nonatomic, retain) NSNumber * end_number;
@property (nonatomic, retain) NSNumber * day_index;

@end
