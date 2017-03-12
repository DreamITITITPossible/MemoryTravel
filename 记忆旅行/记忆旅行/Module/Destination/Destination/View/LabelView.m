//
//  LabelView.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/14.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "LabelView.h"


@interface LabelView ()
@property (nonatomic, strong) UIImageView *likeCmtBg;
@property (strong, nonatomic) UILabel *numLabel;

@end
@implementation LabelView

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
    
    if (_likeCmtBg == nil) {
        x = 0;
        y = 0;
        width = self.frame.size.width;
        height = self.frame.size.height;
        
        _likeCmtBg = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        UIImage *image = [UIImage imageNamed:@"back_label"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 1, 15, 1) resizingMode:UIImageResizingModeStretch];
        _likeCmtBg.image = image;
        
        [self addSubview:_likeCmtBg];
    }
    self.numLabel = [[UILabel alloc] init];
    
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = [UIFont boldSystemFontOfSize:17];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_numLabel];
    
    
    
    
    
}
- (void)setNum:(NSString *)num {
    if (_num != num) {
        _num = num;
    }
    _numLabel.text = [NSString stringWithFormat:@"%@", _num];
    UIImage *image = [_likeCmtBg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    switch ([_num integerValue]) {
        case 1:
            _likeCmtBg.tintColor = JYXColor(255, 70, 0, 1);;
           _likeCmtBg.alpha = 1;
            break;
        case 2:
            _likeCmtBg.tintColor = [UIColor orangeColor];
            _likeCmtBg.alpha = 1;
            
            break;
        case 3:
            _likeCmtBg.tintColor = JYXColor(255, 230, 100, 1);
            _likeCmtBg.alpha = 1;
            
            break;
        default:
            _likeCmtBg.tintColor = [UIColor blackColor];

            _likeCmtBg.alpha = 0.5;
            
            break;
    }
    _likeCmtBg.image = image;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat labelHeight;
    labelHeight = [UILabel getHeightByWidth:self.width - 2 title:_numLabel.text font:_numLabel.font];
    _numLabel.frame = CGRectMake(1, 2, self.width - 2, labelHeight);
    
    
    
    _likeCmtBg.frame = self.bounds;
    
}


@end
