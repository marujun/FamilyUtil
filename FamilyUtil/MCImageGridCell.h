//
//  MCImageGridCell.h
//  MCFriends
//
//  Created by marujun on 14-6-19.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "AQGridViewCell.h"

@interface MCImageGridCell : AQGridViewCell <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIImageView *zoomImageView;

@property (nonatomic, strong) UIView *indicatorBgView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;


- (void)initWithImage:(UIImage *)image index:(NSInteger)index;

- (void)doubleTapWithPoint:(CGPoint)point index:(NSInteger)index;

@end
