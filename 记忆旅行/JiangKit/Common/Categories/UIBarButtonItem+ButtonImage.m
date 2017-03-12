//
//  UIBarButtonItem+ButtonImage.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "UIBarButtonItem+ButtonImage.h"
//#import <objc/runtime.h>
@implementation UIBarButtonItem (ButtonImage)
//static char overviewKey;
+(UIBarButtonItem *)getBarButtonItemWithImageName:(NSString *)imageName HighLightedImageName:(NSString *)imageNameHighlighted Size:(CGSize)size  targetBlock:(Callback)block {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    button.dk_tintColorPicker = DKColorPickerWithColors([UIColor blackColor], [UIColor whiteColor]);
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *imageHighlightedImage = [UIImage imageNamed:imageNameHighlighted];
    imageHighlightedImage = [imageHighlightedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:imageHighlightedImage forState:UIControlStateHighlighted];

    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        block();
    }];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
    
}

@end
