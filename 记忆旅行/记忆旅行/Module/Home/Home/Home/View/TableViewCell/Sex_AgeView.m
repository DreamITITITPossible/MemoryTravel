//
//  Sex_AgeView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/20.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "Sex_AgeView.h"
@interface Sex_AgeView ()
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIView *customView;
@end

@implementation Sex_AgeView

@synthesize age = _age;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.customView = [[UIView alloc] init];
        _customView.clipsToBounds = YES;
        _customView.layer.cornerRadius = 10;
        [self addSubview:_customView];
        
        self.imageView = [[UIImageView alloc] init];
        
        [_customView addSubview:_imageView];
        
        
        self.label = [[UILabel alloc] init];
        _label.textColor = [UIColor lightGrayColor];
        [_customView addSubview:_label];
        
        
        
        
    }
    return self;
}


- (void)setFont:(UIFont *)font {
    if (_font != font) {
        _font = font;
    }
    _label.font = font;
    

}

//- (void)setSex:(NSString *)sex {
//    if (_sex != sex) {
//        _sex = sex;
//        if ([_sex isEqualToString:@"男"]) {
//            UIImage *nanImage = [UIImage imageNamed:@"me_sex_nan"];
//            _imageView.dk_tintColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor lightGrayColor]);
//            nanImage = [nanImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//            _imageView.image = nanImage;
//            _label.dk_textColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor lightGrayColor]);
//            _customView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor colorWithRed:180.0 / 255.0 green:220.0 / 255.0 blue:255.0 / 255.0 alpha:1.0], JYXColor(112, 158, 190, 1));
//            
//        } else {
//            _imageView.dk_tintColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor lightGrayColor]);
//            UIImage *nvImage = [UIImage imageNamed:@"me_sex_nv"];
//            nvImage = [nvImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//            _imageView.image = nvImage;
//            _label.dk_textColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor lightGrayColor]);
//            _customView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor colorWithRed:251.0 / 255.0 green:196.0 / 255.0 blue:236.0 / 255.0 alpha:1.0], JYXColor(194, 153, 183, 1));
//        }
//    }
//}

- (void)setSex:(NSString *)sex {
    if (_sex != sex) {
        _sex = sex;
        if ([_sex isEqualToString:@"男"]) {
            _imageView.image = [UIImage imageNamed:@"me_sex_nan"];
            _label.textColor = [UIColor whiteColor];
            _customView.backgroundColor = [UIColor colorWithRed:180.0 / 255.0 green:220.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
            
            _customView.layer.borderColor = [UIColor colorWithRed:180.0 / 255.0 green:220.0 / 255.0 blue:255.0 / 255.0 alpha:1.0].CGColor;
        } else {
            _imageView.image = [UIImage imageNamed:@"me_sex_nv"];
            _label.textColor = [UIColor whiteColor];
            _customView.backgroundColor = [UIColor colorWithRed:251.0 / 255.0 green:196.0 / 255.0 blue:236.0 / 255.0 alpha:1.0];
            _customView.layer.borderColor = [UIColor colorWithRed:251.0 / 255.0 green:196.0 / 255.0 blue:236.0 / 255.0 alpha:1.0].CGColor;
        }
    }
}
- (void)setAge:(NSString *)age {
    if (_age != age) {
        _age = age;
    }
    self.label.text = [NSString stringWithFormat:@"%@", _age];
    [self layoutSubviews];
}
- (NSString *)age {
    _age = self.label.text;
    return _age;
}
- (void)layoutSubviews {
    [super subviews];
    if ([_sex isEqualToString:@"男"]) {
        _imageView.frame = CGRectMake(10, 4, 10, 12);
    } else {
        _imageView.frame = CGRectMake(10, 4, 8, 12);
    }
    CGFloat width = [UILabel getWidthWithTitle:_label.text font:_label.font];
    CGFloat height = [UILabel getHeightByWidth:20 title:_label.text font:_label.font];
    _label.frame = CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width + 3, _imageView.centerY - height / 2, width, height);
    
    _customView.frame = CGRectMake(_imageView.frame.origin.x - 10, 0, _label.frame.origin.x + _label.frame.size.width + 10 - _imageView.frame.origin.x + 10, 20);
}


@end
