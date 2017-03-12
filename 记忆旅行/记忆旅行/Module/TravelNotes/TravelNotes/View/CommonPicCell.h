//
//  CommonPicCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home_VideoListResult.h"
#import "Friends.h"
@class CommonPicCell;
@protocol CommonPicCellDelegate <NSObject>

-(void)ClickHeadImageViewPushToPersonalVCWithFriends:(Friends *)friends;
-(void)ClickCommentPushToVCAndCommentWithFriend:(Friends *)friends;
-(void)voteChangedTableViewForCommonPicCell:(CommonPicCell *)cell;

@end
@interface CommonPicCell : UITableViewCell

@property (nonatomic, weak) id<CommonPicCellDelegate> delegate;
@property (nonatomic, strong) Friends *friends;

@end
