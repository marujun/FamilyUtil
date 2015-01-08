//
//  UIViewController+Navigation.m
//  HLSNS
//
//  Created by 刘波 on 12-12-4.
//  Copyright (c) 2012年 hoolai. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

-(void)setNavigationBackButtonDefault
{
    UIButton *backButton = [UIButton newBackArrowNavButtonWithTarget:self action:nil];
    [self setNavigationBackButton:backButton];
    [backButton setExclusiveTouch:YES];
}

-(void)setNavigationBackButton:(UIButton *)button
{
    [button addTarget:self action:@selector(navigationBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setNavigationLeftView:button];
}

- (void)navigationBackButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setNavigationLeftView:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]]) {
        [(UIButton *)view setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    // 调整 leftBarButtonItem 在 iOS6 下面的位置
    if([[[UIDevice currentDevice] systemVersion] floatValue]<7.0){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 10;  //向右移动5个像素
//        negativeSpacer.width = -6;  //向左移动6个像素
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, buttonItem];
    }else{
        self.navigationItem.leftBarButtonItem = buttonItem;
    }
}

-(void)setNavigationRightView:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]]) {
        [(UIButton *)view setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    // 调整 rightBarButtonItem 在 iOS6 下面的位置
    if([[[UIDevice currentDevice] systemVersion] floatValue]<7.0){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 10;  //向左移动10个像素
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, buttonItem];
    }else{
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
}

-(void)setNavigationRightViews:(NSArray *)views
{
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    parentView.backgroundColor = [UIColor clearColor];
    parentView.clipsToBounds = YES;
    
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:parentView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    int padding = 5;
    if ([views count] < 2) {
        return;
    }
    UIView *view1 = [views objectAtIndex:0];
    UIView *view2 = [views objectAtIndex:1];
    [parentView addSubview:view1];
    [parentView addSubview:view2];
    view2.center = CGPointMake(parentView.frame.size.width-view2.frame.size.width/2, 22);
    view1.center = CGPointMake(parentView.frame.size.width-view2.frame.size.width - padding - view1.frame.size.width/2, 22);
    
    if(view1.center.x<view1.frame.size.width/2){
        float difference = view1.frame.size.width/2-view1.center.x;
        parentView.frame = CGRectMake(0, 0, 100+difference, 44);
        view1.center = CGPointMake(view1.center.x+difference, view1.center.y);
        view2.center = CGPointMake(view2.center.x+difference, view2.center.y);
    }
    
}

-(void)setNavigationTitleView:(UIView *)view
{
    self.navigationItem.titleView = view;
}


@end
