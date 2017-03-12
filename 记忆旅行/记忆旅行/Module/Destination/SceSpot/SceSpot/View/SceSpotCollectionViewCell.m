//
//  SceSpotCollectionViewCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "SceSpotCollectionViewCell.h"

@interface SceSpotCollectionViewCell ()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *sceSpotNameLabel;
@end
@implementation SceSpotCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_backImageView];
        self.sceSpotNameLabel = [[UILabel alloc] init];
        _sceSpotNameLabel.textColor = [UIColor whiteColor];
        _sceSpotNameLabel.backgroundColor = JYXColor(0, 0, 0, 0.4);
        _sceSpotNameLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_sceSpotNameLabel];
    }
    return self;
}
- (void)setSceSpot:(SceSpotModel *)sceSpot {
    if (_sceSpot != sceSpot) {
        _sceSpot = sceSpot;
    }
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _sceSpot.MapMark]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _sceSpotNameLabel.text = [NSString stringWithFormat:@" %@", _sceSpot.SceName];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _backImageView.frame = self.contentView.bounds;
    _sceSpotNameLabel.frame = CGRectMake(0, _backImageView.height - 30, _backImageView.width, 30);
}

@end
