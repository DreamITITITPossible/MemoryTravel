//
//  AlbumZoomScrollView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "AlbumZoomScrollView.h"
@interface AlbumZoomScrollView ()
@property (nonatomic, retain) UIImageView *imageView;
@end
@implementation AlbumZoomScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 32)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        //最短长按时间
        longPress.minimumPressDuration = 1;
        //允许移动最大距离
        longPress.allowableMovement = 1;
        //添加到指定视图
        [_imageView addGestureRecognizer:longPress];
        
    
          [self addSubview:_imageView];
    }
    return self;
}
//长按事件
-(void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    
    //NSLog(@"长按");
    //对于长安有开始和 结束状态
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按开始");
        
        [self.saveDelegate saveToPhotoWithImage:_imageView.image ImageURL:_imgUrl];
    }else if (longPress.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"长按结束");
    }
    
}


- (void)setImgUrl:(NSString *)imgUrl {
    if (_imgUrl != imgUrl) {
        _imgUrl = imgUrl;
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];

}

@end
