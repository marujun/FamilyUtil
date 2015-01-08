//
//  DetailViewController.h
//  FamilyUtil
//
//  Created by marujun on 15/1/8.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UFViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *beginTimeLabel;
    __weak IBOutlet UITextField *beginTextField;
    __weak IBOutlet UIButton *beginButton;
    
    __weak IBOutlet UILabel *endTimeLabel;
    __weak IBOutlet UITextField *endTextField;
    __weak IBOutlet UIButton *endButton;
}

@property (nonatomic, strong) GasRecord *gasRecord;


- (IBAction)imageButtonAction:(UIButton *)sender;

@end
