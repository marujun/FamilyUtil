//
//  MCPhotoViewController.h
//  MCFriends
//
//  Created by marujun on 14-6-19.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface MCPhotoViewController : UFViewController <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, weak) IBOutlet AQGridView *imageGridView;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray *dataSourceArray;

@end
