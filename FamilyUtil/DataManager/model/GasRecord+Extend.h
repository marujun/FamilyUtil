//
//  GasRecord+Extend.h
//  MCFriends
//
//  Created by zeke on 3/18/14.
//  Copyright (c) 2014 marujun. All rights reserved.
//

#import "GasRecord.h"

@interface GasRecord (Extend)

+ (NSArray *)allRecord;

- (UIImage *)beginImage;
- (UIImage *)endImage;
- (void)setBeginImage:(UIImage *)begin_image;
- (void)setEndImage:(UIImage *)end_image;

- (void)removeWithLocal;

+ (void)switchImageStore;
+ (void)directoryDirectoryExists;

@end
