//
//  DetailViewController.m
//  FamilyUtil
//
//  Created by marujun on 15/1/8.
//  Copyright (c) 2015年 marujun. All rights reserved.
//

#import "DetailViewController.h"
#import "MCPhotoViewController.h"
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
    
//    UIButton *rightButton = [UIButton newClearNavButtonWithTitle:@"保存" target:self action:@selector(rightNavButtonAction:)];
//    [self setNavigationRightView:rightButton];
    
    beginButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    beginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    beginButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    endButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    endButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    endButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    UILongPressGestureRecognizer *beginRecognizer = [[UILongPressGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(longPressGestureRecognizer:)];
    beginRecognizer.accessibilityValue = [@(beginButton.tag) stringValue];
    [beginButton addGestureRecognizer:beginRecognizer];
    
    UILongPressGestureRecognizer *endRecognizer = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(longPressGestureRecognizer:)];
    endRecognizer.accessibilityValue = [@(endButton.tag) stringValue];
    [endButton addGestureRecognizer:endRecognizer];
    
    beginTextField.placeholder = @"0.000";
    endTextField.placeholder = @"0.000";
    
    [self updateDisplay];
    [_scrollView setContentSize:self.view.frame.size];
    
    __weak typeof(self) weakSelf = self;
    [self.view setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
    }];
}

- (void)rightNavButtonAction:(UIButton *)sender
{
    if (_gasRecord.day_index.intValue > 10000) {
        [_gasRecord syncWithComplete:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state!=UIGestureRecognizerStateBegan && recognizer.state!=UIGestureRecognizerStatePossible) {
        return;
    }
    
    MCActionSheet *screenActionSheet = [MCActionSheet initWithTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [screenActionSheet showWithCompletionBlock:^(NSInteger buttonIndex) {
        if (buttonIndex >= 2) {
            return ;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = true;
        imagePicker.delegate = self;
        
        imagePicker.accessibilityValue = recognizer.accessibilityValue;
        if (buttonIndex == 0) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else if (buttonIndex == 1) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [self presentViewController:imagePicker animated:true completion:nil];
    }];
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
        [beginButton setBackgroundImage:_gasRecord.begin_image forState:UIControlStateNormal];
    }else{
        beginTimeLabel.text = @"开始时间：00:00";
        [beginButton setImage:nil forState:UIControlStateNormal];
    }
    
    if (_gasRecord.end_image) {
        endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@",[_gasRecord.end_date stringWithDateFormat:@"HH:mm"]];
        [endButton setBackgroundImage:_gasRecord.end_image forState:UIControlStateNormal];
    }else{
        endTimeLabel.text = @"结束时间：00:00";
        [endButton setImage:nil forState:UIControlStateNormal];
    }
    
    [self updateItemNumner:true];
}

- (void)updateItemNumner:(BOOL)updateItem
{
    float count = _gasRecord.end_number.floatValue - _gasRecord.begin_number.floatValue;
    if (count >0) {
        titleLabel.text = [NSString stringWithFormat:@"用量:%.3f   费用:%.3f",count, count*2.28];
    }else{
        titleLabel.text = @"用量:0.000   费用:0.000";
    }
    
    //自动保存数据
    [self rightNavButtonAction:nil];
    
    if (!updateItem) {
        return;
    }
    if (_gasRecord.begin_number.intValue) {
        beginTextField.text = [NSString stringWithFormat:@"%.3f",_gasRecord.begin_number.floatValue];
    }else{
        beginTextField.text = @"";
    }
    
    if (_gasRecord.end_number.intValue) {
        endTextField.text = [NSString stringWithFormat:@"%.3f",_gasRecord.end_number.floatValue];
    }else{
        endTextField.text = @"";
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)imageButtonAction:(UIButton *)sender
{
    if (sender.tag == 0) {
        if (_gasRecord.begin_image) {
            [self displayPhotoWithEnd:NO];
        }else{
            [self longPressGestureRecognizer:beginButton.gestureRecognizers[0]];
        }
    } else
    {
        if (_gasRecord.end_image) {
            [self displayPhotoWithEnd:YES];
        }else{
            [self longPressGestureRecognizer:endButton.gestureRecognizers[0]];
        }
    }
}

- (void)displayPhotoWithEnd:(BOOL)isEnd
{
    MCPhotoViewController *preVC = [[MCPhotoViewController alloc] initWithNibName:nil bundle:nil];
    preVC.currentIndex = 0;
    
    if (_gasRecord.begin_image && _gasRecord.end_image) {
        preVC.dataSourceArray = @[_gasRecord.begin_image, _gasRecord.end_image];
        if (isEnd) {
            preVC.currentIndex = 1;
        }
    }
    else if (isEnd) {
        preVC.dataSourceArray = @[_gasRecord.end_image];
    }
    else{
        preVC.dataSourceArray = @[_gasRecord.begin_image];
    }
    [self.navigationController pushViewController:preVC animated:YES];
}

#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    string = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    if (textField.tag == 0) {
        _gasRecord.begin_number = [numberFormatter numberFromString:string];
    }else{
        _gasRecord.end_number = [numberFormatter numberFromString:string];
        FLOG(@"_gasRecord.end_number %@",_gasRecord.end_number);
    }
    
    [self updateItemNumner:false];
    
    return YES;
}

#pragma mark - 键盘升起，下降
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if ([beginTextField isFirstResponder]) {
        return;
    }
    
    CGRect rect = [_scrollView convertRect:endTextField.frame toView:self.view];
    
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:KeyboardAnimationDuration delay:0 options:KeyboardAnimationCurve animations:^{
        CGFloat tmpY = (rect.origin.y + rect.size.height) - (WINDOW_HEIGHT - keyboardRect.height) + 10;
        [_scrollView setContentOffset:CGPointMake(0, tmpY)];
        [_scrollView setContentInset:UIEdgeInsetsMake(0 , 0, keyboardRect.height, 0)];
        
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    [UIView animateWithDuration:KeyboardAnimationDuration delay:0 options:KeyboardAnimationCurve animations:^{
        [_scrollView setContentOffset:CGPointZero];
        [_scrollView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    } completion:nil];
}

@end
