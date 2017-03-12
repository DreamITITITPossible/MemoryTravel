//
//  SceVideoCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/16.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceVideoModel.h"
@class SceVideoModel;
@protocol SceVideoCellDelegate <NSObject>

- (void)ClickHeadImageViewPushToPersonalVCWithSceVideoModel:(SceVideoModel *)sceVideo;

@end
@interface SceVideoCell : UICollectionViewCell
@property (nonatomic, strong) SceVideoModel *sceVideo;
@property (nonatomic, weak) id<SceVideoCellDelegate> delegate;
@end
