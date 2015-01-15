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
    
    NSString *timeString = [NSString stringWithFormat:@"%@ %@  %@--%@",
                            [_gasRecord.end_date?:_gasRecord.begin_date stringWithDateFormat:@"MM-dd"]?:@"",
                            [_gasRecord.end_date?:_gasRecord.begin_date weekDayString]?:@"",
                            [_gasRecord.begin_date stringWithDateFormat:@"HH:mm"]?:@"",
                            [_gasRecord.end_date stringWithDateFormat:@"HH:mm"]?:@""];
    self.textLabel.text = [NSString stringWithFormat:@"%@   用量：%.3f",timeString ,count];
    
    if (_gasRecord.is_other.boolValue) {
        self.textLabel.textColor = [UIColor blackColor];
        self.contentView.backgroundColor = RGBCOLOR(224, 224, 224);
    }else{
        self.textLabel.textColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
