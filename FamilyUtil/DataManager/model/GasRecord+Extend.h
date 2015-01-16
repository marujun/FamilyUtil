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

- (UIImage *)begin_image;
- (UIImage *)end_image;
- (void)setBegin_image:(UIImage *)begin_image;
- (void)setEnd_image:(UIImage *)end_image;

- (void)removeWithLocal;

+ (void)directoryDirectoryExists;

@end
