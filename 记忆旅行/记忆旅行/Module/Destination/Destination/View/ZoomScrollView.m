//
//  ZoomScrollView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/14.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "ZoomScrollView.h"

@interface ZoomScrollView ()
@property (nonatomic, retain) UIImageView *imageView;
@end
@implementation ZoomScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return self;
}
- (void)setImageURL:(NSString *)imageURL {
    if (_imageURL != imageURL) {
        _imageURL = imageURL;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed:@"downlaod_picture_fail"]];
    }
}



@end
