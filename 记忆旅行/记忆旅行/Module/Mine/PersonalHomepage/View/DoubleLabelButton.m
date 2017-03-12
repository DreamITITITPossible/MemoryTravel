//
//  DoubleLabelButton.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/25.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "DoubleLabelButton.h"

@interface DoubleLabelButton ()
@property (nonatomic, strong) UILabel *titlessLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation DoubleLabelButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height / 2)];
        _contentLabel.font = kFONT_SIZE_13;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contentLabel];
        self.titlessLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height / 2, self.width, self.height / 2)];
        _titlessLabel.font = kFONT_SIZE_10;
        _titlessLabel.textAlignment = NSTextAlignmentCenter;
        _titlessLabel.textColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        [self addSubview:_titlessLabel];
      
    }
    return self;
}
- (void)setContent:(NSString *)content {
    if (_content != content) {
        _content = content;
    }
    _contentLabel.text = _content;
}
- (void)setTitless:(NSString *)titless {
    if (_titless != titless) {
        _titless = titless;
    }
    _titlessLabel.text = _titless;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
