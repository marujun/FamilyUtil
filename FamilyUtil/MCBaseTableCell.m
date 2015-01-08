//
//  MCBaseTableCell.m
//  MCFriends
//
//  Created by marujun on 14-3-20.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MCBaseTableCell.h"

@implementation UITableViewCell (MCBaseTableCell)

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

- (id)tableViewDelegate
{
    UITableView *tableView = [self superTableView];
    
    if (tableView) {
        return tableView.delegate;
    }
    
    return nil;
}

- (UITableView *)superTableView
{
    id view = [self superview];
    
    while (view && ![view isKindOfClass:[UITableView class]]) {
        view = [view superview];
    }
    
    return (UITableView *)view;
}

@end


@interface MCBaseTableCell ()
{
    UIWebView * phoneCallWebView ;
}

@end

static NSMutableDictionary *matchParserUtil;

@implementation MCBaseTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)initWithData:(id)data indexPath:(NSIndexPath *)indexPath
{
    _dataInfo = data;
    _indexPath = indexPath;
    
    [self updateDisplay];
}

- (void)updateDisplay
{
    
}

@end
