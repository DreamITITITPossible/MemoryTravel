//
//  ImageLabelView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "ImageLabelView.h"

@interface ImageLabelView ()
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *rightLabel;
@end
@implementation ImageLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
        _leftImageView.layer.cornerRadius = 3;
        _leftImageView.backgroundColor = JYXColor(191, 191, 191, 1);
        _leftImageView.clipsToBounds = YES;
        [self addSubview:_leftImageView];
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftImageView.x + _leftImageView.width + 3, 0, self.width - _leftImageView.width - 3, self.height)];
        _rightLabel.textColor = JYXColor(191, 191, 191, 1);
        _rightLabel.font = [UIFont systemFontOfSize:13];
        _rightLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightLabel];
        
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
    }
    _rightLabel.text = title;
}
- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = imageName;
    }
    _leftImageView.image = [UIImage imageNamed:imageName];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _leftImageView.frame = CGRectMake(0, 0, self.height, self.height);
    _rightLabel.frame = CGRectMake(_leftImageView.x + _leftImageView.width + 3, 0, self.width - _leftImageView.width - 3, self.height);

}
@end
