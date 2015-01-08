//
//  DetailViewController.m
//  FamilyUtil
//
//  Created by marujun on 15/1/8.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "DetailViewController.h"
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DetailViewController ()

@end

@implementation DetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"编辑";
    [self setNavigationBackButtonDefault];
    
    if (!_gasRecord) {
        _gasRecord = [GasRecord objectWithDictionary:nil];
    }
    [self updateDisplay];
    
    UIButton *rightButton = [UIButton newClearNavButtonWithTitle:@"保存" target:self action:@selector(rightNavButtonAction:)];
    [self setNavigationRightView:rightButton];
    
    beginButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    beginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    beginButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    endButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    endButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    endButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    __weak typeof(self) weakSelf = self;
    [self.view setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
    }];
}

- (void)rightNavButtonAction:(UIButton *)sender
{
    if (_gasRecord.day_index) {
        [_gasRecord synchronizeAndWait];
    }
}


#pragma mark UIImagePickerControlleDelegates
- (void)imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block NSDate *shootDate = nil;   //照片的拍摄时间
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];  //转成jgp 0.5质量
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        shootDate = [NSDate date];
        
        if ([picker.accessibilityValue intValue] == 1) {
            _gasRecord.end_image = image;
            _gasRecord.end_date = shootDate;
        }else{
            _gasRecord.begin_image = image;
            _gasRecord.begin_date = shootDate;
            
            _gasRecord.day_index = @([shootDate dayIndexSince1970]);
        }
        [self updateDisplay];
    }
    else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            NSDictionary *imageMetadata = asset.defaultRepresentation.metadata;
            //EXIF数据
            NSMutableDictionary *EXIFDictionary =[[imageMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
            NSString * dateTimeOriginal=[[EXIFDictionary objectForKey:(NSString*)kCGImagePropertyExifDateTimeOriginal] mutableCopy];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];//yyyy-MM-dd HH:mm:ss
            shootDate = [dateFormatter dateFromString:dateTimeOriginal];
            
            if ([picker.accessibilityValue intValue] == 1) {
                _gasRecord.end_image = image;
                _gasRecord.end_date = shootDate;
            }else{
                _gasRecord.begin_image = image;
                _gasRecord.begin_date = shootDate;
                
                _gasRecord.day_index = @([shootDate dayIndexSince1970]);
            }
            [self updateDisplay];
            
        } failureBlock:nil];
    }
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)updateDisplay
{
    if (_gasRecord.begin_image) {
        beginTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@",[_gasRecord.begin_date stringWithDateFormat:@"HH:mm"]];
        beginTextField.text = [NSString stringWithFormat:@"%.3f",_gasRecord.begin_number.floatValue];
        [beginButton setBackgroundImage:_gasRecord.begin_image forState:UIControlStateNormal];
    }else{
        beginTimeLabel.text = @"开始时间：00:00";
        beginTextField.text = @"0.000";
        [beginButton setImage:nil forState:UIControlStateNormal];
    }
    
    if (_gasRecord.end_image) {
        endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",[_gasRecord.end_date stringWithDateFormat:@"HH:mm"]];
        endTextField.text = [NSString stringWithFormat:@"%.3f",_gasRecord.end_number.floatValue];
        [endButton setBackgroundImage:_gasRecord.end_image forState:UIControlStateNormal];
    }else{
        endTimeLabel.text = @"结束时间：00:00";
        endTextField.text = @"0.000";
        [endButton setImage:nil forState:UIControlStateNormal];
    }
    
    float count = _gasRecord.end_number.floatValue - _gasRecord.begin_number.floatValue;
    if (count >0) {
        titleLabel.text = [NSString stringWithFormat:@"用量：%.3f",count];
    }else{
        titleLabel.text = @"用量：0.000";
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)imageButtonAction:(UIButton *)sender
{
    MCActionSheet *screenActionSheet = [MCActionSheet initWithTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [screenActionSheet showWithCompletionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex >= 2) {
            return ;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = true;
        imagePicker.delegate = self;
        
        imagePicker.accessibilityValue = [@(sender.tag) stringValue];
        if (buttonIndex == 0) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else if (buttonIndex == 1) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [self presentViewController:imagePicker animated:true completion:nil];
    }];
}

@end
