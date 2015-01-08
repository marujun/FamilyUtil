//
//  MCBaseTableCell.h
//  MCFriends
//
//  Created by marujun on 14-3-20.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (MCBaseTableCell)

- (id)tableViewDelegate;
- (UITableView *)superTableView;

@end

@interface MCBaseTableCell : UITableViewCell
{
    id _dataInfo;
    NSIndexPath *_indexPath;
}

@property(nonatomic, strong) id dataInfo;
@property(nonatomic, strong) NSIndexPath *indexPath;

- (void)updateDisplay;

- (void)initWithData:(id)data indexPath:(NSIndexPath *)indexPath;


@end
