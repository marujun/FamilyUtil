//
//  RootViewController.m
//  FamilyUtil
//
//  Created by marujun on 15/1/8.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "RootViewController.h"
#import "GasViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GasViewController *gasViewController = [[GasViewController alloc] initWithNibName:nil bundle:nil];
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:gasViewController];
    
    [self addChildViewController:_rootNavigationController];
    [self.view addSubview:_rootNavigationController.view];
    [_rootNavigationController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    _rootNavigationController.interactivePopGestureRecognizer.delegate = self;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

@end
