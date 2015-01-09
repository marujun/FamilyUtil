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
    GasRecord *_gasRecord = _dataInfo;
    
    float count = _gasRecord.end_number.floatValue - _gasRecord.begin_number.floatValue;
    count = MAX(0, count);
    
    NSString *timeString = [NSString stringWithFormat:@"%@--%@",
                            [_gasRecord.begin_date stringWithDateFormat:@"MM-dd  HH:mm"],
                            [_gasRecord.end_date stringWithDateFormat:@"HH:mm"]?:@""];
    self.textLabel.text = [NSString stringWithFormat:@"%@   用量：%.3f",timeString ,count];
}

@end
