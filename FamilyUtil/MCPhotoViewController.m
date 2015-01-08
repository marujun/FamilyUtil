//
//  MCPhotoViewController.m
//  MCFriends
//
//  Created by marujun on 14-6-19.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MCPhotoViewController.h"
#import "MCImageGridCell.h"

@interface MCPhotoViewController ()

@end

@implementation MCPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = [NSString stringWithFormat:@"%@ / %@", @(_currentIndex+1), @(_dataSourceArray.count)];
    self.view.clipsToBounds = true;
    
    [self setNavigationBackButtonDefault];
    
    _imageGridView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    _imageGridView.backgroundColor = [UIColor blackColor];
    _imageGridView.bounces = YES;
    _imageGridView.pagingEnabled = true;
    _imageGridView.showsHorizontalScrollIndicator = false;
    _imageGridView.showsVerticalScrollIndicator = false;

    [_imageGridView reloadData];
    
    CGSize contentSize = _imageGridView.contentSize;
    contentSize.height = _imageGridView.frame.size.height;
    _imageGridView.contentSize = contentSize;
    
    [_imageGridView scrollToItemAtIndex:_currentIndex atScrollPosition:AQGridViewScrollPositionNone animated:NO];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - 单双击手势触发
-(void)handleDoubleTap:(UITapGestureRecognizer*)tap
{
    CGPoint touchPoint = [tap locationInView:tap.view];
    
    NSArray *cellArray = _imageGridView.visibleCells;
    for (MCImageGridCell *cell in cellArray) {
        [cell doubleTapWithPoint:touchPoint index:_currentIndex];
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer*)tap
{
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:false animated:false];//显示导航栏
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];  // 显示状态栏
    }else
    {
        [self.navigationController setNavigationBarHidden:true animated:false];//隐藏导航栏
        [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationNone];  // 隐藏状态栏
    }
}

#pragma mark - AQGridView Data Source and Delegate
- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView
{
	return [_dataSourceArray count];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger) index
{
	MCImageGridCell *cell = (MCImageGridCell *)[gridView dequeueReusableCellWithIdentifier:@"MCImageGridCell"];
	if (cell == nil) {
		cell = [[MCImageGridCell alloc] initWithFrame:gridView.bounds reuseIdentifier:@"MCImageGridCell"];
	}
    [cell initWithImage:_dataSourceArray[index] index:index];
    
	return cell;
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView
{
	return gridView.frame.size;
}


#pragma mark UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];//隐藏导航栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];  // 隐藏状态栏
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    _currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.title = [NSString stringWithFormat:@"%@ / %@", @(_currentIndex+1), @(_dataSourceArray.count)];
}

- (void)dealloc
{
    _imageGridView = nil;
}

@end
