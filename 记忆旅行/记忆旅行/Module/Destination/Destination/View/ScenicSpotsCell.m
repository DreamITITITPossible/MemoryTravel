//
//  ScenicSpotsCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/14.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "ScenicSpotsCell.h"
#import "LabelView.h"

@interface ScenicSpotsCell ()
@property (nonatomic, strong) UIImageView *backImagView;
@property (nonatomic, strong) LabelView *labelView;
@property (nonatomic, strong) UIImageView *liveImageView;

@property (nonatomic, strong) UILabel *scenicSpotsNameLabel;
@property (nonatomic, strong) UILabel *wantCountLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, assign) BOOL isReuse;
@end
@implementation ScenicSpotsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backImagView = [[UIImageView alloc] init];
        [self.contentView addSubview:_backImagView];
        self.labelView = [[LabelView alloc] init];
        [self.backImagView addSubview:_labelView];
        self.liveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_live"]];
//        self.clipsToBounds = YES;
        [self.backImagView addSubview:_liveImageView];

        self.scenicSpotsNameLabel = [[UILabel alloc] init];
        _scenicSpotsNameLabel.font = [UIFont boldSystemFontOfSize:20];
        _scenicSpotsNameLabel.textColor = [UIColor whiteColor];
        _scenicSpotsNameLabel.backgroundColor = [UIColor clearColor];
        _scenicSpotsNameLabel.shadowColor = JYXColor(0, 0, 0, 0.5);
        _scenicSpotsNameLabel.shadowOffset = CGSizeMake(0, -1.0);
        _scenicSpotsNameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.backImagView addSubview:_scenicSpotsNameLabel];
        
        self.wantCountLabel = [[UILabel alloc] init];
        _wantCountLabel.font = [UIFont systemFontOfSize:13];
        _wantCountLabel.textColor = [UIColor whiteColor];
        _wantCountLabel.backgroundColor = [UIColor clearColor];
        _wantCountLabel.textAlignment = NSTextAlignmentCenter;
        [self.backImagView addSubview:_wantCountLabel];
        
        self.introLabel = [[UILabel alloc] init];
        _introLabel.font = [UIFont boldSystemFontOfSize:14];
        _introLabel.textColor = [UIColor whiteColor];
        _introLabel.textAlignment = NSTextAlignmentCenter;
        _introLabel.numberOfLines = 1;
        _introLabel.backgroundColor = [UIColor clearColor];
        [self.backImagView addSubview:_introLabel];
        
    }
    return self;
    
}

- (void)setScenicSpots:(ScenicSpotsModel *)scenicSpots {
    if (_scenicSpots != scenicSpots) {
        _scenicSpots = scenicSpots;
    }
    [_backImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, _scenicSpots.picUrl]] placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    if (scenicSpots.isLive == NO) {
        _liveImageView.image = nil;
    }
    _labelView.num = scenicSpots.showIndex;
    _scenicSpotsNameLabel.text = scenicSpots.titleName;
    _wantCountLabel.text = [NSString stringWithFormat:@"%@人想去", scenicSpots.wantGo];
    _introLabel.text = scenicSpots.remark;
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _backImagView.frame = CGRectMake(0, 0, self.contentView.width, 195);
    _labelView.frame = CGRectMake(15, -2, 40, 30);
   
    _liveImageView.frame = CGRectMake(_backImagView.width - 50, 0, 40, 40);
    
    _scenicSpotsNameLabel.frame = CGRectMake(50, _backImagView.centerY - 60, SCREEN_WIDTH - 100, 25);
    _wantCountLabel.frame = CGRectMake(50, _scenicSpotsNameLabel.y + _scenicSpotsNameLabel.height + 25, SCREEN_WIDTH - 100, 13);
    _introLabel.frame = CGRectMake(35, _wantCountLabel.y + _wantCountLabel.height + 50, SCREEN_WIDTH - 35, 15);
  
}
- (void)prepareForReuse {
    [super prepareForReuse];
    
        self.liveImageView.image = [UIImage imageNamed:@"icon_live"];
    _isReuse = YES;
    

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
