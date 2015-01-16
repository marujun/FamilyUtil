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
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"day_index" ascending:NO];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"end_date" ascending:NO];
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"is_other == 0"];
    NSArray *tempArray = [self fetchWithRequest:^(NSFetchRequest *request) {
        [request setPredicate:nil];
        [request setSortDescriptors:@[sort1,sort2]];
    } context:[NSManagedObjectContext storeContext]];

    return tempArray;
}

- (void)removeWithLocal
{
    [[NSFileManager defaultManager] removeItemAtPath:self.begin_localPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.end_localPath error:nil];
    
    [self remove];
    [NSManagedObject syncContextWithComplete:nil];
}

- (UIImage *)begin_image
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.begin_localPath]) {
        return [UIImage imageWithContentsOfFile:self.begin_localPath];
    }
    return nil;
}

- (UIImage *)end_image
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.end_localPath]) {
        return [UIImage imageWithContentsOfFile:self.end_localPath];
    }
    return nil;
}

- (void)setBegin_image:(UIImage *)beginImage
{
    NSData *begin_data = UIImageJPEGRepresentation(beginImage, 0.5);
    [begin_data writeToFile:self.begin_localPath atomically:YES];
}

- (void)setEnd_image:(UIImage *)endImage
{
    NSData *end_data = UIImageJPEGRepresentation(endImage, 0.5);
    [end_data writeToFile:self.end_localPath atomically:YES];
}

+ (void)directoryDirectoryExists
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images"];
    
    //文件夹不存在的话则创建文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)begin_localPath
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images"];
    filePath = [filePath stringByAppendingFormat:@"/%@_0.jpg",[self.objectIDString md5]];
    
    return filePath;
}

- (NSString *)end_localPath
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images"];
    filePath = [filePath stringByAppendingFormat:@"/%@_1.jpg",[self.objectIDString md5]];
    
    return filePath;
}

@end
