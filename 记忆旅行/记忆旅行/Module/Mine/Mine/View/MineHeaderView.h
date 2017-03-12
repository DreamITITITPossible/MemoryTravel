//
//  MineHeaderView.h
//  记忆旅行
//
//  Created by DreamItPossible on 2017/2/23.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonalInfo.h"

@protocol MineHeaderViewDelegate <NSObject>

- (void)ClickFans_AttentionBtnPushToVCWithType:(NSString *)type TouristID:(NSString *)touristID;
- (void)clickHeadImageViewPushToModificationInfo;
- (void)clickMemberViewPushToPersonalHomePageWithPersonalInfo:(PersonalInfo *)personalInfo;
@end
@interface MineHeaderView : UIView
@property (nonatomic, strong) PersonalInfo *personalInfo;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, weak) id<MineHeaderViewDelegate> delegate;

@end
