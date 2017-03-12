//
//  UIBarButtonItem+ButtonImage.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Callback)();

@interface UIBarButtonItem (ButtonImage)
+(UIBarButtonItem *)getBarButtonItemWithImageName:(NSString *)imageName HighLightedImageName:(NSString *)imageNameHighlighted Size:(CGSize)size targetBlock:(Callback)block;
@end
