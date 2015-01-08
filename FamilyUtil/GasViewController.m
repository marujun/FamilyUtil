//
//  GasViewController.m
//  FamilyUtil
//
//  Created by marujun on 15/1/8.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "GasViewController.h"
#import "AddGasViewController.h"

@interface GasViewController ()

@end

@implementation GasViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"记录";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                    target:self
                                    action:@selector(rightNavButtonAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)rightNavButtonAction:(UIButton *)sender
{
    AddGasViewController *vc = [[AddGasViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:true];
}

@end
