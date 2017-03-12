//
//  PicDetailsTableViewCell.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/21.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonalList.h"
#import "Friends.h"
@protocol PicDetaislTableViewCellDelegate <NSObject>

- (void)picDetailsTapActionWithTouristID:(NSString *)touristID isOfficial:(NSString *)isOfficial;
- (void)presentPicDetailsToLoginVCIfNot;
@end
@interface PicDetailsTableViewCell : UITableViewCell
@property (nonatomic, strong) PersonalList *personalList;
@property (nonatomic, strong) Friends *friends;
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, weak) id<PicDetaislTableViewCellDelegate> delegate;
@end
