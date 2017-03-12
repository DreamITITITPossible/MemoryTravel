//
//  JiangFlashLabel.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/3/11.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiangFlashLabel : UILabel
@property (nonatomic, strong) UIColor *spotlightColor;

- (void)startAnimating;

- (void)stopAnimating;
@end
