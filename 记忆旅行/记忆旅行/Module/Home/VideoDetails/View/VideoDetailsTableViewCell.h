//
//  VideoDetailsTableViewCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home_VideoListResult.h"
#import "PersonalList.h"
#import "SceVideoModel.h"
#import "Friends.h"
@protocol DetaislTableViewCellDelegate <NSObject>

- (void)detailsTapActionWithTouristID:(NSString *)touristID isOfficial:(NSString *)isOfficial;
- (void)presentVideoDetailsToLoginVCIfNot;
@end
@interface VideoDetailsTableViewCell : UITableViewCell
@property (nonatomic, strong) Home_VideoListResult *homeListResult;
@property (nonatomic, strong) PersonalList *personalList;
@property (nonatomic, strong) SceVideoModel *sceVideo;
@property (nonatomic, strong) Friends *friends;
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, strong) UIImageView *videoBackImgBlurView;
@property (nonatomic, weak) id<DetaislTableViewCellDelegate> delegate;
@end
