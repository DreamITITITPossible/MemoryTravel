//
//  PersonPicCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalList.h"
@class PersonPicCell;
@protocol PersonalPicCellDelegate <NSObject>
-(void)ClickCommentPushToVCAndCommentWithListResult:(PersonalList *)listResult;
-(void)voteChangedTableViewForPicCell:(PersonPicCell *)cell;
-(void)presentPersonPicToLoginIfNot;
@end

@interface PersonPicCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithPicCount:(NSInteger)picCount;
@property (nonatomic, weak) id<PersonalPicCellDelegate> delegate;

@property (nonatomic, strong) PersonalList *personalList;

@end
