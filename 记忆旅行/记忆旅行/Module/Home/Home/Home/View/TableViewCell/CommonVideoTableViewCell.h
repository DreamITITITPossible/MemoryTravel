//
//  CommonVideoTableViewCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/20.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home_VideoListResult.h"
#import "Friends.h"
@class CommonVideoTableViewCell;
@protocol CommonViewoTableViewCellDelegate <NSObject>

-(void)ClickHeadImageViewPushToPersonalVCWithArray:(NSMutableArray*)array type:(NSString*)type;
-(void)ClickCommentPushToVCAndCommentWithArray:(NSMutableArray*)array type:(NSString*)type;
-(void)voteChangedTableViewForCommonVideoCell:(CommonVideoTableViewCell *)cell;
- (void)presentToLoginIfNot;
@end
@interface CommonVideoTableViewCell : UITableViewCell
@property (nonatomic, weak) id<CommonViewoTableViewCellDelegate> delegate;
@property (nonatomic, strong) Friends *friends;
@property (nonatomic, strong) Home_VideoListResult *homeListResult;
@property (nonatomic, strong) UIImageView *videoBackImgBlurView;
@end
