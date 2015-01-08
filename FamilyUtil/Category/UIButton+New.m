//
//  UIButton+New.m
//  HLMagic
//
//  Created by marujun on 13-12-6.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import "UIButton+New.h"

@implementation UIButton (New)


//蓝色箭头的返回按钮
+ (UIButton *)newBackArrowNavButtonWithTarget:(id)target action:(SEL)action
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    
    [rightButton setImage:[UIImage imageNamed:(@"pub_back_arrow.png")] forState:UIControlStateNormal];
    if (action && target) {
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return rightButton;
}

+ (UIButton *)newClearNavButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    float height = 44;
    UIFont *font = [UIFont systemFontOfSize:15];
    float width = [title stringWidthWithFont:font height:height];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width + 5, height)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.titleLabel.font = font;
    
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:RGBCOLOR(1, 113, 239) forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    if (action && target) {
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return rightButton;
}

+ (UIButton *)newMoreButtonWithTarget:(id)target action:(SEL)action
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [rightButton setContentEdgeInsets:UIEdgeInsetsMake(19, 16, 20, 8)];
    [rightButton setImage:[UIImage imageNamed:(@"chat_omit.png")] forState:UIControlStateNormal];
    if (action && target) {
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return rightButton;
}

@end
