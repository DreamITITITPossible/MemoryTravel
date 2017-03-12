//
//  UILabel+TitleView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/28.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "UILabel+TitleView.h"

@implementation UILabel (TitleView)
+ (UILabel *)getTitleViewWithTitle:(NSString *)title {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = title;
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = kFONT_SIZE_18_BOLD;
        [titleLabel sizeToFit];
    return titleLabel;
}
@end
