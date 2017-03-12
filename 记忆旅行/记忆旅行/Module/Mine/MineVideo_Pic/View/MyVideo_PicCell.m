//
//  MyVideo_PicCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "MyVideo_PicCell.h"
#import "ImageLabelView.h"
#import "PicList.h"
@interface MyVideo_PicCell ()
@property (nonatomic, retain) UIImageView *video_picImageView;
@property (nonatomic, retain) UILabel *hourlLong_CountLabel;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UIImageView *locationImageView;
@property (nonatomic, assign) BOOL isReuse;
@end
@implementation MyVideo_PicCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.video_picImageView = [[UIImageView alloc] init];

        [self.contentView addSubview:_video_picImageView];
        self.hourlLong_CountLabel = [[UILabel alloc] init];
        _hourlLong_CountLabel.backgroundColor = JYXColor(0, 0, 0, 0.4);
        _hourlLong_CountLabel.textColor = [UIColor whiteColor];
        _hourlLong_CountLabel.font = kFONT_SIZE_13;
        [_video_picImageView addSubview:_hourlLong_CountLabel];
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self.contentView addSubview:_titleLabel];
        self.dateLabel = [[UILabel alloc] init];
        _dateLabel.font = kFONT_SIZE_12;
        _dateLabel.textColor = JYXColor(200, 200, 200, 1);
        _dateLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dateLabel];
        for (int i = 0; i < 4; i++) {
            ImageLabelView *imageLabelView = [[ImageLabelView alloc] init];
            imageLabelView.backgroundColor = [UIColor clearColor];
            imageLabelView.tag = 1559 + i;
            [self.contentView addSubview:imageLabelView];
        }
        self.locationLabel = [[UILabel alloc] init];
        _locationLabel.font = kFONT_SIZE_13;
        _locationLabel.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0], [UIColor darkGrayColor]);
        _locationLabel.textColor = JYXColor(200, 200, 200, 1);
        [self.contentView addSubview:_locationLabel];
        self.locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location"]];
        [self.contentView addSubview:_locationImageView];
    }
    return self;
}
- (void)setSceVideo:(SceVideoModel *)sceVideo {
    if (_sceVideo != sceVideo) {
        _sceVideo = sceVideo;
    }
    [_video_picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, sceVideo.videoPic]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _hourlLong_CountLabel.text = sceVideo.hour_long;
    _titleLabel.text = sceVideo.videoName;
    NSDate *createdDate = [NSDate dateWithString:sceVideo.creatDate format:@"yyyy-MM-dd HH:mm:ss"];
    _dateLabel.text = [createdDate timeAgoThreeDays];
    NSArray *titleArr = @[sceVideo.reviews, sceVideo.vote, sceVideo.shareNum, sceVideo.commens];
    NSArray *imageNameArr = @[@"icon_review_white",@"icon_vote_white",@"icon_share_white",@"icon_commen_white"];
    for (int i = 0; i < 4; i++) {
        ImageLabelView *imageLabel = [self.contentView viewWithTag:1559 + i];
        imageLabel.title = titleArr[i];
        imageLabel.imageName = imageNameArr[i];
    }
    _locationLabel.text = sceVideo.videoAdress;
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}
- (void)setPersonalList:(PersonalList *)personalList {
    if (_personalList != personalList) {
        _personalList = personalList;
    }
    PicList *piclist = [personalList.vo.UserPictureVo.picList firstObject];
    [_video_picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, piclist.picURL]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    _hourlLong_CountLabel.text = [NSString stringWithFormat:@"共%ld张", personalList.vo.UserPictureVo.picList.count];
    _titleLabel.text = personalList.vo.UserPictureVo.title;
    NSDate *createdDate = [NSDate dateWithString:personalList.vo.UserPictureVo.creatDate format:@"yyyy-MM-dd HH:mm:ss"];
    _dateLabel.text = [createdDate timeAgoThreeDays];
    NSArray *titleArr = @[personalList.vo.UserPictureVo.reviews, personalList.vo.UserPictureVo.vote, personalList.vo.UserPictureVo.sharNum, personalList.vo.UserPictureVo.commens];
    NSArray *imageNameArr = @[@"icon_review_white",@"icon_vote_white",@"icon_share_white",@"icon_commen_white"];
    for (int i = 0; i < 4; i++) {
        ImageLabelView *imageLabel = [self.contentView viewWithTag:1559 + i];
        imageLabel.title = titleArr[i];
        imageLabel.imageName = imageNameArr[i];
    }
    _locationLabel.text = personalList.vo.UserPictureVo.adress;
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }

}
- (void)prepareForReuse {
    [super prepareForReuse];
    _isReuse = YES;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _video_picImageView.frame = CGRectMake(0, 0, self.contentView.height, self.contentView.height);

    CGFloat hourlong_countWidth = [UILabel getWidthWithTitle:_hourlLong_CountLabel.text font:_hourlLong_CountLabel.font];
    _hourlLong_CountLabel.frame = CGRectMake(_video_picImageView.width - hourlong_countWidth - 5, _video_picImageView.height - 20, hourlong_countWidth, 15);
    
    _titleLabel.frame = CGRectMake(_video_picImageView.x + _video_picImageView.width + 10, 10, self.contentView.width - (_video_picImageView.x + _video_picImageView.width + 10) - 20, 20);
    _dateLabel.frame = CGRectMake(_titleLabel.x, _titleLabel.y + _titleLabel.height + 15, 150, 13);
    for (int i = 0; i < 4; i++) {
        ImageLabelView *imageLabel = [self.contentView viewWithTag:1559 + i];
        imageLabel.frame = CGRectMake(_dateLabel.x + (self.contentView.width - _dateLabel.x - 10) / 4 * i, _dateLabel.y + _dateLabel.height + 15 , (self.contentView.width - _dateLabel.x - 10) / 4, 15);
    }
    ImageLabelView *imageLabel = [self.contentView viewWithTag:1559];
    _locationImageView.frame = CGRectMake(imageLabel.x, imageLabel.y + imageLabel.height + 10, 24, 24);
    CGFloat width = [UILabel getWidthWithTitle:_locationLabel.text font:_locationLabel.font];
    if (width > self.contentView.width / 2 - 5 - 24) {
        width = self.contentView.width / 2 - 5 - 24;
    }
    _locationLabel.frame = CGRectMake(_locationImageView.x + _locationImageView.width + 5, _locationImageView.y, width, _locationImageView.height);
    
}


@end
