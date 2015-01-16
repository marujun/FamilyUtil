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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _dataSource = [[GasRecord allRecord] mutableCopy];
        [_tableView  performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:true];
    });
}

- (void)rightNavButtonAction:(UIButton *)sender
{
    MCActionSheet *action = [MCActionSheet initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"主卧" otherButtonTitles:@"我们", nil];
    [action showWithCompletionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            return;
        }
        
        GasRecord *gasRecord = [GasRecord objectWithDictionary:nil];
        if (buttonIndex == 0) {
            gasRecord.is_other = @(true);
        }else{
            gasRecord.is_other = @(false);
        }
        
        DetailViewController *vc = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
        vc.gasRecord = gasRecord;
        [self.navigationController pushViewController:vc animated:true];
    }];
}


#pragma mark - Ttable View DataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return _dataSource.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GasTableCell";
//    NSDictionary *info = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    GasTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    [cell initWithData:_dataSource[indexPath.row] indexPath:indexPath];
    
    return cell;
}

//选中某行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    DetailViewController *vc = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    vc.gasRecord = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:true];
}


//是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

//控制编辑状态
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//提交修改
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete && _dataSource.count) {
        GasRecord *target = _dataSource[indexPath.row];
        
        [_dataSource removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        [target removeWithLocal];
    }
}


@end
