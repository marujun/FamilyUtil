//
//  GasViewController.m
//  FamilyUtil
//
//  Created by marujun on 15/1/8.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "GasViewController.h"
#import "GasTableCell.h"
#import "DetailViewController.h"

@interface GasViewController ()
{
    NSMutableArray *_dataSource;
}

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
    
    _dataSource = [NSMutableArray array];
    [_tableView setTableFooterView:[UIView new]];
}

- (void)rightNavButtonAction:(UIButton *)sender
{
    DetailViewController *vc = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:true];
}


#pragma mark - Ttable View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GasTableCell";
    NSDictionary *info = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    GasTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    [cell initWithData:info indexPath:indexPath];
    
    return cell;
}

//选中某行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
