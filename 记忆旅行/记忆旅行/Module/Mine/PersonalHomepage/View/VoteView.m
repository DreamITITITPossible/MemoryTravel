//
//  VoteView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/25.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "VoteView.h"

@interface VoteView ()
@property (nonatomic, strong) UIImageView *voteImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *voteLabel;
@end
@implementation VoteView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self initView];
    }
    return self;
}


-(void) initView
{
    CGFloat x,y,width,height;
    
    if (_backImageView == nil) {
        x = 0;
        y = 0;
        width = self.frame.size.width;
        height = self.frame.size.height;
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        UIImage *image = [UIImage imageNamed:@"pink"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5) resizingMode:UIImageResizingModeStretch];
        _backImageView.image = image;
        [self addSubview:_backImageView];
    }
    self.voteImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vote_white"]];
    [self addSubview:_voteImageView];
    
    self.voteLabel = [[UILabel alloc] init];
    _voteLabel.textColor = [UIColor whiteColor];
    _voteLabel.font = [UIFont boldSystemFontOfSize:11];
    _voteLabel.numberOfLines = 0;
    _voteLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_voteLabel];
    
    
}
- (void)setVote:(NSString *)vote {
    if (_vote != vote) {
        _vote = vote;
    }
    
    _voteLabel.text = [NSString stringWithFormat:@"被赞%@次", _vote];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _voteImageView.frame = CGRectMake(10, 5, 12, 12);
    
    CGFloat labelWidth;
    
    
    labelWidth = [UILabel getWidthWithTitle:_voteLabel.text font:_voteLabel.font];
    _voteLabel.frame = CGRectMake(23, 6, labelWidth, self.height - 10);
    
    _backImageView.frame = self.bounds;

    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
