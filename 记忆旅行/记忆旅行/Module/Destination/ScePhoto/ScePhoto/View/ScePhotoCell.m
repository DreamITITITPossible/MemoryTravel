//
//  ScePhotoCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/18.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "ScePhotoCell.h"

@interface ScePhotoCell ()

@property (nonatomic, retain) UIImageView *myImageView;
@end
@implementation ScePhotoCell




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_myImageView];
    }
    return self;
}
- (void)setScePhoto:(ScePhotoModel *)scePhoto {
    if (_scePhoto != scePhoto) {
        _scePhoto = scePhoto;
    }
     [_myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, scePhoto.picPath]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
}
- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        _myImageView.image = _image;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _myImageView.frame = self.contentView.bounds;
}

@end
