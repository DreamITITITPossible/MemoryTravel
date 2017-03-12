//
//  SceBtnCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/15.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceBtnView.h"
#import "ScenicSpotsModel.h"

@protocol SceBtnCellDelegate <NSObject>

- (void)getWebViewHeight:(CGFloat)height;
- (void)clickWithIndex:(NSInteger)index;

@end
@interface SceBtnCell : UITableViewCell
@property (nonatomic, strong) SceBtnView *sceBtnView;
@property (nonatomic, strong) ScenicSpotsModel *scenicSpots;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, weak) id<SceBtnCellDelegate> delegate;
@end
