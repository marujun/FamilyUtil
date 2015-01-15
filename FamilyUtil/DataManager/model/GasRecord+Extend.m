//
//  GasRecord+Extend.m
//  MCFriends
//
//  Created by zeke on 3/18/14.
//  Copyright (c) 2014 marujun. All rights reserved.
//

#import "GasRecord+Extend.h"

@implementation GasRecord (Extend)

+ (NSArray *)allRecord
{
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"day_index" ascending:YES];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"begin_date" ascending:YES];
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"is_other == 0"];
    NSArray *tempArray = [self fetchWithRequest:^(NSFetchRequest *request) {
        [request setPredicate:nil];
        [request setSortDescriptors:@[sort1,sort2]];
    } context:[NSManagedObjectContext backgroundContext]];

    return tempArray;
}

@end
