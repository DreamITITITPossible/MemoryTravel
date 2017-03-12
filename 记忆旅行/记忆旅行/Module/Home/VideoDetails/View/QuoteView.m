//
//  QuoteView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/22.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "QuoteView.h"

@interface QuoteView ()
@property (nonatomic, strong) UIImageView *likeCmtBg;
@property (strong, nonatomic) UILabel *quoteCommentLabel;

@end
@implementation QuoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        
        [self initView];
    }
    return self;
}


-(void) initView
{
    CGFloat x,y,width,height;
    
    if (_likeCmtBg == nil) {
        x = 0;
        y = 0;
        width = self.frame.size.width;
        height = self.frame.size.height;
        
        _likeCmtBg = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        UIImage *image = [UIImage imageNamed:@"LikeCmtBg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 10, 10) resizingMode:UIImageResizingModeStretch];
        _likeCmtBg.dk_tintColorPicker = DKColorPickerWithColors(JYXColor(230, 230, 230, 1), JYXColor(150, 150, 150, 1));
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _likeCmtBg.image = image;
        [self addSubview:_likeCmtBg];
    }
    self.quoteCommentLabel = [[UILabel alloc] init];
    _quoteCommentLabel.dk_textColorPicker = DKColorPickerWithColors(JYXColor(200, 200, 200, 1), JYXColor(100, 100, 100, 1));
    _quoteCommentLabel.font = [UIFont systemFontOfSize:17];
    _quoteCommentLabel.numberOfLines = 0;
    _quoteCommentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_quoteCommentLabel];
    
  
    
    
    
}
- (void)setContent:(CommentsContent *)content {
    if (_content != content) {
        _content = content;
    }
    _quoteCommentLabel.text = [NSString stringWithFormat:@"引用@%@:%@", _content.pidNickname, _content.pidComment];
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat labelHeight;
    labelHeight = [UILabel getHeightByWidth:self.width - 16 title:_quoteCommentLabel.text font:_quoteCommentLabel.font];
    _quoteCommentLabel.frame = CGRectMake(8, 8, self.width - 16, labelHeight);
    _likeCmtBg.frame = self.bounds;
    
}


    
    
    







@end
