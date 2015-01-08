//
//  UIView+Common.h
//  HLMagic
//
//  Created by marujun on 13-12-8.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KeyboardAnimationCurve  (IS_IOS_6?0:7) << 16
#define KeyboardAnimationDuration  0.25

@interface BlurView : UIView

// Use the following property to set the tintColor. Set it to nil to reset.
@property (nonatomic, strong) UIColor *blurTintColor;

@end

@interface UIView (Common)

//移除所有的子视图
- (void)removeAllSubview;

- (UIView *)findFirstResponder;

- (void)setBlurColor:(UIColor *)blurColor;

- (UIViewController *)nearsetViewController;


//标题View（是否loadingView）
+ (UIView *)titileViewWithTitle:(NSString *)title activity:(BOOL)activity;

//标题View（带图片）
+ (UIView *)titileViewWithTitle:(NSString *)title image:(UIImage *)image;

@end
