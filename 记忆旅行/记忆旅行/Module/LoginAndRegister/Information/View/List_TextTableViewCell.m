//
//  List_TextTableViewCell.m
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/17.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "List_TextTableViewCell.h"

@interface List_TextTableViewCell ()
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *infoLabel;
@end
@implementation List_TextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFONT_SIZE_15_BOLD;
        _titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);

        [self.contentView addSubview:_titleLabel];
        
        self.infoLabel = [[UILabel alloc] init];
        _infoLabel.font = kFONT_SIZE_15_BOLD;
        _infoLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}
- (void)setListTitle:(NSString *)listTitle {
    if (_listTitle != listTitle) {
        _listTitle = listTitle;
    }
    _titleLabel.text = listTitle;
}
- (void)setInfo:(NSString *)info {
    if (_info != info) {
        _info = info;
    }
    _infoLabel.text = info;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat labelWidth = [UILabel getWidthWithTitle:_titleLabel.text font:_titleLabel.font];
    _titleLabel.frame = CGRectMake(15, 12, labelWidth, 20);
    
    CGFloat infoWidth = [UILabel getWidthWithTitle:_infoLabel.text font:_infoLabel.font];
    
    if (infoWidth > 200) {
        infoWidth = 200;
    }
    _infoLabel.frame = CGRectMake(SCREEN_WIDTH - infoWidth -40, 13, infoWidth, 20);
    
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
