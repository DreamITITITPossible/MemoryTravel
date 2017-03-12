//
//  SceBtnView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/15.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceBtnView.h"

@interface SceBtnView ()
@property (nonatomic, strong) UIButton *sceImageBtn;
@property (nonatomic, strong) UILabel *sceLabel;
@end
@implementation SceBtnView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sceImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sceImageBtn.frame = CGRectMake(self.width / 2 - 20, 10, 40, 40);
        _sceImageBtn.layer.cornerRadius = 20;
        _sceImageBtn.clipsToBounds = YES;
        _sceImageBtn.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [_sceImageBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sceImageBtn];
        self.sceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2 - 20, _sceImageBtn.y + _sceImageBtn.height + 10, 40, 20)];
        _sceLabel.dk_textColorPicker =DKColorPickerWithKey(TEXT);
        _sceLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _sceLabel.font = kFONT_SIZE_18;
        _sceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_sceLabel];
        
    }
    return self;
}
- (void)setTitleName:(NSString *)titleName {
    if (_titleName != titleName) {
        _titleName = titleName;
    }
    _sceLabel.text = _titleName;
}
- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = imageName;
    }
    [_sceImageBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
- (void)setIndex:(NSInteger)index {
    if (_index != index) {
        _index = index;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _sceImageBtn.frame = CGRectMake(self.width / 2 - 20, 10, 40, 40);
    self.sceLabel.frame = CGRectMake(self.width / 2 - 20, _sceImageBtn.y + _sceImageBtn.height + 10, 40, 20);

}

- (void)clickAction:(UIButton *)btn {
    [self.delegate ClickBtnPushToVCWithIndex:_index];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
