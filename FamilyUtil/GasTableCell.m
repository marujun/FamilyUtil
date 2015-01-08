//
//  GasTableCell.m
//  FamilyUtil
//
//  Created by marujun on 15/1/8.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "GasTableCell.h"

@implementation GasTableCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)updateDisplay
{
    FLOG(@"_indexPath %@",_indexPath);
    FLOG(@"self.indexPath %@",self.indexPath);
}

@end
