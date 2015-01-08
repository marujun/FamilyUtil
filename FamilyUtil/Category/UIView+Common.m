//
//  UIView+Common.m
//  HLMagic
//
//  Created by marujun on 13-12-8.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>

@interface BlurView ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation BlurView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // If we don't clip to bounds the toolbar draws a thin shadow on top
    [self setClipsToBounds:YES];
    
    if (![self toolbar]) {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
        [self.toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self insertSubview:[self toolbar] atIndex:0];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|"
                                                                     options:0
                                                                     metrics:0
                                                                       views:NSDictionaryOfVariableBindings(_toolbar)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_toolbar]|"
                                                                     options:0
                                                                     metrics:0
                                                                       views:NSDictionaryOfVariableBindings(_toolbar)]];
    }
}

- (void)setBlurTintColor:(UIColor *)blurTintColor {
    if ([self.toolbar respondsToSelector:@selector(setBarTintColor:)]) {
        [self.toolbar setBarTintColor:blurTintColor];
    }else{
        [self.toolbar setTintColor:blurTintColor];
    }
}

@end

@implementation UIView (Common)

- (void)removeAllSubview
{
    for (UIView *item in self.subviews) {
        [item removeFromSuperview];
    }
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

- (void)setBlurColor:(UIColor *)blurColor
{
    BlurView *blurView = nil;
    for (UIView *subview in self.subviews){
        if ([subview isKindOfClass:[BlurView class]]){
            blurView = (BlurView *)subview;
            break;
        }
    }
    if (!blurView) {
        blurView = [BlurView newAutoLayoutView];
        [self insertSubview:blurView atIndex:0];
        [blurView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    self.backgroundColor = [UIColor clearColor];
    [blurView setBlurTintColor:blurColor];
}

#pragma mark - 获取父 viewController
- (UIViewController *)nearsetViewController
{
    UIViewController *viewController = nil;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController*)nextResponder;
            break;
        }
    }
    return viewController;
}

+ (UIView *)titileViewWithTitle:(NSString *)title activity:(BOOL)activity
{
    UILabel *bigLabel = [[UILabel alloc] init];
    bigLabel.text = title;
    bigLabel.backgroundColor = [UIColor clearColor];
    bigLabel.textColor = [UIColor blackColor];
    bigLabel.font = [UIFont boldSystemFontOfSize:17];
    bigLabel.adjustsFontSizeToFitWidth = YES;
    [bigLabel sizeToFit];
    
    CGRect rect = bigLabel.frame;
    UIView *titleView = [[UIView alloc] initWithFrame:rect];
    titleView.backgroundColor = [UIColor clearColor];
    
    if (activity) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        CGRect activityRect = activityView.bounds;
        activityRect.origin.y = (rect.size.height-activityRect.size.height)/2;
        activityView.frame = activityRect;
        [titleView addSubview:activityView];
        
        rect.origin.x = activityRect.size.width+5;
        bigLabel.frame = rect;
    }
    [titleView addSubview:bigLabel];
    
    CGRect titleFrame = CGRectMake(0, 0, 0, rect.size.height);
    titleFrame.size.width = rect.origin.x+rect.size.width;
    titleView.frame = titleFrame;
    
    return titleView;
}

+ (UIView *)titileViewWithTitle:(NSString *)title image:(UIImage *)image
{
    UILabel *bigLabel = [[UILabel alloc] init];
    bigLabel.text = title;
    bigLabel.backgroundColor = [UIColor clearColor];
    bigLabel.textColor = [UIColor blackColor];
    bigLabel.font = [UIFont boldSystemFontOfSize:17];
    bigLabel.adjustsFontSizeToFitWidth = YES;
    [bigLabel sizeToFit];
    
    CGRect rect = bigLabel.frame;
    UIView *titleView = [[UIView alloc] initWithFrame:rect];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:bigLabel];
    
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect imageRect = CGRectMake(0, 0, 15, 15);
        imageRect.origin.x = rect.size.width+rect.origin.x+3;
        imageRect.origin.y = (rect.size.height-imageRect.size.height)/2;
        imageRect.size.width = image.size.width/(image.size.height/imageRect.size.height);
        imageView.frame = imageRect;
        [titleView addSubview:imageView];
        
        CGRect titleFrame = CGRectMake(0, 0, 0, rect.size.height);
        titleFrame.size.width = imageRect.origin.x+imageRect.size.width;
        titleView.frame = titleFrame;
    }
    
    return titleView;
}

@end
