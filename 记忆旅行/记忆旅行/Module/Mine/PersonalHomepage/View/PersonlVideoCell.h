//
//  PersonlVideoCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/1/26.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalList.h"
@class PersonlVideoCell;
@protocol PersonalVideoCellDelegate <NSObject>
-(void)ClickCommentPushToVCAndCommentWithListResult:(PersonalList *)listResult;
-(void)voteChangedTableViewForVideoCell:(PersonlVideoCell *)cell;
- (void)presentPersonVideoToLoginIfNot;
@end

@interface PersonlVideoCell : UITableViewCell

@property (nonatomic, weak) id<PersonalVideoCellDelegate> delegate;

@property (nonatomic, strong) PersonalList *personalList;
@property (nonatomic, strong) UIImageView *videoBackImgBlurView;
@end
