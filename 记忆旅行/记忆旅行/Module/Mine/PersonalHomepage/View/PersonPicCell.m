//
//  PersonPicCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "PersonPicCell.h"
#import "YHWorkGroupPhotoContainer.h"
#import "Sex_AgeView.h"
#import "PicList.h"

@interface PersonPicCell ()
@property (nonatomic, retain) UILabel *createDateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UIImageView *locationImageView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic,strong) YHWorkGroupPhotoContainer *picContainerView;
@property (nonatomic, assign) BOOL isReuse;
@end
@implementation PersonPicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithPicCount:(NSInteger)picCount {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.createDateLabel = [[UILabel alloc] init];
        _createDateLabel.font = kFONT_SIZE_13;
        _createDateLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_createDateLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        self.picContainerView = [[YHWorkGroupPhotoContainer alloc] initWithWidth:SCREEN_WIDTH-20];
        _picContainerView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [self.contentView addSubview:self.picContainerView];
        
        self.locationLabel = [[UILabel alloc] init];
        _locationLabel.font = kFONT_SIZE_13;
        _locationLabel.textColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];
        [self.contentView addSubview:_locationLabel];
        self.locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location"]];
        _locationLabel.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0], [UIColor darkGrayColor]);;
        [self.contentView addSubview:_locationImageView];
        for (int i = 0; i < picCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = 4000 + i;
            [self.contentView addSubview:imageView];
        }
        
        
        
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_likeButton setTitleColor:[UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [_likeButton setImage:[UIImage imageNamed:@"icon_like_null"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"icon_like_full"] forState:UIControlStateSelected];
        _likeButton.titleLabel.font = kFONT_SIZE_13;
        [self.contentView addSubview:_likeButton];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setTitleColor:[UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comments"] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = kFONT_SIZE_13;
        [self.contentView addSubview:_commentButton];
        
    }
    return self;
}
- (void)setPersonalList:(PersonalList *)personalList {
    if (_personalList != personalList) {
        _personalList = personalList;
    }
    
    
    _createDateLabel.text = [_personalList.vo.creatDate substringToIndex:10];
    _titleLabel.text = _personalList.vo.title;
    if ([_personalList.vo.UserPictureVo.adress isEqualToString:@"未知地址"]) {
        _locationLabel.hidden = YES;
        _locationImageView.hidden = YES;
    } else {
        _locationLabel.text = _personalList.vo.UserPictureVo.adress;
    }
    [_likeButton setTitle:_personalList.vo.UserPictureVo.vote forState:UIControlStateNormal];
    [_likeButton setTitle:_personalList.vo.UserPictureVo.vote forState:UIControlStateSelected];
    [_commentButton setTitle:_personalList.vo.UserPictureVo.commens forState:UIControlStateNormal];
    NSMutableArray *shortPicURLArr = [NSMutableArray array];
    NSMutableArray *picURLArr = [NSMutableArray array];
    for (PicList *pic in personalList.vo.UserPictureVo.picList) {
        [shortPicURLArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, pic.shrotPicURL]]];
        [picURLArr addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ssh2/%@", baseURL, pic.picURL]]];
    }
   
    _picContainerView.picUrlArray = shortPicURLArr;
    _picContainerView.picOriArray = picURLArr;
    if (_personalList.vo.isVote == 0) {
        _likeButton.selected = NO;
    } else {
        _likeButton.selected = YES;
    }
    self.count = [_personalList.vo.UserPictureVo.vote integerValue];
    
    
    [_likeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        
        User *user = [User getUserInfo];
        NSDictionary *dict = @{@"Cookie": [NSString stringWithFormat:@"JSESSIONID=%@", user.JSESSIONID]};
        if (user.isLogin == YES) {
#pragma mark - 点赞
            if (_likeButton.selected == 0) {
                NSString *urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/userinfo?&id=%@&num=1&cmd=addUserVideoAndPicNum&type=0", personalList.vo.UserPictureVo.ID];
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient GET:urlString body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
                    NSDictionary *dic = result;
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        [self.delegate voteChangedTableViewForPicCell:self];
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];                }
                } failure:^(NSError *error) {
                }];
                
                
            } else {
#pragma mark - 取消点赞
                NSString *urlString = [NSString stringWithFormat:@"http://www.yundao91.cn/ssh2/userinfo?&id=%@&num=-1&cmd=addUserVideoAndPicNum&type=0", personalList.vo.UserPictureVo.ID];
                
                
                HttpClient *httpClient = [[HttpClient alloc] init];
                [httpClient GET:urlString body:nil headerFile:dict response:JYX_JSON isShowHub:NO success:^(id result) {
                    NSDictionary *dic = result;
                    
                    NSNumber *flag = [dic objectForKey:@"flag"];
                    NSString *msg = [dic objectForKey:@"result"];
                    if ([flag isEqual:@1]) {
                        
                        [self.delegate voteChangedTableViewForPicCell:self];
                        
                    } else {
                        [MBProgressHUD showTipMessageInView:msg];
                    }
                } failure:^(NSError *error) {
                }];
                
            }
            
            
        } else {
            [self.delegate presentPersonPicToLoginIfNot];
        }
        
    }];
    [_commentButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        User *user = [User getUserInfo];
        if (user.isLogin) {
            
        [self.delegate ClickCommentPushToVCAndCommentWithListResult:_personalList];
        } else {
            [self.delegate presentPersonPicToLoginIfNot];
        }
        
    }];
    if (_isReuse == YES) {
        [self layoutSubviews];
        _isReuse = NO;
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat createDateWidth = [UILabel getWidthWithTitle:_createDateLabel.text font:_createDateLabel.font];
    _createDateLabel.frame = CGRectMake(20, 5, createDateWidth, 15);
    
    CGFloat titleHight = [UILabel getHeightByWidth:(SCREEN_WIDTH - 40) title:_titleLabel.text font:_titleLabel.font];
    _titleLabel.frame = CGRectMake(_createDateLabel.x, _createDateLabel.y + _createDateLabel.height + 5, SCREEN_WIDTH - 40, titleHight);
    NSInteger count = _personalList.vo.UserPictureVo.picList.count;
    CGFloat picHeight;
    if (count < 4) {
        picHeight = (SCREEN_WIDTH - 30) / 3;
    } else if (count >= 4 && count < 7) {
        picHeight = (SCREEN_WIDTH - 30) / 3 * 2 + 5;
    } else {
        picHeight = (SCREEN_WIDTH - 30) / 3 * 3 + 10;
    }

    _picContainerView.frame = CGRectMake(10, _titleLabel.y + _titleLabel.height + 10, SCREEN_WIDTH - 20, picHeight);
      _locationImageView.frame = CGRectMake(_picContainerView.x, _picContainerView.y + _picContainerView.height + 10, 24, 24);
    CGFloat width = [UILabel getWidthWithTitle:_locationLabel.text font:kFONT_SIZE_13];
    if (width > self.contentView.width / 2 - 5 - 24) {
        width = self.contentView.width / 2 - 5 - 24;
    }
    _locationLabel.frame = CGRectMake(_locationImageView.x + _locationImageView.width + 5, _locationImageView.y, width, _locationImageView.height);
    
    
    CGFloat likeButtonWidth = [UILabel getWidthWithTitle:_personalList.vo.cameraVideoVo.vote font:_likeButton.titleLabel.font];
    _likeButton.frame = CGRectMake(SCREEN_WIDTH - 150, _locationImageView.y, likeButtonWidth + 40, _locationImageView.height);
    CGSize likeimageSize = _likeButton.imageView.frame.size;
    _likeButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - likeimageSize.width / 2);
    CGSize liketitleSize = _likeButton.titleLabel.frame.size;
    _likeButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, - liketitleSize.width - 3, 0.0, 0.0);
    
    
    CGFloat commentButtonWidth = [UILabel getWidthWithTitle:_personalList.vo.cameraVideoVo.commens font:_commentButton.titleLabel.font];
    _commentButton.frame = CGRectMake(SCREEN_WIDTH - 80, _locationImageView.y, commentButtonWidth + 40, _locationImageView.height);
    CGSize commentimageSize = _commentButton.imageView.frame.size;
    _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - commentimageSize.width / 2);
    CGSize commenttitleSize = _commentButton.titleLabel.frame.size;
    _commentButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, - commenttitleSize.width - 3, 0.0, 0.0);
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    _locationLabel.hidden = NO;
    _locationImageView.hidden = NO;
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
