//
//  UFViewController.m
//  FamilyUtil
//
//  Created by marujun on 15/1/8.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "UFViewController.h"

@interface UFViewController ()

@end

@implementation UFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self fInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)fInit
{
    FLOG(@"init 创建类 %@", NSStringFromClass([self class]));
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    FLOG(@"dealloc 释放类 %@",  NSStringFromClass([self class]));
}

@end
